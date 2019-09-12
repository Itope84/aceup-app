import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/pages/slides-complete.dart';
import 'package:aceup/pages/topic/default-slide.dart';
import 'package:aceup/pages/topic/question-slide.dart';
import 'package:aceup/widgets/error.dart';
import 'package:aceup/widgets/fullpage-loader.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class SlideContainer extends StatefulWidget {
  final Topic topic;
  
  SlideContainer({this.topic});
  @override
  _SlideContainerState createState() => _SlideContainerState();
}

class _SlideContainerState extends State<SlideContainer> {
  PageController _controller;
  Topic _topic;
  MainModel _model = new MainModel();
  Future<Map<String, dynamic>> _slides;

  @override
  void initState() {
    
    super.initState();
    _topic = widget.topic;
    _slides = slides();
  }

  Future<Map<String, dynamic>> slides() async {
    List<Slide> slides = await _model.slides(_topic);
    int initialPage = await _model.getLastSlideIndex(_topic);

    return {
      'slides': slides,
      'initialPage': initialPage
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: Scaffold(
          body: ScopedModelDescendant<MainModel>(
            builder: (context, widget, model) {
              print("rendering");
              return FutureBuilder(
                future: _slides,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return loadingIndicator(() async {
                        try {
                          await model.getSlidesAndQuestionsFromApi(_topic);
                        } finally {}
                      });
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data['slides'] != null) {
                        List<Slide> slides = snapshot.data['slides'];
                        _controller = PageController(initialPage: snapshot.data['initialPage'] != null ? snapshot.data['initialPage'] : 0);
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (index) async {
                              await model.storeLastSlide(index, slides[index].topicId);
                            },
                            physics: BouncingScrollPhysics(),
                            children: List.generate(slides.length + 1, (index) {
                              return index == slides.length
                                  ? SlidesComplete(
                                      topic: _topic,
                                    )
                                  : slides[index].isQuestion
                                      ? QuestionSlide(
                                          title: _topic.title,
                                          slide: slides[index],
                                          nextSlide: () {
                                            _controller.jumpToPage(index + 1);
                                          },
                                        )
                                      : DefaultSlide(
                                          title: _topic.title,
                                          index: index,
                                          total: slides.length,
                                          slide: slides[index],
                                          jumpTo: (int page) async {
                                            _controller.jumpToPage(page);
                                          },
                                        );
                            }),
                            scrollDirection: Axis.horizontal,
                          ),
                        );
                      }

                      return nothingFound(() async {
                        try {
                          await model.slides(_topic);
                        } finally {}
                      });
                    default:
                      return nothingFound(() async {
                        try {
                          await model.slides(_topic);
                        } finally {}
                      });
                  }
                },
              );
            },
          ),
        ));
  }

  Widget nothingFound(Function onRefresh) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        await onRefresh();
      },
      child: PageHolder(
        child: ErrorOccured(
          customText:
              "Something went wrong. \n Please check your internet and pull down to refresh",
        ),
        title: _topic.title,
      ),
    );
  }

  Widget loadingIndicator(Function onRefresh) {
    return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          await onRefresh();
        },
        child: PageHolder(
          title: _topic.title,
          child: FullPageLoader(
            child: Text(
              "Fetching content. \n Don't worry, this only happens the first time. \n If it takes too long, swipe down to refresh",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ));
  }
}

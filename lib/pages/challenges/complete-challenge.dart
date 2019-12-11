import 'package:aceup/pages/challenges/challenge-questions.dart';
import 'package:aceup/pages/json-classes/challenge.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:flutter/material.dart';

class CompleteChallenge extends StatefulWidget {
  final Challenge challenge;
  CompleteChallenge({this.challenge});

  @override
  _CompleteChallengeState createState() => _CompleteChallengeState();
}

class _CompleteChallengeState extends State<CompleteChallenge> {
  // Challenge _challenge;
  Future<Challenge> _challenge;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = false;

    _challenge = submitAndMarkChallenge();
  }

  bool checkUserChallengeCompletion() {
    bool complete = true;

    widget.challenge.questions.forEach((question) =>
        widget.challenge.userIsChallenger
            ? question.challengerAttempt != null
                ? complete = true
                : complete = false
            : question.opponentAttempt != null
                ? complete = true
                : complete = false);

    return complete;
  }

  bool userWon(Challenge challenge) {
    if (challenge == null) return false;
    return challenge.userIsChallenger
        ? challenge.scores.challenger > challenge.scores.opponent
        : challenge.scores.challenger < challenge.scores.opponent;
  }

  // If user completed challenge, check if opponent score has also been gotten and if challenge has been marked complete from BE, if not submit and get Score.
  // TODO: this shit ain't orthogonal at all!
  Future<Challenge> submitAndMarkChallenge() async {
    Challenge challenge;
    if (!widget.challenge.scores.complete) {
      setState(() {
        _loading = true;
      });
      challenge = await widget.challenge.submit();
    }

    setState(() {
      _loading = false;
    });
    return challenge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageHolder(
        onPressReturn: () {
          Navigator.popUntil(context, (route) {
            return route.settings.name == 'home' || route.isFirst;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: _loading || _challenge == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : FutureBuilder(
                  future: _challenge,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        break;

                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          Challenge challenge = snapshot.data;
                          return RefreshIndicator(
                            color: Theme.of(context).primaryColor,
                            onRefresh: () async {
                              try {
                                await submitAndMarkChallenge();
                              } finally {}
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Avatars.avatarFromId(
                                            challenge.challenger.avatarId,
                                            username:
                                                challenge.challenger.username),
                                        Text(
                                          challenge.challenger.username,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                    Text(
                                      challenge.scores.challenger.toString(),
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "VS",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      challenge.scores.opponent.toString(),
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Avatars.avatarFromId(
                                            challenge.opponent.avatarId,
                                            username:
                                                challenge.opponent.username),
                                        Text(
                                          challenge.opponent.username,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    Text(
                                      challenge.scores.complete ? challenge.scores.challenger == challenge.scores.opponent ? "Draw! "
                                          : userWon(challenge)
                                              ? "You win! "
                                              : (challenge.userIsChallenger
                                                      ? challenge
                                                          .opponent.username
                                                      : challenge.challenger
                                                          .username) +
                                                  " Wins! "
                                          : "Winner Gets ",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      (challenge.scores.complete && challenge.scores.challenger == challenge.scores.opponent) ? "" :
                                      (challenge.scores.complete &&
                                                  !userWon(challenge)
                                              ? "-"
                                              : "+") +
                                          (challenge.scores.complete &&
                                                  !userWon(challenge)
                                              ? (challenge.scores.stakePoints /
                                                      2)
                                                  .round()
                                                  .toString()
                                              : challenge.scores.stakePoints
                                                  .toString()) +
                                          " Points",
                                      style: TextStyle(
                                          color: challenge.scores.complete &&
                                                  !userWon(challenge)
                                              ? Colors.red
                                              : Theme.of(context).primaryColor,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: BlockButton(
                                        child: !checkUserChallengeCompletion()
                                            ? Text("Start Challenge")
                                            : challenge.scores.complete
                                                ? Text("View Details")
                                                : Text(
                                                    "Waiting for Opponent",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                        color: Theme.of(context).primaryColor,
                                        onPressed:
                                            checkUserChallengeCompletion() &&
                                                    !challenge.scores.complete
                                                ? null
                                                : () {
                                                    Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (context) {
                                                        return ChallengeWidget(
                                                            challenge:
                                                                challenge,
                                                            completeCallback:
                                                                () async {
                                                              await submitAndMarkChallenge();
                                                            });
                                                      }),
                                                    );
                                                  },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                            color: Theme.of(context).primaryColor,
                            onRefresh: () async {
                              try {
                                await submitAndMarkChallenge();
                              } finally {}
                            },
                            child: Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            ));

                      default:
                        return Center();
                    }
                  },
                ),
        ),
      ),
    );
  }
}

class Question {
  int id;
  int topicId;
  String body;
  List<Option> options;
  String difficulty;
  String explanation;

  Question(
      {this.id,
      this.topicId,
      this.body,
      this.options,
      this.difficulty,
      this.explanation,});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topic_id'];
    body = json['body'];
    if (json['options'] != null) {
      options = new List<Option>();
      json['options'].forEach((v) {
        options.add(new Option.fromJson(v));
      });
    }
    difficulty = json['difficulty'];
    explanation = json['explanation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic_id'] = this.topicId;
    data['body'] = this.body;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['difficulty'] = this.difficulty;
    data['explanation'] = this.explanation;
    return data;
  }
}

class Option {
  String key;
  String body;
  bool isAnswer;

  Option({this.key, this.body, this.isAnswer});

  Option.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    body = json['body'];
    isAnswer = json['is_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['body'] = this.body;
    data['is_answer'] = this.isAnswer;
    return data;
  }
}

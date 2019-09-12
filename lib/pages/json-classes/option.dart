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

import 'dart:convert';

import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/util/database.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class Challenge {
  int id;
  int challengerId;
  int opponentId;
  int courseId;
  Challenger challenger;
  Opponent opponent;
  List<ChallengeQuestion> questions;
  Scores scores;
  bool userIsChallenger;

  Challenge(
      {this.id,
      this.challengerId,
      this.opponentId,
      this.courseId,
      this.challenger,
      this.opponent,
      this.questions,
      this.userIsChallenger,
      this.scores});

  Challenge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    challengerId = json['challenger_id'];
    opponentId = json['opponent_id'];
    courseId = json['course_id'];
    challenger = json['challenger'] != null
        ? new Challenger.fromJson(json['challenger'] is String
            ? jsonDecode(json['challenger'])
            : json['challenger'])
        : null;
    opponent = json['opponent'] != null
        ? new Opponent.fromJson(json['opponent'] is String
            ? jsonDecode(json['opponent'])
            : json['opponent'])
        : null;
    if (json['questions'] != null) {
      questions = new List<ChallengeQuestion>();
      if (json['questions'] is String) {
        json['questions'] = jsonDecode(json['questions']);
      }
      json['questions'].forEach((v) {
        questions.add(new ChallengeQuestion.fromJson(v));
      });
    }
    userIsChallenger = json['userIsChallenger'] == 0 ? false : true;
    scores = json['scores'] != null
        ? new Scores.fromJson(json['scores'] is String
            ? jsonDecode(json['scores'])
            : json['scores'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['challenger_id'] = this.challengerId;
    data['opponent_id'] = this.opponentId;
    data['course_id'] = this.courseId;
    data['userIsChallenger'] = this.userIsChallenger ? 1 : 0;
    if (this.challenger != null) {
      data['challenger'] = jsonEncode(this.challenger.toJson());
    }
    if (this.opponent != null) {
      data['opponent'] = jsonEncode(this.opponent.toJson());
    }
    if (this.questions != null) {
      data['questions'] =
          jsonEncode(this.questions.map((v) => v.toJson()).toList());
    }
    if (this.scores != null) {
      data['scores'] = jsonEncode(this.scores.toJson());
    }
    return data;
  }

  Future<Challenge> submit() async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    List attempts = new List<Map<String, dynamic>>();

    this.questions.forEach((question) {
      Map<String, dynamic> attempt = new Map<String, dynamic>();
      attempt['question_id'] = question.questionId;
      attempt['attempt'] = this.userIsChallenger
          ? question.challengerAttempt
          : question.opponentAttempt;

      attempts.add(attempt);
    });

    data['attempts'] = jsonEncode(attempts);

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(
        ApiRequest.BASE_URL + '/challenges/${this.id}/submit',
        headers: headers,
        body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);
        Challenge c = Challenge.fromJson(data['data']);
        c.insertToDb();

        CourseProfile profile = await CourseProfile.whereCourseId(c.courseId);
        // did user win?
        // bool userWon = c.userIsChallenger
        //     ? c.scores.challenger > c.scores.opponent
        //     : c.scores.challenger < c.scores.opponent;
        print(data);
        profile.points = data['points'];
        profile.insertToDb();
        return c;
      case 422:
        Map<String, dynamic> data = json.decode(response.body);

        return null;

      default:
        return null;
    }
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'challenges',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class Challenger {
  String username;
  int avatarId;
  int id;

  Challenger({this.username, this.avatarId, this.id});

  Challenger.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatarId = json['avatar_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['avatar_id'] = this.avatarId;
    data['id'] = this.id;
    return data;
  }
}

class Opponent {
  String username;
  int avatarId;
  int id;

  Opponent({this.username, this.avatarId, this.id});

  Opponent.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatarId = json['avatar_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['avatar_id'] = this.avatarId;
    data['id'] = this.id;
    return data;
  }
}

class ChallengeQuestion {
  int challengeId;
  Question question;
  String challengerAttempt;
  String opponentAttempt;
  int questionId;
  ChallengeQuestion(
      {this.challengerAttempt, this.opponentAttempt, this.question});

  ChallengeQuestion.fromJson(Map<String, dynamic> json) {
    // if options is set, then definitely, we got the question here
    if (json['options'] != null) {
      question = Question.fromJson(json);
    }
    if (json['pivot'] != null) {
      challengeId = json['pivot']['challenge_id'];
      questionId = json['pivot']['question_id'];
      challengerAttempt = json['pivot']['challenger_attempt'];
      opponentAttempt = json['pivot']['opponent_attempt'];
    } else {
      challengeId = json['challenge_id'];
      questionId = json['question_id'];
      challengerAttempt = json['challenger_attempt'];
      opponentAttempt = json['opponent_attempt'];
    }
  }

  // We only convert to json to store or send to api. So no point storing some things, like the question
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['question_id'] = this.questionId;
    data['challenger_attempt'] = this.challengerAttempt;
    data['opponent_attempt'] = this.opponentAttempt;
    return data;
  }
}

class Scores {
  int challenger;
  int opponent;
  bool complete;
  int stakePoints;

  Scores({this.challenger, this.opponent, this.complete, this.stakePoints});

  Scores.fromJson(Map<String, dynamic> json) {
    challenger = json['challenger'];
    opponent = json['opponent'];
    stakePoints = json['stake_points'];
    complete = json['complete'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenger'] = this.challenger;
    data['opponent'] = this.opponent;
    data['complete'] = this.complete ? 1 : 0;
    data['stake_points'] = this.stakePoints;
    return data;
  }
}

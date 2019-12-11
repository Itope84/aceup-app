class OpponentProfile {
  int id;
  int userId;
  int points;
  int courseId;
  int avatarId;
  String username;

  OpponentProfile(
      {this.id, this.userId, this.points, this.courseId, this.username});

  OpponentProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    points = json['points'];
    courseId = json['course_id'];
    username = json['username'];
    avatarId = json['avatar_id'];
  }
}
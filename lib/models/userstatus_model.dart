class UserStatus {
  int? id;
  int? quiz;
  String? userId;
  String? username;
  String? quizTime;

  UserStatus({
    this.id,
    this.quiz,
    this.userId,
    this.username,
    this.quizTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'quiz': quiz, // Convert bool to 1 or 0
      'userId': userId,
      'username': username,
      'quizTime': quizTime
    };
  }

  factory UserStatus.fromMap(Map<String, dynamic> map) {
    return UserStatus(
        id: map['id'] ?? 1,
        quiz: map['quiz'], // Convert 1 to true, 0 to false
        userId: map['userId'],
        username: map['username'],
        quizTime: map['quizTime']);
  }
}

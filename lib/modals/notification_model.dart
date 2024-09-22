class NotificationModel {
  String userImage;
  String postImage;
  String email;
  String username;
  DateTime likedTime = DateTime.now();

  NotificationModel(
    this.username,
    this.userImage,
    this.postImage,
    this.email,
    this.likedTime,
  );

  factory NotificationModel.fromMap({required Map data}) {
    return NotificationModel(
      data['username'],
      data['userImage'],
      data['postImage'],
      data['email'],
      DateTime.fromMillisecondsSinceEpoch(data['likedTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'userImage': userImage,
      'postImage': postImage,
      'email': email,
      'username': username,
      'likedTime': likedTime.millisecondsSinceEpoch,
    };
  }
}

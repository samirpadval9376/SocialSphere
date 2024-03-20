class FollowModal {
  String username;
  String email;
  String image;
  DateTime createdTime = DateTime.now();

  FollowModal({
    required this.username,
    required this.email,
    required this.image,
    required this.createdTime,
  });

  factory FollowModal.fromMap({required Map data}) {
    return FollowModal(
      username: data['username'],
      email: data['email'],
      image: data['image'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(data['createdTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'username': username,
      'email': email,
      'image': image,
      'createdTime': createdTime.millisecondsSinceEpoch,
    };
  }
}

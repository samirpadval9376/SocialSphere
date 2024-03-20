class PostModal {
  String email;
  String description;
  String imageUrl;
  String userImage;
  String username;
  List likes;
  DateTime time = DateTime.now();

  PostModal({
    required this.email,
    required this.description,
    required this.imageUrl,
    required this.userImage,
    required this.username,
    required this.time,
    required this.likes,
  });

  factory PostModal.fromMap({required Map data}) {
    return PostModal(
      email: data['email'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      userImage: data['userImage'],
      username: data['username'],
      likes: data['likes'],
      time: DateTime.fromMillisecondsSinceEpoch(data['time']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'email': email,
      'description': description,
      'imageUrl': imageUrl,
      'userImage': userImage,
      'username': username,
      'likes': likes,
      'time': time.millisecondsSinceEpoch,
    };
  }
}

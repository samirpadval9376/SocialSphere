class UserModal {
  String username;
  String fullName;
  String password;
  String email;
  String dob;
  String image;
  DateTime createdTime = DateTime.now();
  List followingUsers;
  List followerUsers;
  List posts;
  List saved;

  UserModal({
    required this.username,
    required this.fullName,
    required this.dob,
    required this.image,
    required this.password,
    required this.email,
    required this.createdTime,
    required this.followingUsers,
    required this.followerUsers,
    required this.posts,
    required this.saved,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      username: data['username'],
      fullName: data['fullName'],
      password: data['password'],
      email: data['email'],
      dob: data['dob'],
      saved: data['saved'],
      image: data['image'],
      followingUsers: data['followingUsers'],
      followerUsers: data['followerUsers'],
      posts: data['posts'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(data['createdTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'email': email,
      'dob': dob,
      'image': image,
      'posts': posts,
      'saved': saved,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'followingUsers': followingUsers,
      'followerUsers': followerUsers,
    };
  }
}

class UserModal {
  String id;
  String password;
  String email;
  DateTime createdTime = DateTime.now();

  UserModal({
    required this.id,
    required this.password,
    required this.email,
    required this.createdTime,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      id: data['id'],
      password: data['password'],
      email: data['email'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(data['createdTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'password': password,
      'email': email,
      'createdTime': createdTime.millisecondsSinceEpoch,
    };
  }
}

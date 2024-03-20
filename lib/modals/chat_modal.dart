class ChatModal {
  String username;
  String email;
  String fullName;
  String image;
  String lastMessage;

  ChatModal(
    this.username,
    this.email,
    this.fullName,
    this.image,
    this.lastMessage,
  );

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      data['username'],
      data['email'],
      data['fullName'],
      data['image'],
      data['lastMessage'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'image': image,
      'lastMessage': lastMessage,
    };
  }
}

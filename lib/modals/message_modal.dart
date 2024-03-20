class MessageModal {
  String msg, type, email;
  DateTime dateTime = DateTime.now();

  MessageModal({
    required this.msg,
    required this.email,
    required this.type,
    required this.dateTime,
  });

  factory MessageModal.fromMap({required Map data}) {
    return MessageModal(
      msg: data['msg'],
      email: data['email'],
      type: data['type'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'msg': msg,
      'email': email,
      'type': type,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}

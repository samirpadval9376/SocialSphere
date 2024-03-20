import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineModal {
  String post;
  Timestamp date = Timestamp.now();

  TimelineModal(
    this.post,
    this.date,
  );

  factory TimelineModal.fromMap({required Map data}) {
    return TimelineModal(
      data['post'],
      data['date'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'post': post,
      'date': date,
    };
  }
}

import 'package:social_media_app/modals/post_modal.dart';

class LikesModal {
  String email;
  String username;
  String image;
  DateTime time = DateTime.now();

  LikesModal({
    required this.email,
    required this.username,
    required this.image,
    required this.time,
  });

  factory LikesModal.fromMap({required Map data}) {
    return LikesModal(
      email: data['email'],
      username: data['username'],
      image: data['image'],
      time: DateTime.fromMillisecondsSinceEpoch(data['time']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'email': email,
      'username': username,
      'image': image,
      'time': time.millisecondsSinceEpoch,
    };
  }
}

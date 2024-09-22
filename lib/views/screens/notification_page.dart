import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.showNotification(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                data?.docs ?? [];
            List<NotificationModel> allData = docs
                .map((e) => NotificationModel.fromMap(data: e.data()))
                .toList();

            if (allData.isEmpty) {
              return const Center(
                child: Text("No Data Found !!"),
              );
            } else {
              return ListView.builder(
                itemCount: allData.length,
                itemBuilder: (context, index) {
                  NotificationModel notificationModel = allData[index];
                  return Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(
                          notificationModel.userImage,
                        ),
                      ),
                      Expanded(
                        child: Text(notificationModel.username),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(notificationModel.postImage),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

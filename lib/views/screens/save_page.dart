import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/user_modal.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Saved"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder(
              stream: FireStoreHelper.fireStoreHelper.userData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
                  Map<String, dynamic> allData = data?.data() ?? {};

                  UserModal userModal = UserModal.fromMap(data: allData);

                  return Expanded(
                    child: ListView.builder(
                      itemCount: userModal.saved.length,
                      itemBuilder: (context, index) {
                        return Image.network(userModal.saved[index]['image']);
                      },
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

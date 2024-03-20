import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/chat_modal.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../controllers/theme_controller.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        title: const Text(
          "Your Chats",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.chatList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                data?.docs ?? [];

            List<ChatModal> chats =
                docs.map((e) => ChatModal.fromMap(data: e.data())).toList();

            if (chats.isEmpty) {
              return const Text(
                "No Chats Found !!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              );
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                log(chats.length.toString());

                return chats[index].email !=
                        Auth.auth.firebaseAuth.currentUser!.email
                    ? ListTile(
                        onTap: () {
                          log(chats[index].email);
                          Navigator.of(context)
                              .pushNamed('chat_page', arguments: chats[index]);
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          foregroundImage: NetworkImage(chats[index].image),
                        ),
                        title: Text(
                          chats[index].username,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          chats[index].lastMessage,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )
                    : Container();
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

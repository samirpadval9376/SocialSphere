import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/chat_modal.dart';
import 'package:social_media_app/modals/message_modal.dart';
import 'package:social_media_app/views/screens/call_page.dart';

import '../../controllers/theme_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ChatModal chats = ModalRoute.of(context)!.settings.arguments as ChatModal;
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(chats.image),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: s.width * 0.33,
              child: Text(
                chats.fullName.replaceFirst(
                    chats.fullName[0], chats.fullName[0].toUpperCase()),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CallPage(
                      callId: chats.email,
                      userId: chats.email,
                      userName: chats.username),
                ),
              );
            },
            icon: const Icon(Icons.video_call_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getChats(
                  senderId: Auth.auth.firebaseAuth.currentUser?.email ?? "",
                  receiverId: chats.email,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                        data?.docs ?? [];

                    List<MessageModal> allDocs = docs
                        .map((e) => MessageModal.fromMap(data: e.data()))
                        .toList();

                    if (docs.isEmpty) {
                      return const Text("No Messages Yet !!");
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: allDocs.length,
                      itemBuilder: (context, index) {
                        MessageModal messageModal = allDocs[index];

                        log("${chats.email}.......................");

                        if (messageModal.type == 'sent') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Provider.of<ThemeController>(context)
                                          .isDark
                                      ? Colors.indigo.shade300
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  messageModal.msg,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  messageModal.msg,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: chatController,
                    decoration: InputDecoration(
                      labelText: "Your Message",
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    MessageModal messageModal = MessageModal(
                      msg: chatController.text,
                      email: Auth.auth.firebaseAuth.currentUser?.email ?? "",
                      type: 'sent',
                      dateTime: DateTime.now(),
                    );

                    await FireStoreHelper.fireStoreHelper
                        .sentMessage(
                      messageModal: messageModal,
                      senderId: Auth.auth.firebaseAuth.currentUser?.email ?? "",
                      receiverId: chats.email,
                    )
                        .then((value) async {
                      await FireStoreHelper.fireStoreHelper
                          .lastMessage(
                        id: Auth.auth.firebaseAuth.currentUser?.email ?? "",
                        email: chats.email,
                        msg: chatController.text,
                        chatModal: chats,
                      )
                          .then((value) async {
                        chatController.clear();
                      });
                    });

                    log(chats.email);

                    log(chats.lastMessage);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

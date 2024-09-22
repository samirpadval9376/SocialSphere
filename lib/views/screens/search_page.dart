import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/chat_modal.dart';
import 'package:social_media_app/modals/follower_modal.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../controllers/theme_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? username;

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Search  for  a  user",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                labelText: "Enter username",
              ),
              cursorColor: Colors.white,
              onChanged: (val) {
                setState(() {
                  username = val;
                });
              },
            ),
            StreamBuilder(
              stream: FireStoreHelper.fireStoreHelper
                  .getUserData(username: username ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                      data?.docs ?? [];

                  List<UserModal> allUsers = allDocs
                      .map((e) => UserModal.fromMap(data: e.data()))
                      .toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        UserModal users = allUsers[index];

                        log("============================");
                        log(users.email);
                        log("============================");

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                foregroundImage: NetworkImage(users.image),
                              ),
                              SizedBox(
                                width: s.width * 0.04,
                              ),
                              GestureDetector(
                                onTap: () {
                                  log(users.username);
                                  Navigator.of(context).pushNamed(
                                      'profile_page',
                                      arguments: users);
                                },
                                child: Text(users.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ),
                              const Spacer(),
                              StreamBuilder(
                                stream:
                                    FireStoreHelper.fireStoreHelper.userData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    DocumentSnapshot<Map<String, dynamic>>?
                                        data = snapshot.data;

                                    Map<String, dynamic>? allData =
                                        data?.data();

                                    log(allData?['email']);
                                    log("=================================");

                                    return IconButton(
                                      onPressed: () async {
                                        ChatModal chatModal = ChatModal(
                                          users.username,
                                          users.email,
                                          users.fullName,
                                          users.image,
                                          "",
                                        );

                                        await FireStoreHelper.fireStoreHelper
                                            .addChat(
                                                chatModal: chatModal,
                                                user: allData ?? {})
                                            .then(
                                          (value) {
                                            log("email : ${users.email}");
                                            return Navigator.of(context)
                                                .pushNamed('chat_list');
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.chat,
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                  return const Center();
                                },
                              ),
                              SizedBox(
                                width: s.width * 0.04,
                              ),
                              SizedBox(
                                height: 45,
                                child: StreamBuilder(
                                  stream: FireStoreHelper.fireStoreHelper
                                      .followingData(),
                                  builder: (context, snaps) {
                                    if (snaps.hasData) {
                                      QuerySnapshot<Map<String, dynamic>>?
                                          data = snaps.data;

                                      List<
                                              QueryDocumentSnapshot<
                                                  Map<String, dynamic>>>
                                          allDocs = data?.docs ?? [];

                                      List<FollowModal?> allFollowers = allDocs
                                          .map((e) => FollowModal.fromMap(
                                              data: e.data()))
                                          .toList();

                                      return StreamBuilder(
                                        stream: FireStoreHelper.fireStoreHelper
                                            .userData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            DocumentSnapshot<
                                                    Map<String, dynamic>>?
                                                data = snapshot.data;

                                            Map<String, dynamic>? allData =
                                                data?.data();

                                            UserModal userModal =
                                                UserModal.fromMap(
                                                    data: allData!);
                                            if (userModal.followingUsers.any(
                                                (element) =>
                                                    element['email'] ==
                                                    users.email)) {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.deepPurple,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  log(users.email);
                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .unfollow(
                                                          followEmail:
                                                              users.email)
                                                      .then(
                                                        (value) async =>
                                                            await FireStoreHelper
                                                                .fireStoreHelper
                                                                .removeFollowing(
                                                                    id: users
                                                                        .email),
                                                      );

                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .removeFollower(
                                                          id: users.email);
                                                },
                                                child: const Text(
                                                  "Unfollow",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.deepPurple,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  UserModal userModal2 =
                                                      UserModal(
                                                    username: users.username,
                                                    fullName: users.fullName,
                                                    dob: users.dob,
                                                    image: users.image,
                                                    password: users.password,
                                                    email: users.email,
                                                    createdTime:
                                                        users.createdTime,
                                                    followingUsers: [],
                                                    followerUsers: [],
                                                    posts: [],
                                                    saved: [],
                                                    notifications: [],
                                                  );
                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .addFollowing(
                                                        userModal: userModal2,
                                                      )
                                                      .then(
                                                        (value) async =>
                                                            await FireStoreHelper
                                                                .fireStoreHelper
                                                                .updateFollowing(
                                                          username:
                                                              users.username,
                                                          image: users.image,
                                                          id: users.email,
                                                        ),
                                                      );

                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .addFollower(
                                                        userModal: userModal,
                                                        id: users.email,
                                                      )
                                                      .then(
                                                        (value) async => await FireStoreHelper
                                                            .fireStoreHelper
                                                            .updateFollowers(
                                                                username:
                                                                    userModal
                                                                        .username,
                                                                image: userModal
                                                                    .image,
                                                                docEmail:
                                                                    users.email,
                                                                email: userModal
                                                                    .email),
                                                      );

                                                  log("==========================");
                                                  log(users
                                                      .followingUsers.length
                                                      .toString());
                                                  log("==========================");
                                                },
                                                child: const Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
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
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/post_modal.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../controllers/theme_controller.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    PostModal postModal =
        ModalRoute.of(context)!.settings.arguments as PostModal;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "About this account",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper.getUserData(
              username: postModal.username,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    data?.docs ?? [];

                List<UserModal> user =
                    docs.map((e) => UserModal.fromMap(data: e.data())).toList();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      foregroundImage: NetworkImage(postModal.userImage),
                    ),
                    Text(
                      postModal.username,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: s.height * 0.035,
                    ),
                    StreamBuilder(
                        stream: FireStoreHelper.fireStoreHelper.userData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot<Map<String, dynamic>>? data =
                                snapshot.data;

                            Map<String, dynamic>? allData = data?.data();

                            UserModal userModal =
                                UserModal.fromMap(data: allData!);

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: s.width * 0.03,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date joined",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat.MMMM().format(user[0].createdTime)} ${user[0].createdTime.year}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: s.height * 0.025,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: s.width * 0.03,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Full Name",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          user[0].fullName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: s.height * 0.025,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: s.width * 0.03,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date of birth",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          user[0].dob,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

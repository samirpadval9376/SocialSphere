import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/post_modal.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../controllers/theme_controller.dart';
import '../../modals/follower_modal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: Text(Auth.auth.firebaseAuth.currentUser?. ?? ""),
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

                  Map<String, dynamic>? allData = data?.data();

                  UserModal userModal = UserModal.fromMap(data: allData!);

                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    foregroundImage:
                                        NetworkImage(userModal.image),
                                  ),
                                  SizedBox(
                                    height: s.height * 0.01,
                                  ),
                                  SizedBox(
                                    width: s.width * 0.22,
                                    child: Text(
                                      userModal.fullName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: s.width * 0.08,
                              ),
                              SizedBox(
                                height: 60,
                                child: Column(
                                  children: [
                                    Text(
                                      userModal.posts.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      "posts",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    'follower_detail_page',
                                    arguments: userModal,
                                  );
                                },
                                child: SizedBox(
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Text(
                                        userModal.followerUsers.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "followers",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    'following_detail_page',
                                    arguments: userModal,
                                  );
                                },
                                child: SizedBox(
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Text(
                                        userModal.followingUsers.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "following",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: s.height * 0.01,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              'edit_profile_page',
                              arguments: userModal,
                            );
                          },
                          child: Text(
                            "Edit profile",
                            style: TextStyle(
                                color:
                                    Provider.of<ThemeController>(context).isDark
                                        ? Colors.black
                                        : Colors.deepPurple),
                          ),
                        ),
                        SizedBox(
                          height: s.height * 0.02,
                        ),
                        userModal.posts.isNotEmpty
                            ? SizedBox(
                                height: s.height * 0.5,
                                child: GridView.builder(
                                  itemCount: userModal.posts.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio:
                                        s.width / (s.height / 1.8),
                                  ),
                                  itemBuilder: (context, index) {
                                    return userModal.posts[index]['email'] ==
                                            userModal.email
                                        ? Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                                image: NetworkImage(
                                                  userModal.posts[index]
                                                      ['image'],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  },
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: s.height * 0.2,
                                  ),
                                  const Center(
                                    child: Text(
                                      "No posts yet !!",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
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

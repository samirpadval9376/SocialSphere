import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/api_controltter.dart';
import '../../controllers/theme_controller.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/post_modal.dart';
import '../../modals/user_modal.dart';
import '../../utils/color_util.dart';
import 'login_screen.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Add  post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<PostController>(builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: () async {
                  await provider.changeImage();
                },
                child: Text(
                  "Add Image",
                  style: TextStyle(
                    color: Provider.of<ThemeController>(context).isDark
                        ? Colors.black
                        : Colors.deepPurple,
                  ),
                ),
              ),
            ),
            provider.imageUrl.isNotEmpty
                ? SizedBox(
                    height: s.height * 0.5,
                    width: s.width,
                    child: Image.network(
                      provider.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Center(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: postController,
                    decoration: const InputDecoration(
                      labelText: "Post Something",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder(
                      stream: FireStoreHelper.fireStoreHelper.userData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          DocumentSnapshot<Map<String, dynamic>>? data =
                              snapshot.data;

                          Map<String, dynamic>? allData = data?.data();

                          UserModal userModal =
                              UserModal.fromMap(data: allData!);

                          return SizedBox(
                            height: s.height * 0.06,
                            width: s.width * 0.3,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                PostModal postModal = PostModal(
                                  email: Auth.auth.firebaseAuth.currentUser
                                          ?.email ??
                                      "",
                                  description: postController.text,
                                  time: DateTime.now(),
                                  imageUrl: provider.imageUrl,
                                  userImage: userModal.image,
                                  username: userModal.username,
                                  likes: [],
                                );

                                log("Image url :- ${provider.imageUrl}");

                                await FireStoreHelper.fireStoreHelper
                                    .getPosts(postModal: postModal)
                                    .then((value) async {
                                  await FireStoreHelper.fireStoreHelper
                                      .addPost(postModal: postModal)
                                      .then((value) => provider.imageUrl = "");
                                  postController.clear();
                                });
                              },
                              child: Text(
                                "Post",
                                style: TextStyle(
                                  color: Provider.of<ThemeController>(context)
                                          .isDark
                                      ? Colors.black
                                      : Colors.deepPurple,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

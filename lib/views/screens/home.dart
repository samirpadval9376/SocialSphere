import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/controllers/api_controltter.dart';
import 'package:social_media_app/controllers/theme_controller.dart';
import 'package:social_media_app/modals/notification_model.dart';
import 'package:story_maker/story_maker.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/post_modal.dart';
import '../../modals/user_modal.dart';
import 'login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  File? image;

  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Consumer<ThemeController>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: provider.isDark ? Colors.black87 : Colors.deepPurple,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Feeds",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('notification_page');
              },
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('chat_list');
              },
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  Auth.auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false);
                },
                title: const Text(
                  "Sign out",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
              ),
              SwitchListTile(
                value: provider.isDark,
                title: const Text(
                  "Dark Theme",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onChanged: (val) {
                  provider.changeTheme();
                },
              ),
            ],
          ),
        ),
        body: Consumer<PostController>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.userData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DocumentSnapshot<Map<String, dynamic>>? data =
                            snapshot.data;
                        Map<String, dynamic>? allData = data?.data();
                        UserModal userModal = UserModal.fromMap(data: allData!);

                        return Row(
                          children: [
                            Stack(
                              alignment: const Alignment(1.5, 1.2),
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 45,
                                  child: CircleAvatar(
                                    radius: 40,
                                    foregroundImage:
                                        NetworkImage(userModal.image),
                                  ),
                                ),
                                FloatingActionButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  onPressed: () async {
                                    await [
                                      Permission.photos,
                                      Permission.storage
                                    ].request();
                                    ImagePicker picker = ImagePicker();
                                    await picker
                                        .pickImage(source: ImageSource.gallery)
                                        .then((file) async {
                                      File editedFile =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StoryMaker(filePath: file!.path),
                                        ),
                                      );
                                      if (image?.path != null) {
                                        setState(() {
                                          image = editedFile;
                                        });
                                      }
                                    });
                                  },
                                  mini: true,
                                  elevation: 0,
                                  child: const Icon(Icons.add),
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
                Expanded(
                  child: StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper.showPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot<Map<String, dynamic>>? data =
                            snapshot.data;
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            allDocs = data?.docs ?? [];

                        List<PostModal> allPosts = allDocs
                            .map((e) => PostModal.fromMap(data: e.data()))
                            .toList();

                        if (allPosts.isEmpty) {
                          return const Center(
                            child: Text(
                              "No Posts Found !!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: allPosts.length,
                            itemBuilder: (context, index) {
                              PostModal posts = allPosts[index];

                              log(allPosts[index].imageUrl);

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 5),
                                          child: CircleAvatar(
                                            foregroundImage:
                                                NetworkImage(posts.userImage),
                                            radius: 22,
                                          ),
                                        ),
                                        SizedBox(
                                          width: s.width * 0.03,
                                        ),
                                        Text(
                                          posts.username,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              showDragHandle: true,
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  height: s.height * 0.4,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: s.height * 0.03,
                                                      ),
                                                      Container(
                                                        height: s.height * 0.09,
                                                        width: s.width * 0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    'save_page');
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .bookmark_border_rounded,
                                                            size: 35,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: s.height * 0.03,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                s.width * 0.03,
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .star_border_outlined,
                                                            size: 30,
                                                            color: Colors.black,
                                                          ),
                                                          const Spacer(),
                                                          const Text(
                                                            "Add to favourites",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          const Spacer(
                                                            flex: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: s.height * 0.03,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                s.width * 0.03,
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .person_remove_outlined,
                                                            size: 30,
                                                            color: Colors.black,
                                                          ),
                                                          const Spacer(),
                                                          const Text(
                                                            "unfollow",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          const Spacer(
                                                            flex: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: s.height * 0.03,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  'about_page',
                                                                  arguments:
                                                                      posts);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: s.width *
                                                                  0.03,
                                                            ),
                                                            const Icon(
                                                              CupertinoIcons
                                                                  .profile_circled,
                                                              size: 30,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            const Spacer(),
                                                            const Text(
                                                              "About this account",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const Spacer(
                                                              flex: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.menu,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    isLoading
                                        ? SizedBox(
                                            height: s.height * 0.4,
                                            width: s.width,
                                            child: Image.network(
                                              posts.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          ),
                                    StreamBuilder(
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
                                              data: allData!,
                                            );

                                            log("${posts.likes}");

                                            bool isLiked = posts.likes.any(
                                                (element) =>
                                                    element['email'] ==
                                                    userModal.email);

                                            bool isSaved = userModal.saved.any(
                                                (element) =>
                                                    element['image'] ==
                                                    posts.imageUrl);

                                            return Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    if (isLiked) {
                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .updateDislikes(
                                                        userModal: userModal,
                                                        time: posts.time
                                                            .millisecondsSinceEpoch
                                                            .toString(),
                                                      );
                                                    } else {
                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .updateLikes(
                                                        userModal: userModal,
                                                        time: posts.time
                                                            .millisecondsSinceEpoch
                                                            .toString(),
                                                      );

                                                      NotificationModel
                                                          notificationModel =
                                                          NotificationModel(
                                                        userModal.username,
                                                        userModal.image,
                                                        posts.imageUrl,
                                                        userModal.email,
                                                        DateTime.now(),
                                                      );

                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .setNotification(
                                                        notificationModel:
                                                            notificationModel,
                                                        id: posts.email,
                                                      );

                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .updateNotification(
                                                        postModal: posts,
                                                        userModal: userModal,
                                                      );

                                                      OneSignal.login(
                                                          userModal.email);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    color: isLiked
                                                        ? Colors.red
                                                        : Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.share_outlined,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                    onPressed: () async {
                                                      if (isSaved) {
                                                        // await FireStoreHelper
                                                        //     .fireStoreHelper
                                                        //     .unSaved();

                                                        await FireStoreHelper
                                                            .fireStoreHelper
                                                            .removeSaved(
                                                                id: posts
                                                                    .imageUrl);
                                                        log("${userModal.email}----------");
                                                      } else {
                                                        await FireStoreHelper
                                                            .fireStoreHelper
                                                            .mySaved(
                                                                postModal:
                                                                    posts);
                                                        await FireStoreHelper
                                                            .fireStoreHelper
                                                            .updateSaved(
                                                                postModal:
                                                                    posts);
                                                      }
                                                    },
                                                    icon: isSaved
                                                        ? const Icon(
                                                            Icons.bookmark,
                                                            size: 30,
                                                            color: Colors.black,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .bookmark_border,
                                                            size: 30,
                                                            color: Colors.black,
                                                          )),
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                        }),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return const Center(
                          child: LinearProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}

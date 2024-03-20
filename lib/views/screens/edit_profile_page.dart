import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/controllers/api_controltter.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../controllers/theme_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String username = "";
  String fullName = "";
  String oldPassword = "";
  String newPassword = "";
  String image = "";
  String dob = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserModal userModal =
        ModalRoute.of(context)!.settings.arguments as UserModal;

    Size s = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Provider.of<ThemeController>(context).isDark
          ? Colors.black87
          : Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Provider.of<PostController>(context, listen: false).image = "";
            log("${Provider.of<PostController>(context, listen: false).image}");
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 18, left: 12, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Consumer<PostController>(builder: (context, provider, _) {
          return Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  foregroundImage: provider.image == ""
                      ? NetworkImage(userModal.image)
                      : NetworkImage(provider.image),
                ),
                ElevatedButton(
                  onPressed: () async {
                    log(provider.image);
                    Future.delayed(const Duration(seconds: 3), () async {
                      await provider.updateUserImage();
                    });
                  },
                  child: Text(
                    "change",
                    style: TextStyle(
                      color: Provider.of<ThemeController>(context).isDark
                          ? Colors.black
                          : Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                TextFormField(
                  initialValue: userModal.username,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    provider.updateUsername(val: val!);
                  },
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: userModal.fullName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the Full Name";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          provider.updateFullName(val: val!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: userModal.dob,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: "DOB",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the DOB";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) {
                          provider.updateDob(val: val!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Old Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    provider.oldPassword(val: val!);
                  },
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    provider.updatePassword(val: val!);
                  },
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      log("Image : ${provider.img}");

                      if (userModal.password == provider.password) {
                        Auth.auth.updatePassword(
                          emails: userModal.email,
                          passwords: provider.img,
                          newPassword: provider.newPassword!,
                        );
                      }

                      await FireStoreHelper.fireStoreHelper
                          .updateProfile(
                        username: provider.username!,
                        password: provider.newPassword!,
                        fullName: provider.fullName!,
                        image: provider.image,
                        dob: provider.dob!,
                        userModal: userModal,
                      )
                          .then((value) {
                        log("Password Changed : ${provider.newPassword}");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully !!"),
                            duration: Duration(seconds: 3),
                            dismissDirection: DismissDirection.endToStart,
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/controllers/api_controltter.dart';
import 'package:social_media_app/helpers/firestore_helper.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../helpers/auth_helper.dart';
import '../../utils/color_util.dart';
import '../components/input_text_field.dart';
import '../components/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? image;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<PostController>(builder: (context, provider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to App",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  height: s.height * 0.02,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        foregroundImage: provider.imagePath != null
                            ? FileImage(provider.imagePath!)
                            : null,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Select Method"),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      ImagePicker picker = ImagePicker();

                                      XFile? img = await picker.pickImage(
                                        source: ImageSource.camera,
                                      );

                                      if (img != null) {
                                        provider.addImage(
                                          img: File(img.path),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                    ),
                                    label: const Text("Camera"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      ImagePicker picker = ImagePicker();

                                      XFile? img = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );

                                      if (img != null) {
                                        provider.addImage(
                                          img: File(img.path),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.image,
                                    ),
                                    label: const Text("Gallery"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                      SizedBox(
                        height: s.height * 0.02,
                      ),
                      TextFormField(
                        controller: usernameController,
                        focusNode: usernameFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the Username";
                          } else {
                            return null;
                          }
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
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the Full Name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                hintText: "DOB",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the DOB";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: s.height * 0.02,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: s.height * 0.02,
                      ),
                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: s.height * 0.02,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter the Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: s.height * 0.01,
                ),
                SizedBox(
                  height: s.height * 0.04,
                ),
                RoundButton(
                  title: "Signup",
                  textColor: AppColor.whiteColor,
                  onPress: () async {
                    String email = emailController.text;
                    String password = passwordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    String username = usernameController.text;
                    String dob = dateController.text;
                    String fullName = nameController.text;

                    Directory? dir = await getExternalStorageDirectory();

                    image = await Provider.of<PostController>(context,
                            listen: false)
                        .imagePath!
                        .copy("${dir!.path}/$username.jpg");

                    await provider.storeUserImage();

                    log(provider.img.toString());

                    if (formKey.currentState!.validate()) {
                      if (password == confirmPassword) {
                        User? user = await Auth.auth.createNewUser(
                          email: email,
                          password: password,
                        );
                        UserModal userModal = UserModal(
                          username: username,
                          fullName: fullName,
                          dob: dob,
                          image: provider.img,
                          password: password,
                          email: email,
                          createdTime: DateTime.now(),
                          followingUsers: [],
                          followerUsers: [],
                          posts: [],
                          saved: [],
                        );

                        log(email);

                        if (user != null) {
                          await FireStoreHelper.fireStoreHelper
                              .addUser(userModal: userModal)
                              .then((value) =>
                                  Navigator.of(context).pushReplacementNamed(
                                    'login_screen',
                                  ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password didn't Match"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account ?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('login_screen');
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

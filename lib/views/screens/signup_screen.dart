import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  FocusNode nameFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<PostController>(builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Welcome to App",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: InputTextField(
                              controller: usernameController,
                              focusNode: usernameFocusNode,
                              obscureText: false,
                              onValidator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the Username";
                                } else {
                                  return null;
                                }
                              },
                              keyBoardType: TextInputType.emailAddress,
                              hint: 'username',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InputTextField(
                                    controller: nameController,
                                    keyBoardType: TextInputType.name,
                                    onValidator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter the Full Name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    focusNode: nameFocusNode,
                                    obscureText: false,
                                    hint: 'Full Name',
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InputTextField(
                                    controller: dateController,
                                    keyBoardType: TextInputType.datetime,
                                    onValidator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter the DOB";
                                      } else {
                                        return null;
                                      }
                                    },
                                    focusNode: dateFocusNode,
                                    obscureText: false,
                                    hint: 'DOB',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: InputTextField(
                              controller: emailController,
                              keyBoardType: TextInputType.emailAddress,
                              onValidator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the Email";
                                } else {
                                  return null;
                                }
                              },
                              focusNode: emailFocusNode,
                              obscureText: false,
                              hint: 'Email',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InputTextField(
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              keyBoardType: TextInputType.emailAddress,
                              obscureText: true,
                              onValidator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the Password";
                                } else {
                                  return null;
                                }
                              },
                              hint: 'Password',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: InputTextField(
                              controller: confirmPasswordController,
                              keyBoardType: TextInputType.emailAddress,
                              obscureText: true,
                              onValidator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter the Password";
                                } else {
                                  return null;
                                }
                              },
                              focusNode: confirmPasswordFocusNode,
                              hint: 'Confirm Password',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: RoundButton(
                      title: "Signup",
                      textColor: AppColor.whiteColor,
                      color: passwordController.text.isNotEmpty
                          ? const Color(0xff3797EF)
                          : const Color(0xff3797EF).withOpacity(0.50),
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
                              notifications: [],
                            );

                            log(email);

                            if (user != null) {
                              await FireStoreHelper.fireStoreHelper
                                  .addUser(userModal: userModal)
                                  .then((value) => Navigator.of(context)
                                          .pushReplacementNamed(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account ?",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(.40),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('login_screen');
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff3797EF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

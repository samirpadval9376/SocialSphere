import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    usernameController.dispose();
    usernameFocusNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: s.height * 0.02,
              ),
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
                    InputTextField(
                      controller: usernameController,
                      focusNode: usernameFocusNode,
                      keyBoardType: TextInputType.emailAddress,
                      obscureText: false,
                      hint: "Username",
                      onValidator: (val) {
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
                    InputTextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyBoardType: TextInputType.emailAddress,
                      obscureText: false,
                      hint: "Email",
                      onValidator: (val) {
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
                    InputTextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      keyBoardType: TextInputType.emailAddress,
                      obscureText: true,
                      hint: "Password",
                      onValidator: (val) {
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
                    InputTextField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      keyBoardType: TextInputType.emailAddress,
                      obscureText: true,
                      hint: "Password",
                      onValidator: (val) {
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

                  if (formKey.currentState!.validate()) {
                    if (password == confirmPassword) {
                      User? user = await Auth.auth.createNewUser(
                        email: email,
                        password: password,
                      );
                      UserModal userModal = UserModal(
                        id: user?.uid ?? "",
                        password: password,
                        email: email,
                        createdTime: DateTime.now(),
                      );

                      log(email);

                      if (user != null && mounted) {
                        await FireStoreHelper.fireStoreHelper
                            .addUser(userModal: userModal);
                        Navigator.of(context).pushReplacementNamed(
                          'login_screen',
                        );
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
          ),
        ),
      ),
    );
  }
}

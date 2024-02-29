import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/views/components/input_text_field.dart';
import 'package:social_media_app/views/components/round_button.dart';

import '../../helpers/auth_helper.dart';
import '../../utils/color_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
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
                      obscureText: false,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: s.height * 0.04,
              ),
              RoundButton(
                title: "Login",
                textColor: AppColor.whiteColor,
                onPress: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  if (formKey.currentState!.validate()) {
                    User? user = await Auth.auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (user != null && mounted) {
                      Navigator.of(context).pushReplacementNamed('home_page');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid Email or Password !!"),
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
                    "Don't have an Account ?",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('signup_screen');
                    },
                    child: Text(
                      "Sign Up",
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

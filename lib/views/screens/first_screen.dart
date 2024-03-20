import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: s.height * 0.12,
              ),
              SizedBox(
                height: s.height * 0.15,
                child: Image.network(
                    'http://www.tonyjohn.com/images/blog/smm.png'),
              ),
              SizedBox(
                height: s.height * 0.09,
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: s.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('signup_screen');
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "create new account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: s.height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(
                    size: 30,
                  ),
                  SizedBox(
                    width: s.height * 0.01,
                  ),
                  const Text(
                    "Flutter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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

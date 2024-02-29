import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/utils/color_util.dart';
import 'package:social_media_app/utils/font_utils.dart';
import 'package:social_media_app/views/screens/home_page.dart';
import 'package:social_media_app/views/screens/login_screen.dart';
import 'package:social_media_app/views/screens/signup_screen.dart';
import 'package:social_media_app/views/screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColor.primaryMaterialColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: AppColor.whiteColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          displaySmall: TextStyle(
            fontSize: 28,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          titleLarge: TextStyle(
            fontSize: 17,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.sfProDisplayRegular,
            color: AppColor.primaryTextColor,
            height: 1.6,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            height: 2.26,
          ),
        ),
      ),
      initialRoute: Auth.auth.firebaseAuth.currentUser == null
          ? 'login_screen'
          : 'home_page',
      routes: {
        '/': (context) => const SplashScreen(),
        'login_screen': (context) => const LoginScreen(),
        'signup_screen': (context) => const SignupScreen(),
        'home_page': (context) => const HomePage(),
      },
    );
  }
}

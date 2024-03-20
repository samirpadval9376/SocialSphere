import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/controllers/api_controltter.dart';
import 'package:social_media_app/controllers/theme_controller.dart';
import 'package:social_media_app/helpers/auth_helper.dart';
import 'package:social_media_app/utils/color_util.dart';
import 'package:social_media_app/utils/font_utils.dart';
import 'package:social_media_app/views/screens/about_page.dart';
import 'package:social_media_app/views/screens/add_story_page.dart';
import 'package:social_media_app/views/screens/chat_list.dart';
import 'package:social_media_app/views/screens/chat_page.dart';
import 'package:social_media_app/views/screens/edit_profile_page.dart';
import 'package:social_media_app/views/screens/first_screen.dart';
import 'package:social_media_app/views/screens/follower_detail_page.dart';
import 'package:social_media_app/views/screens/following_detail_page.dart';
import 'package:social_media_app/views/screens/home_page.dart';
import 'package:social_media_app/views/screens/login_screen.dart';
import 'package:social_media_app/views/screens/profile_page.dart';
import 'package:social_media_app/views/screens/save_page.dart';
import 'package:social_media_app/views/screens/search_page.dart';
import 'package:social_media_app/views/screens/signup_screen.dart';
import 'package:social_media_app/views/screens/splash_screen.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ZegoExpressEngine.createEngineWithProfile(
    ZegoEngineProfile(
      547975195,
      ZegoScenario.Default,
      appSign: kIsWeb
          ? null
          : 'a85fd3fea7f8d0ad300698a236873a271518347eb057fad1492a6cbf92d3ee3e',
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostController()),
        ChangeNotifierProvider(
          create: (context) => ThemeController(prefs: prefs),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: AppColor.primaryMaterialColor,
        appBarTheme: const AppBarTheme(
          color: AppColor.whiteColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          displaySmall: TextStyle(
            fontSize: 28,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            // fontFamily: AppFonts.sfProDisplayMedium,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          titleLarge: TextStyle(
            fontSize: 17,
            // fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            // fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            // fontFamily: AppFonts.sfProDisplayRegular,
            color: AppColor.primaryTextColor,
            height: 1.6,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            // fontFamily: AppFonts.sfProDisplayBold,
            color: AppColor.primaryTextColor,
            height: 2.26,
          ),
        ),
      ),
      themeMode: Provider.of<ThemeController>(context).getTheme
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: Auth.auth.firebaseAuth.currentUser == null
          ? 'splash_screen'
          : 'home_page',
      routes: {
        '/': (context) => const SplashScreen(),
        'login_screen': (context) => const LoginScreen(),
        'signup_screen': (context) => const SignupScreen(),
        'home_page': (context) => const HomePage(),
        'search_page': (context) => const SearchPage(),
        'chat_page': (context) => const ChatPage(),
        'chat_list': (context) => const ChatList(),
        'first_screen': (context) => const FirstScreen(),
        'profile_page': (context) => const ProfilePage(),
        'following_detail_page': (context) => const FollowingDetailPage(),
        'follower_detail_page': (context) => const FollowerDetailPage(),
        'edit_profile_page': (context) => const EditProfilePage(),
        'about_page': (context) => const AboutPage(),
        'save_page': (context) => const SavePage(),
        'add_story': (context) => const AddStory(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/controllers/theme_controller.dart';
import 'package:social_media_app/views/screens/home.dart';
import 'package:social_media_app/views/screens/profile_page.dart';
import 'package:social_media_app/views/screens/search_page.dart';

import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          Home(),
          SearchPage(),
          AddPostPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (ind) {
          setState(() {
            index = ind;
          });
        },
        // selectedItemColor: Colors.white,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        unselectedItemColor: Provider.of<ThemeController>(context).isDark
            ? Colors.white
            : Colors.deepPurple,
        fixedColor: Provider.of<ThemeController>(context).isDark
            ? Colors.white
            : Colors.deepPurple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

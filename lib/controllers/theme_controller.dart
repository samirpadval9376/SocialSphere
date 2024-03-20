import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool isDark = false;
  String theme = 'theme';

  SharedPreferences prefs;

  ThemeController({required this.prefs});

  bool get getTheme {
    if (prefs.getBool(theme) ?? false) {
      isDark = prefs.getBool(theme)!;
    } else {
      prefs.setBool(theme, isDark);
    }
    return isDark;
  }

  void changeTheme() {
    isDark = !isDark;
    prefs.setBool(theme, isDark);
    notifyListeners();
  }
}

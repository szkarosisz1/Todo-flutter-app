import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  int selectedBackground = 0;

  final List<List<Color>> backgrounds = [
    [const Color(0xFF667eea), const Color(0xFF764ba2)],
    [const Color(0xFFff9966), const Color(0xFFff5e62)],
    [const Color(0xFF56ab2f), const Color(0xFFa8e063)],
    [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
  ];

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  void changeBackground(int index) {
    selectedBackground = index;
    notifyListeners();
  }

  LinearGradient get currentGradient {
    return LinearGradient(
      colors: backgrounds[selectedBackground],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  ThemeMode get themeMode {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

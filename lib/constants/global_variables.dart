import 'package:flutter/material.dart';

String uri = 'http://<yourip>:3000';

class GlobalVariables {
  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xFF000D1A),
      Color(0xFF001F3F),
    ],
    stops: [0.5, 1.0],
  );

  static const backgroundColorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000D1A),
      Color(0xFF001F3F),
    ],
    stops: [0.5, 1.0],
  );

  static const Color primaryColor = Color(0xFF073b4c); // Dark Blue Color
  // static const Color secondaryColor = Color(0xFFeed9d1); // Light Color
  // static const Color backgroundColor = Color(0xFFD7AB9D); // Background Color
  static const secondaryColor = Color(0xFF4D9DE0);
  static const backgroundColor = Color(0xFF000D1A);
  static const utilityColor = Color(0xFF001F3F);
  static const Color greyBackgroundColor = Color(0xFF001D34);
  static var selectedNavBarColor = const Color.fromARGB(255, 58, 109, 237);
  static const unselectedNavBarColor = Colors.white70;
  static const bottomBarBackgroundColor = Color.fromARGB(255, 57, 56, 67);
  static const graphIncomeColor = Color.fromARGB(255, 82, 82, 87);
  static const graphSavingsColor = Color.fromARGB(255, 30, 59, 93);
  // static const Color utilityColor = Color(0xFF333333);
}

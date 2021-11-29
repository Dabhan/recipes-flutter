import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 40.0,
        color: const Color(0xFF807a6b),
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData(
      primaryColor:
          defaultTargetPlatform == TargetPlatform.iOS ? Colors.white : null);

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      indicatorColor: Colors.purple,
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xFF807A6B),
        unselectedLabelColor: const Color(0xFFCCC5AF),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple));
}

ThemeData darkTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline5: base.headline5.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 40.0,
        color: const Color(0xFF807a6b),
      ),
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor:
          defaultTargetPlatform == TargetPlatform.iOS ? Colors.grey[850] : null,
      brightness: Brightness.dark);

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      indicatorColor: Colors.white,
      backgroundColor: Colors.black,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xFF807A6B),
        unselectedLabelColor: const Color(0xFFCCC5AF),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple));
}

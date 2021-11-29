import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final ThemeData base =
      ThemeData(primaryColor: Platform.isIOS ? Colors.white : null);

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
  final ThemeData base = ThemeData.dark().copyWith(
      primaryColor: Platform.isIOS ? Colors.grey[850] : null,
      primaryColorDark: Platform.isIOS ? Colors.grey[850] : null,
      primaryColorLight: Platform.isIOS ? Colors.grey[850] : null,
      brightness: Brightness.dark);

  // And apply changes on it:
  return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        color: Colors.grey[850],
      ),
      indicatorColor: Colors.white,
      backgroundColor: Colors.black,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xFF807A6B),
        unselectedLabelColor: const Color(0xFFCCC5AF),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple));
}

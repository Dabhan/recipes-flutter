import 'package:flutter/material.dart';
import 'package:recipes/ui/screens/home.dart';
import 'package:recipes/ui/screens/login.dart';
import 'package:recipes/ui/screens/theme.dart';



class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      routes: {
        // If you're using navigation routes, Flutter needs a base route.
        // We're going to change this route once we're ready with 
        // implementation of HomeScreen.
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
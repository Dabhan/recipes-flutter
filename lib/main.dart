import 'package:flutter/material.dart';
import 'package:recipes/app.dart';
import 'package:recipes/state_widget.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ui/screens/loading.dart';
import 'ui/screens/somethingwentwrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new StateWidget(
    child: FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(home: SomethingWentWrong());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return RecipesApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(home: Loading());
      },
    ),
  ));
}

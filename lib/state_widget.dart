import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipes/model/state.dart';
import 'package:recipes/utils/auth.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_StateDataWidget>())
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    User firebaseUser = await signIntoFirebase(googleAccount);
    state.user = firebaseUser; // new
    List<String> favourites = await getFavourites(); // new
    setState(() {
      state.isLoading = false;
      state.favourites = favourites; // new
    });
  }

  Future<void> signOut() async {
    await signOutFirebase(googleSignIn);
    googleAccount = null;
    setState(() {
      state.user = null;
    });
  }

  Future<List<String>> getFavourites() async {
    DocumentSnapshot<Map> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data().containsKey('favorites') &&
        querySnapshot.data()['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data()['favorites']);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}

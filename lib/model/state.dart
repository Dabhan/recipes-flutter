import 'package:firebase_auth/firebase_auth.dart';

class StateModel {
  bool isLoading;
  FirebaseUser user;
  List<String> favourites;

  StateModel({
    this.isLoading = false,
    this.user,
  });
}
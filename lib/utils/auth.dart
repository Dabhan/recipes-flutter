import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  if (account == null) {
    try {
      account = await googleSignIn.signInSilently();
    } catch (exception) {
      print(exception);
    }
  }
  return account;
}

Future<FirebaseUser> signIntoFirebase(
    GoogleSignInAccount googleSignInAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await _auth.signInWithCredential(credential);
}

Future<void> signOutFirebase (GoogleSignIn googleSignIn) async{
  await googleSignIn.signOut();
  FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signOut();
}

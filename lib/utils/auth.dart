import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;

  // Try to sign in the previous user:
  if (account != null && account.id == null) {
    await googleSignIn.disconnect();
    account = null;
  }
  if (account == null) {
    try {
      account = await googleSignIn.signInSilently(suppressErrors: false);
      if (account != null && account.id == null) {
        await googleSignIn.disconnect();
        account = null;
      }
    } catch (exception) {}
  }
  return account;
}

Future<User> signIntoFirebase(GoogleSignInAccount googleSignInAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  var result = await _auth.signInWithCredential(credential);
  return result.user;
}

Future<void> signOutFirebase(GoogleSignIn googleSignIn) async {
  await googleSignIn.signOut();
  FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signOut();
}

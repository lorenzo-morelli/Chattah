import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';
import 'database.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  String getUid() {
    User? user = _auth.currentUser;
    return user!.uid;
  }

  MyUser _userOfFirebase(User user) {
    return MyUser(user.uid);
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((user) => _userOfFirebase(user!));
  }

  Future signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;
    final name = user!.displayName.toString();
    var parts = name.split(' ');
    var firstName = parts[0].trim();
    var lastName = parts[1].trim();
    final userData = UserData(
      uid: user.uid,
      firstName: firstName,
      lastName: lastName,
    );
    DatabaseService().addUser(userData);
    return _userOfFirebase(user);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}

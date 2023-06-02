import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    print(googleSignIn.currentUser);

    //add user on database
    // await _firestore.collection('users').doc(credential.user!.uid).set({
    //   'username': userName,
    //   'uid': credential.user!.uid,
    //   'email': email,
    //   'followers': [],
    //   'following': [],
    // });

    notifyListeners();
  }

  Future logout() async {
    if (googleSignIn.currentUser != null) await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}

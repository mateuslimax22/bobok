import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

final userStore = UserStore();

class GoogleSignInProvider extends ChangeNotifier {
  GoogleSignInProvider(this._context);
  final googleSignIn = GoogleSignIn();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late final BuildContext _context;
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  String getSystemLocaleString() {
    final locale = Platform.localeName;
    if (locale.contains('_')) {
      final parts = locale.split('_');
      return '${parts[0]}_${parts[1].toUpperCase()}';
    }
    return locale;
  }

  Future googleLogin(BuildContext context, UserProvider userProvider) async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      try {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          if (user.emailVerified) {
            DocumentReference userDocRef = FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid);
            DocumentSnapshot snap = await userDocRef.get();

            if (snap.exists) {
              var uidFmc = snap.data() as Map<String, dynamic>;
              if (uidFmc["uidFmc"] == '') {
                final token = await _firebaseMessaging.getToken().then((token) {
                  return token;
                });

                await _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'uidFmc': token,
                });
              }
              var userData = UserData.fromSnap(snap);
              userProvider.setUser(userData);
            } else {
              String? fileUrl;
              List url = [googleSignIn.currentUser!.photoUrl];

              final fileRef = _storage
                  .ref()
                  .child("profilePics")
                  .child(_auth.currentUser!.uid);

              var response = await http.get(Uri.parse(url[0].toString()));
              Directory documentDirectory =
                  await getApplicationDocumentsDirectory();
              File file = File(join(documentDirectory.path, 'imagetest.png'));
              file.writeAsBytesSync(response.bodyBytes);

              await fileRef.putFile(file);

              fileUrl = await fileRef.getDownloadURL();
              final lan = getSystemLocaleString();
              final token = await _firebaseMessaging.getToken().then((token) {
                return token;
              });

              //add user on database
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .set({
                'username': googleSignIn.currentUser!.displayName,
                'searchname':
                    googleSignIn.currentUser!.displayName!.toLowerCase(),
                'uid': _auth.currentUser!.uid,
                'email': googleSignIn.currentUser!.email,
                'followers': [],
                'following': [],
                'blocked': [],
                'blocking': [],
                'uidFmc': token,
                'language': lan,
                'myfav': [],
                'photoUrl': fileUrl,
              });

              var userData = UserData.fromMap({
                'username': googleSignIn.currentUser!.displayName,
                'uid': _auth.currentUser!.uid,
                'email': googleSignIn.currentUser!.email,
                'followers': [],
                'following': [],
                'blocked': [],
                'blocking': [],
                'myfav': [],
                'photoUrl': fileUrl,
              });

              userProvider.setUser(userData);
            }
          }
        }
      } catch (error) {
        print("Erro durante a autenticação com o Google: $error");
        // Trate o erro conforme necessário
      }
    }
  }

  Future logout() async {
    if (googleSignIn.currentUser != null) await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}

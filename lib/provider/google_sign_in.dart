import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final userStore = UserStore();

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context, UserProvider userProvider) async {
    final googleUser = await googleSignIn.signIn();
    var userStore = Provider.of<UserStore>(context, listen: false);

    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    // Verificar se o usuário já existe no banco de dados
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    DocumentSnapshot snap = await userDocRef.get();

    if (snap.exists) {
      // var userData = UserData.fromSnap(snap);
      // userStore.setUser(userData);
      //userProvider.setUser(userData);
      // userStore.setUser(userData);
    } else {
      String? fileUrl;
      List url = [googleSignIn.currentUser!.photoUrl];

      final fileRef =
          _storage.ref().child("profilePics").child(_auth.currentUser!.uid);

      var response = await http.get(Uri.parse(url[0].toString()));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = File(join(documentDirectory.path, 'imagetest.png'));
      file.writeAsBytesSync(response.bodyBytes);

      await fileRef.putFile(file);

      fileUrl = await fileRef.getDownloadURL();

      //add user on database
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'username': googleSignIn.currentUser!.displayName,
        'uid': _auth.currentUser!.uid,
        'email': googleSignIn.currentUser!.email,
        'followers': [],
        'following': [],
        'photoUrl': fileUrl,
      });
    }
  }

  Future logout() async {
    if (googleSignIn.currentUser != null) await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}

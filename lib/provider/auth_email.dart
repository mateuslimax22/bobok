import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';

class AuthEmail extends ChangeNotifier {
  AuthEmail(this._context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;
  bool isLoading = true;

  late final BuildContext _context;

  // AuthService() {
  //   _authCheck();
  // }

  // _authCheck() {
  //   _auth.authStateChanges().listen((User? userFireBase) {
  //     user = (userFireBase == null) ? null : userFireBase;
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }

  Future<UserData?> createUserWithEmailAndPassword(
      String userName, String email, String password, File? avatar) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await credential.user?.updateDisplayName(userName);

      String? fileUrl;

      if (avatar != null) {
        final fileName = '${const Uuid().v4()}}${avatar.path.split('.').last}';

        final fileRef = _storage.ref(fileName);

        await fileRef.putFile(avatar);

        fileUrl = await fileRef.getDownloadURL();

        await credential.user?.updatePhotoURL(fileUrl);
      }
      return UserData(avatar: fileUrl, username: userName, email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Ocorreu um erro desconhecido!")),
      );
    }

    return null;
  }

  Future<UserData?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return UserData(
          avatar: credential.user?.photoURL,
          username: credential.user?.displayName,
          email: credential.user?.email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Ocorreu um erro desconhecido!")),
      );
    }

    return null;
  }
}

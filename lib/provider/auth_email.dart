import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthEmail extends ChangeNotifier {
  AuthEmail(this._context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  bool isLoading = true;

  late final BuildContext _context;

  Future<UserData?> createUserWithEmailAndPassword(
      String userName, String email, String password, File? avatar) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await credential.user?.updateDisplayName(userName);

      String? fileUrl;

      if (avatar != null) {
        final fileRef =
            _storage.ref().child("profilePics").child(credential.user!.uid);

        await fileRef.putFile(avatar);

        fileUrl = await fileRef.getDownloadURL();

        await credential.user?.updatePhotoURL(fileUrl);
      }
      //add user on database
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': userName,
        'uid': credential.user!.uid,
        'email': email,
        'followers': [],
        'following': [],
        'photoUrl': fileUrl,
      });
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

  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserData.fromSnap(documentSnapshot);
  }
}

import 'dart:io';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/provider/user_provider.dart';
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
    String userName,
    String email,
    String password,
    File? avatar,
    UserProvider userProvider,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await credential.user?.updateDisplayName(userName);

      String? fileUrl;

      if (avatar != null) {
        final fileRef = _storage
            .ref()
            .child("profilePics")
            .child('${credential.user!.uid}.jpg');

        await fileRef.putFile(avatar);

        fileUrl = await fileRef.getDownloadURL();

        await credential.user?.updatePhotoURL(fileUrl);
      }
      //add user on database
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': userName,
        'searchname': userName.toLowerCase(),
        'uid': credential.user!.uid,
        'email': email,
        'followers': [],
        'following': [],
        'blocked': [],
        'blocking': [],
        'myfav': [],
        'photoUrl': fileUrl,
      });

      var userData = UserData.fromMap({
        'username': userName,
        'uid': credential.user!.uid,
        'email': email,
        'followers': [],
        'following': [],
        'blocked': [],
        'blocking': [],
        'myfav': [],
        'photoUrl': fileUrl,
      });

      userProvider.setUser(userData);

      return UserData(avatar: fileUrl, username: userName, email: email);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Ocorreu um erro desconhecido!")),
      );
    }

    return null;
  }

  Future<void> updateProfile(String uid, String? userName, String? oldPhotoUrl,
      File? newAvatar, UserStore? userStore) async {
    try {
      // Atualizar o nome de usuário no Firebase Authentication
      if (userName != null && userName != '') {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
        userStore?.setUser(
          UserData(
              username: userName,
              uid: userStore.user!.uid,
              email: userStore.user!.email,
              avatar: userStore.user!.avatar,
              followers: userStore.user!.followers,
              following: userStore.user!.following,
              blocked: userStore.user!.blocked,
              blocking: userStore.user!.blocking,
              myfav: userStore.user!.myfav),
        );
      }

      String? fileUrl;
      // Se uma nova foto estiver sendo fornecida, atualize-a e exclua a antiga
      if (newAvatar != null) {
        final fileRef = FirebaseStorage.instance
            .ref()
            .child("profilePics")
            .child('$uid.jpg');

        // Upload da nova foto
        await fileRef.putFile(newAvatar);

        // Obtenção da URL da nova foto
        fileUrl = await fileRef.getDownloadURL();
        // Excluir a foto antiga do Firebase Storage

        userStore?.setUser(
          UserData(
              username: userStore.user!.username,
              uid: userStore.user!.uid,
              email: userStore.user!.email,
              avatar: fileUrl.toString(),
              followers: userStore.user!.followers,
              following: userStore.user!.following,
              blocked: userStore.user!.blocked,
              blocking: userStore.user!.blocking,
              myfav: userStore.user!.myfav),
        );
      }

      // Atualizar as informações do usuário no Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        if (userName != null && userName != '') 'username': userName,
        if (userName != null && userName != '') 'searchname': userName,
        if (fileUrl != null) 'photoUrl': fileUrl.toString(),
      });
    } catch (e) {
      print("Erro ao atualizar perfil: $e");
      // Lidar com o erro conforme necessário
    }
  }

  String mapFirebaseErrorMessage(String? errorCode) {
    print(errorCode);
    switch (errorCode) {
      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
        return 'Usuário não encontrado. Por favor, verifique o email ou senha digitado';
      case 'The password is invalid or the user does not have a password.':
        return 'Usuário não encontrado. Por favor, verifique o email ou senha digitado';
      case 'The email address is badly formatted.':
        return 'O formato do email está incorreto.';
      default:
        return 'Ocorreu um erro durante a autenticação. Por favor, tente novamente mais tarde.';
    }
  }

  Future signInWithEmailAndPassword(
      UserProvider userProvider, String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      DocumentSnapshot snap = await userDocRef.get();
      var userData = UserData.fromSnap(snap);
      userProvider.setUser(userData);
      return "login";
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
            // ignore: use_build_context_synchronously
            backgroundColor: Theme.of(_context).colorScheme.onError,
            content: Text(
              mapFirebaseErrorMessage(e.message),
              style: TextStyle(
                  // ignore: use_build_context_synchronously
                  color: Theme.of(_context).colorScheme.primary,
                  fontSize: 15,
                  letterSpacing: 1.5),
            )),
      );
      return e.message;
    }
  }

  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserData.fromSnap(documentSnapshot);
  }
}

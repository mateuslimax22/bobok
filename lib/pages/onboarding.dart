import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  Future<void> getUserData(uid, UserProvider userProvider) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      DocumentSnapshot snap = await userDocRef.get();
      if (snap.exists) {
        var userData = UserData.fromSnap(snap);
        userProvider
            .setUser(userData); // Use a instância fornecida de UserProvider
      } else {
        print("O documento não existe no Firestore.");
      }
    } catch (e) {
      print("Erro ao obter dados do Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(), // Crie uma instância de UserProvider
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Algo deu errado ;( '),
                );
              } else if (snapshot.hasData) {
                // Verifique se o UserProvider está preenchido com os dados do usuário
                if (userProvider.user != null) {
                  // O UserProvider está preenchido, navegue para a Home
                  return const Home();
                } else {
                  getUserData(snapshot.data?.uid, userProvider);
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                // O UserProvider não está preenchido, provavelmente o usuário precisa fazer login
                return const SignIn();
              }
            },
          );
        },
      ),
    );
  }
}

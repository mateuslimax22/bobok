import 'package:bobok/mobx/user_store.dart';
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
  @override
  Widget build(BuildContext context) {
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
          return const Home();
        } else {
          // O UserStore não está preenchido, provavelmente o usuário precisa fazer login
          return const SignIn();
        }
      },
    );
  }
}

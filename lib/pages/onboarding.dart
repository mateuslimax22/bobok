import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.error),
          );
        } else if (snapshot.hasData) {
          final userProvider = Provider.of<UserProvider>(context);
          final UserData? user = userProvider.user;

          if (user != null) {
            return Home(
              userData: UserData(
                uid: user.uid,
                username: user.username,
                email: user.email,
                avatar: user.avatar,
                followers: user.followers,
                following: user.following,
                blocked: user.blocked,
                blocking: user.blocking,
                myfav: user.myfav,
              ),
            ); // Se o usuário estiver autenticado e os dados do usuário estiverem disponíveis, vá para a tela inicial
          } else {
            UserStore().loadUserFromCache(userProvider);
            return const Center(
                child:
                    CircularProgressIndicator()); // Caso contrário, exiba um indicador de progresso enquanto os dados do usuário estão sendo carregados
          }
        } else {
          // O usuário não está autenticado, provavelmente precisa fazer login
          return const SignIn();
        }
      },
    );
  }
}

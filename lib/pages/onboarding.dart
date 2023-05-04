import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/onboard_modal.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/btn/elevated.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
          return Home();
        } else {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/backZoo.png"), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          image: AssetImage("images/logoWhite.png"),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Bem vindo ao \n BoBok.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(letterSpacing: 0.5)),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                              'Navegue e se divirta com a melhor experiência \n em leitura.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(letterSpacing: 0.5)),
                        ),
                        ElevatedButtonTh(
                          label: 'Começar',
                          target: () {
                            return showBarModalBottomSheet(
                                context: context,
                                builder: (context) => const OnboardModal());
                          },
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          width: 260,
                          height: 45,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

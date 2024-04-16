// ignore_for_file: use_build_context_synchronously

import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/delete/modal_vericate.dart';
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
  bool isVerificate = false;
  late List isModalVisible;
  @override
  void initState() {
    super.initState();
    isModalVisible = [];
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    String imagePath = currentBrightness == Brightness.light
        ? 'images/backZoo.png'
        : 'images/backDark.png';

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (isModalVisible.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isModalVisible = [];
            });
          });
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.error),
          );
        } else if (snapshot.hasData) {
          final userProvider = Provider.of<UserProvider>(context);
          final UserData? userEnter = userProvider.user;

          if (userEnter != null) {
            return Home(
              userData: UserData(
                uid: userEnter.uid,
                username: userEnter.username,
                email: userEnter.email,
                avatar: userEnter.avatar,
                followers: userEnter.followers,
                following: userEnter.following,
                blocked: userEnter.blocked,
                blocking: userEnter.blocking,
                myfav: userEnter.myfav,
              ),
            ); // Se o usuário estiver autenticado e os dados do usuário estiverem disponíveis, vá para a tela inicial
          } else {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              isModalVisible.add("1");
              if (user.emailVerified) {
                UserStore().loadUserFromCache(userProvider);
                return Scaffold(
                  body: Container(
                    height: deviceHeight,
                    width: deviceWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imagePath), fit: BoxFit.cover),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              } else {
                return Scaffold(
                  body: Container(
                    height: deviceHeight,
                    width: deviceWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imagePath), fit: BoxFit.cover),
                    ),
                    child: VerificateModal(
                      onDelete: () async {
                        try {
                          await user.sendEmailVerification();
                        } catch (error) {
                          // Em caso de erro, exiba uma mensagem de erro
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                  '${AppLocalizations.of(context)!.sendError}$error',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 15,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 15,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      isVisible: isModalVisible,
                    ),
                  ),
                );
              }
            } else {
              // O usuário não está autenticado, provavelmente precisa fazer login
              return Container();
            }
          }
        } else {
          // O usuário não está autenticado, provavelmente precisa fazer login
          return const SignIn();
        }
      },
    );
  }
}

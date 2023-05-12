import 'package:bobok/pages/home.dart';
import 'package:bobok/pages/onboard_modal.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;

  List<String> genresSelect = [];
  FocusNode myFocusNodeEmail = new FocusNode();
  FocusNode myFocusNodePassw = new FocusNode();
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
          return Scaffold(
            body: SingleChildScrollView(
              reverse: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/backZoo.png"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image: AssetImage("images/logoWhite.png"),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.8),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Bem vindo ao BoBok',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(letterSpacing: 0.5)),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: PhysicalModel(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    elevation: 2.0,
                                    shadowColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: TextFormField(
                                      focusNode: myFocusNodeEmail,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: myFocusNodeEmail.hasFocus
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 0),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (email) {
                                        _formData['email'] = email ?? '';
                                      },
                                      validator: (email) {
                                        final title = email ?? '';

                                        if (title.trim().isEmpty) {
                                          return 'Email obrigatório.';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: PhysicalModel(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    elevation: 2.0,
                                    shadowColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: TextFormField(
                                      focusNode: myFocusNodePassw,
                                      decoration: InputDecoration(
                                        labelText: "Senha",
                                        labelStyle: TextStyle(
                                            color: myFocusNodePassw.hasFocus
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 0),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (senha) {
                                        _formData['senha'] = senha ?? '';
                                      },
                                      validator: (senha) {
                                        final title = senha ?? '';

                                        if (title.trim().isEmpty) {
                                          return 'Senha obrigatória.';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButtonTh(
                                label: 'Começar',
                                target: () {
                                  return showBarModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          const OnboardModal());
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
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

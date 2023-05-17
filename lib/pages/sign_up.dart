import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../wisgets/btn/elevated.dart';
import 'onboard_modal.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool passwordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/backZoo.png"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.97,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.8),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: PhysicalModel(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.background,
                              elevation: 2.0,
                              shadowColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle:
                                      const TextStyle(letterSpacing: 0.5),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  contentPadding: const EdgeInsets.symmetric(
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: PhysicalModel(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.background,
                              elevation: 2.0,
                              shadowColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: "Senha",
                                  labelStyle:
                                      const TextStyle(letterSpacing: 0.5),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      child: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: !passwordVisible,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButtonTh(
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
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Divider(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  height: 28,
                                )),
                          ),
                          Text(
                            "OR",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(letterSpacing: 0.5),
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Divider(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  height: 28,
                                )),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton.icon(
                            label: const Text("Continuar com o Google"),
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Color.fromARGB(255, 214, 45, 32),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.8, 50),
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Não possue conta? ",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.ADD_REVIEW);
                                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
                                },
                                child: Text("Cadastre-se.",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        )
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
}

import 'package:bobok/provider/auth_email.dart';
import 'package:flutter/material.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../wisgets/btn/elevated.dart';

class SignInConatiner extends StatefulWidget {
  const SignInConatiner({super.key});

  @override
  State<SignInConatiner> createState() => _SignInConatiner();
}

class _SignInConatiner extends State<SignInConatiner> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool isLoadingEmail = false;
  bool passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void submitForm() async {
      setState(() {
        isLoadingEmail = true;
      });
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        notValid = true;
        setState(() {
          isLoadingEmail = false;
        });
        return;
      }

      _formKey.currentState?.save();

      var resp = await AuthEmail(context).signInWithEmailAndPassword(
        Provider.of<UserProvider>(context, listen: false),
        _formData["email"].toString(),
        _formData['senha'].toString(),
      );

      if (resp != "login") {
        setState(() {
          isLoadingEmail = false;
        });
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Bem vindo ao BoBok',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    letterSpacing: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PhysicalModel(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.background,
                  elevation: 2.0,
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  child: TextFormField(
                    style: TextStyle(
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        letterSpacing: 0.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
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
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  child: TextFormField(
                    style: TextStyle(
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      labelStyle: TextStyle(
                        letterSpacing: 0.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
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
                target: () async {
                  submitForm();
                },
                fontSize: 20,
                fontWeight: FontWeight.w500,
                width: 260,
                height: 45,
                isLoading: isLoadingEmail,
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Theme.of(context).colorScheme.onPrimary,
                      height: 30.8,
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
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Theme.of(context).colorScheme.onPrimary,
                      height: 28,
                    )),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ElevatedButton.icon(
                label: const Text("Continuar com o Google"),
                icon: isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 3,
                        ),
                      )
                    : const FaIcon(
                        FontAwesomeIcons.google,
                        color: Color.fromARGB(255, 214, 45, 32),
                      ),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.8, 50),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin(context,
                      Provider.of<UserProvider>(context, listen: false));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

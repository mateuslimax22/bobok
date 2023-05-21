import 'package:bobok/pages/onboard_modal.dart';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../wisgets/btn/elevated.dart';

class SignUpConatiner extends StatefulWidget {
  const SignUpConatiner({super.key});

  @override
  State<SignUpConatiner> createState() => _SignUpConatiner();
}

class _SignUpConatiner extends State<SignUpConatiner> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  void _validatePassword(String password) {
    List<int> passwordValid = [];
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (hasUppercase) passwordValid.add(1);
    if (hasLowercase) passwordValid.add(1);
    if (hasDigits) passwordValid.add(1);
    if (hasSpecialCharacters) passwordValid.add(1);

    if (passwordValid.length <= 2) {
      print("fraca");
    } else if (passwordValid.length == 3) {
      print("media");
    } else {
      print("forte");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Nova conta BoBok',
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
                  shadowColor: Theme.of(context).colorScheme.onPrimary,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(letterSpacing: 0.5),
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
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      labelStyle: const TextStyle(letterSpacing: 0.5),
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
                    onChanged: (value) {
                      _validatePassword(_passwordController.text);
                    },
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
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: deviceWidth * 0.8,
                child: const Text(
                    "Utilize letra maiuscula, número e caracteres especiais"),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.8,
              height: 5,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Define o número de contêineres desejados
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3))),
                      width: deviceWidth * 0.147,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: deviceWidth * 0.8,
                child: Row(
                  children: [Text("Nivel: "), Text("media")],
                ),
              ),
            ),
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
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Confirmar senha",
                      labelStyle: const TextStyle(letterSpacing: 0.5),
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
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                          },
                          child: Icon(confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: !confirmPasswordVisible,
                    onSaved: (confirmaSenha) {
                      _formData['confirmaSenha'] = confirmaSenha ?? '';
                    },
                    validator: (confirmaSenha) {
                      final title = confirmaSenha ?? '';

                      if (title.trim().isEmpty) {
                        return 'Confirmar a senha obrigatório.';
                      } else if (title.trim() != _formData['senha']) {
                        return 'Senhas diferentes';
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
                label: 'Cadastrar',
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
          ],
        ),
      ),
    );
  }
}

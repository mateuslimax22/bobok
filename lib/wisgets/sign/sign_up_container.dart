import 'dart:io';
import 'package:bobok/provider/auth_email.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/modal/modal_politic.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../wisgets/btn/elevated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpConatiner extends StatefulWidget {
  const SignUpConatiner({super.key});

  @override
  State<SignUpConatiner> createState() => _SignUpConatiner();
}

class _SignUpConatiner extends State<SignUpConatiner> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  File? _avatar;
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isPrivicy = false;
  bool isModalVisibleEmail = false;

  bool is6Digits = false;
  bool isUppercase = false;
  bool isNumber = false;
  bool isLoadingRegister = false;
  bool isSpecialCharacters = false;
  String levelPassword = "";

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    void validatePassword(String password) {
      List<int> passwordValid = [];
      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialCharacters =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      if (hasUppercase) {
        passwordValid.add(1);
        setState(() {
          isUppercase = true;
        });
      } else {
        setState(() {
          isUppercase = false;
        });
      }
      if (hasLowercase) passwordValid.add(1);
      if (hasDigits) {
        passwordValid.add(1);
        setState(() {
          isNumber = true;
        });
      } else {
        setState(() {
          isNumber = false;
        });
      }
      if (hasSpecialCharacters) {
        passwordValid.add(1);
        setState(() {
          isSpecialCharacters = true;
        });
      } else {
        setState(() {
          isSpecialCharacters = false;
        });
      }

      if (password.length < 6) {
        setState(() {
          levelPassword = AppLocalizations.of(context)!.passWeak;
          is6Digits = true;
        });
      } else {
        setState(() {
          is6Digits = true;
        });
        if (passwordValid.length <= 2) {
          setState(() {
            levelPassword = AppLocalizations.of(context)!.passWeak;
          });
        } else if (passwordValid.length == 3) {
          setState(() {
            levelPassword = AppLocalizations.of(context)!.passModerate;
          });
        } else {
          setState(() {
            levelPassword = AppLocalizations.of(context)!.passStrong;
          });
        }
      }
    }

    void uploadImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );

      if (image != null) {
        setState(() {
          _avatar = File(image.path);
        });
      }
    }

    void submitForm() async {
      setState(() {
        isLoadingRegister = true;
      });
      _formKey.currentState?.save();
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        notValid = true;
        setState(() {
          isLoadingRegister = false;
        });
        return;
      }

      await AuthEmail(context).createUserWithEmailAndPassword(
          _formData["user"].toString(),
          _formData["email"].toString(),
          _formData['senha'].toString(),
          _avatar,
          Provider.of<UserProvider>(context, listen: false));
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TermsModal(
                onDelete: () {
                  setState(() {
                    isPrivicy = true;
                    isModalVisibleEmail = false;
                  });
                  submitForm();
                },
                isVisible: isModalVisibleEmail),
            Text(AppLocalizations.of(context)!.newbobok,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(letterSpacing: 0.5)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 110,
                width: 110,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4), // Border width
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(48), // Image radius
                          child: _avatar == null
                              ? IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.person,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    size: 80,
                                  ),
                                  onPressed: () {
                                    uploadImage();
                                  },
                                )
                              : Image.file(
                                  _avatar!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Theme.of(context).colorScheme.background,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                uploadImage();
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Text(AppLocalizations.of(context)!.selectPhoto,
                style: TextStyle(
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
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
                      labelText: AppLocalizations.of(context)!.email,
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
                        return AppLocalizations.of(context)!.emailReq;
                      }
                      // Expressão regular para verificar se o e-mail possui o formato correto
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegex.hasMatch(title)) {
                        return AppLocalizations.of(context)!.emailValid;
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.user,
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
                    onSaved: (user) {
                      _formData['user'] = user ?? '';
                    },
                    validator: (user) {
                      final title = user ?? '';

                      if (title.trim().isEmpty) {
                        return AppLocalizations.of(context)!.userReq;
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                      labelText: AppLocalizations.of(context)!.password,
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
                          child: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                    onChanged: (value) {
                      validatePassword(_passwordController.text);
                    },
                    keyboardType: TextInputType.text,
                    obscureText: !passwordVisible,
                    onSaved: (senha) {
                      _formData['senha'] = senha ?? '';
                    },
                    validator: (senha) {
                      final title = senha ?? '';

                      if (title.trim().isEmpty) {
                        return AppLocalizations.of(context)!.passReq;
                      } else if (levelPassword ==
                              AppLocalizations.of(context)!.passWeak ||
                          levelPassword ==
                              AppLocalizations.of(context)!.passModerate) {
                        return AppLocalizations.of(context)!.passErrorStrong;
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
                width: deviceWidth * 0.8,
                height: 90,
                child: GridView.count(
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          color: isUppercase ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                          AppLocalizations.of(context)!.upLetter,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          color: isNumber ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                          AppLocalizations.of(context)!.numbers,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          color:
                              isSpecialCharacters ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                          AppLocalizations.of(context)!.charSpe,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          color:
                              isSpecialCharacters ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Text(
                          AppLocalizations.of(context)!.digits6,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ))
                      ],
                    ),
                  ],
                )),
            SizedBox(
              width: deviceWidth * 0.8,
              height: 5,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: levelPassword == "" ||
                        levelPassword == AppLocalizations.of(context)!.passWeak
                    ? 1
                    : levelPassword ==
                            AppLocalizations.of(context)!.passModerate
                        ? 3
                        : 5, // Define o número de contêineres desejados
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: levelPassword == "" ||
                                  levelPassword ==
                                      AppLocalizations.of(context)!.passWeak
                              ? Colors.red
                              : levelPassword ==
                                      AppLocalizations.of(context)!.passModerate
                                  ? Colors.orange
                                  : Colors.green,
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
                  children: [
                    Text(
                      AppLocalizations.of(context)!.level,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      levelPassword,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )
                  ],
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
                    style: TextStyle(
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.confPass,
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
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                          },
                          child: Icon(
                            confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: !confirmPasswordVisible,
                    onSaved: (confirmaSenha) {
                      _formData['confirmaSenha'] = confirmaSenha ?? '';
                    },
                    validator: (confirmaSenha) {
                      final title = confirmaSenha ?? '';
                      print(_formData['senha'].toString());

                      if (title.trim().isEmpty) {
                        return AppLocalizations.of(context)!.confPassReq;
                      } else if (title.trim().toString() !=
                          _formData['senha'].toString()) {
                        return AppLocalizations.of(context)!.difPass;
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
                label: AppLocalizations.of(context)!.signUp,
                target: () async {
                  if (isPrivicy == false) {
                    setState(() {
                      isModalVisibleEmail = true;
                    });
                  } else {
                    submitForm();
                  }
                },
                fontSize: 20,
                fontWeight: FontWeight.w500,
                width: 260,
                height: 45,
                isLoading: isLoadingRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

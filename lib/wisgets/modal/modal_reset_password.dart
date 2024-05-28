import 'package:bobok/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassModal extends StatefulWidget {
  final bool isVisible;

  const ResetPassModal({
    super.key,
    required this.isVisible,
  });

  @override
  State<ResetPassModal> createState() => _ResetPassModalState();
}

class _ResetPassModalState extends State<ResetPassModal> {
  final TextEditingController emailController = TextEditingController();
  bool sendEmail = false;

  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                  height: 130,
                  child: !sendEmail
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.resetPass,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: PhysicalModel(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  elevation: 2.0,
                                  shadowColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: TextFormField(
                                    controller: emailController,
                                    style: TextStyle(
                                      letterSpacing: 0.5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context)!.email,
                                      labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      border: InputBorder.none,
                                      counterText: '',
                                      errorStyle: const TextStyle(
                                        height:
                                            1, // Definir a altura do texto de erro
                                      ),
                                      errorMaxLines: 3,
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
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
                                      emailController.text = email ?? '';
                                    },
                                    validator: (email) {
                                      final title = email ?? '';

                                      if (title.trim().isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .emailReq;
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.sendEmail,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        )),
              actions: [
                !sendEmail
                    ? TextButton(
                        onPressed: () {
                          resetPassword();
                          setState(() {
                            sendEmail = true;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.confirm,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            letterSpacing: 1.5,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            );
          },
        );
      });
    }

    return Container(); // Return an empty container, as we don't want to render anything here.
  }
}

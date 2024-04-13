import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class VerificateModal extends StatefulWidget {
  final VoidCallback onDelete;
  final List isVisible;

  const VerificateModal({
    super.key,
    required this.onDelete,
    required this.isVisible,
  });

  @override
  State<VerificateModal> createState() => _VerificateModalState();
}

class _VerificateModalState extends State<VerificateModal> {
  bool isEmailSent = false;

  void startCountdown() {
    setState(() {
      isEmailSent = true; // Resetar o estado para email não enviado
    });
  }

  @override
  Widget build(BuildContext context) {
    void logout() async {
      // ignore: use_build_context_synchronously
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUser();
      final provider =
          // ignore: use_build_context_synchronously
          Provider.of<GoogleSignInProvider>(context, listen: false);
      provider.logout();
    }

    if (widget.isVisible.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 110,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.verify,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                    isEmailSent
                        ? Text(
                            AppLocalizations.of(context)!.emailVer,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              letterSpacing: 1.5,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    logout();
                  },
                  child: Text(AppLocalizations.of(context)!.exit,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary,
                          fontSize: 15,
                          letterSpacing: 1.5)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // widget.onDelete();
                    startCountdown();
                  },
                  child: Text(
                    isEmailSent
                        ? "Email enviado!"
                        : AppLocalizations.of(context)!.send,
                    style: TextStyle(
                      color: isEmailSent
                          ? Theme.of(context)
                              .colorScheme
                              .secondary // Cor para mostrar que o email foi enviado
                          : Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }

    return Container(); // Return an empty container, as we don't want to render anything here.
  }
}

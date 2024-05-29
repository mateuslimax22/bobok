import 'package:bobok/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class OnboardModal extends StatefulWidget {
  const OnboardModal({super.key});

  @override
  State<OnboardModal> createState() => _OnboardModal();
}

class _OnboardModal extends State<OnboardModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton.icon(
            label: const Text("Continuar com o Google"),
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Color.fromARGB(255, 214, 45, 32),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin(
                  context, Provider.of<UserProvider>(context, listen: false));
              Navigator.pop(context);
            },
          ),
          ElevatedButton.icon(
            label: const Text("Continuar com a Apple"),
            icon: const FaIcon(
              FontAwesomeIcons.apple,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              Navigator.pop(context);
              print("apple");
            },
          ),
          ElevatedButton.icon(
            label: const Text("Continuar com o FaceBook"),
            icon: const FaIcon(
              FontAwesomeIcons.facebook,
              color: Color.fromARGB(255, 66, 134, 244),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              Navigator.pop(context);
              print("face");
            },
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class OnboardModal extends StatefulWidget {
  const OnboardModal({super.key});

  @override
  State<OnboardModal> createState() => _OnboardModal();
}

class _OnboardModal extends State<OnboardModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(children: [
        //SignInButtonBuilder(
        //  text: "Continuar com o google",
        //  icon: Icons.,

        //  onPressed: () {
        //    print("google");
        //  }, backgroundColor: Theme.of(context).colorScheme.background,,
//),
        //SignInButton(Buttons.Apple, onPressed: () {
        //  print("apple");
        //}),
        //SignInButton(Buttons.FacebookNew, onPressed: () {
        //  print("face");
//}),
      ]),
    );
  }
}

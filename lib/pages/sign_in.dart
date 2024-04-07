import 'package:bobok/wisgets/sign/sign_in_container.dart';
import 'package:bobok/wisgets/sign/sign_up_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  Widget containerChild = const SignInConatiner();
  bool containerSizeHeight = false;
  bool _isVisible = true;
  bool _signIn = true;
  bool _enter = true;
  bool _showLogo = true;
  double _imageHeight = 1.0;

  void _changeContainer() {
    setState(() {
      if (containerSizeHeight == false) {
        containerSizeHeight = true;
        setState(() {
          _isVisible = !_isVisible;
          _signIn = false;
          _imageHeight = 0.5;
          _enter = false;
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _showLogo = false;
          });
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isVisible = !_isVisible;
            _enter = true;
          });
          containerChild = const SignUpConatiner();
        });
      } else {
        containerSizeHeight = false;
        setState(() {
          _isVisible = !_isVisible;
          _enter = false;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            containerChild = const Text("");
          });
        });

        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _isVisible = !_isVisible;
            _signIn = true;
            _showLogo = true;
            _enter = true;
            _imageHeight = 1.0;
          });
          containerChild = const SignInConatiner();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;
    String imagePath = currentBrightness == Brightness.light
        ? 'images/backZoo.png'
        : 'images/backDark.png';

    String imageLogo = currentBrightness == Brightness.light
        ? 'images/logoW.png'
        : 'images/logoD.png';

    Widget showContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _showLogo
              ? Text(
                  AppLocalizations.of(context)!.noAcc,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              : Text(
                  AppLocalizations.of(context)!.yesAcc,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
          InkWell(
            onTap: () {
              _changeContainer();
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
            },
            child: _showLogo
                ? Text(AppLocalizations.of(context)!.signUp,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5))
                : Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5),
                  ),
          ),
        ],
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        reverse: _signIn ? true : false,
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _signIn ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: _showLogo
                        ? AnimatedContainer(
                            height: MediaQuery.of(context).size.height *
                                0.4 *
                                _imageHeight,
                            width: MediaQuery.of(context).size.width *
                                _imageHeight,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment.centerLeft,
                                  image: AssetImage(imageLogo),
                                  fit: BoxFit.contain),
                            ),
                            duration: const Duration(milliseconds: 300),
                          )
                        : null),
              ),
              SizedBox(
                child: LayoutBuilder(builder: (context, constraints) {
                  return AnimatedContainer(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onError
                            .withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    height: containerSizeHeight
                        ? deviceHeight * 0.96
                        : constraints.maxWidth * 1.03,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AnimatedOpacity(
                              opacity: _isVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              child: containerChild),
                          AnimatedOpacity(
                              opacity: _enter ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              child: showContent)
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

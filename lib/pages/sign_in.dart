import 'package:bobok/wisgets/sign/sign_in_container.dart';
import 'package:bobok/wisgets/sign/sign_up_container.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  Widget containerChild = const SignInConatiner();
  double containerSizeHeight = deviceHeight * 0.47;
  bool _isVisible = true;
  bool _signIn = true;
  bool _enter = true;
  bool _showLogo = true;
  double _imageHeight = 1.0;
  void _changeContainer() {
    setState(() {
      if (containerSizeHeight == deviceHeight * 0.47) {
        containerSizeHeight = deviceHeight * 0.95;
        setState(() {
          _isVisible = !_isVisible;
          _signIn = false;
          _imageHeight = 0.5;
          _enter = false;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
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
        containerSizeHeight = deviceHeight * 0.47;
        setState(() {
          _isVisible = !_isVisible;
          _enter = false;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
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
    Widget showContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _showLogo
              ? Text(
                  "Não possui conta ? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )
              : Text(
                  "Já possui conta ? ",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
          InkWell(
            onTap: () {
              _changeContainer();
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage()), (route) => false);
            },
            child: _showLogo
                ? Text("Cadastre-se.",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5))
                : Text(
                    "Entar ",
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
              AnimatedOpacity(
                opacity: _signIn ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: _showLogo
                        ? AnimatedContainer(
                            height: MediaQuery.of(context).size.height *
                                0.4 *
                                _imageHeight,
                            width: MediaQuery.of(context).size.width *
                                _imageHeight,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment.centerLeft,
                                  image: AssetImage("images/logoWhite.png"),
                                  fit: BoxFit.contain),
                            ),
                            duration: const Duration(milliseconds: 500),
                          )
                        : null),
              ),
              AnimatedContainer(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20))),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  height: containerSizeHeight,
                  width: MediaQuery.of(context).size.width,
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

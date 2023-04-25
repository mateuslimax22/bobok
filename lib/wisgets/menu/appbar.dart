import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.primary,
      titleSpacing: 5,
      title: Image.asset('images/logoName.png',
          width: 138, height: 31, fit: BoxFit.fill),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.account_box,
            size: 40,
          ),
          tooltip: 'Show Snackbar',
          onPressed: () {
            print("sdasd");
          },
        ),
      ],
    );
  }
}

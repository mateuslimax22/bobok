import 'package:bobok/wisgets/src/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: 110,
              child: Stack(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.account_box,
                      size: 125,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: 'Show Snackbar',
                    onPressed: () {},
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
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 8),
                  child: Text(
                    "Mateus",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 25,
                        letterSpacing: 1.5),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.00),
                      child: Column(
                        children: [
                          Text(
                            "Avaliações",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                          Text(
                            "1000",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.00),
                      child: Column(
                        children: [
                          Text(
                            "Avaliadores",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                          Text(
                            "2000",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.00),
                      child: Column(
                        children: [
                          Text(
                            "Leitores",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                          Text(
                            "20",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        )
      ],
    ));
  }
}

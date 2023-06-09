import 'package:bobok/pages/profile.dart';
import 'package:bobok/pages/world.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/listCard/list_card_home.dart';
import 'package:bobok/wisgets/src/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 1;

  final pages = [
    const Text("livros"),
    ListCard(),
    const World(),
    Profile(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void menuAppbar(String value) {
      switch (value) {
        case 'Logout':
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.logout();
          break;
        case 'Settings':
          break;
      }
    }

    return Scaffold(
        extendBody: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.primary,
            titleSpacing: 5,
            title: Image.asset('images/logoName.png',
                width: 138, height: 31, fit: BoxFit.fill),
            actions: [
              index == 3
                  ? PopupMenuButton<String>(
                      onSelected: menuAppbar,
                      itemBuilder: (BuildContext context) {
                        return {'Logout', 'Settings'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      })
                  : index == 2
                      ? IconButton(
                          icon: const Icon(
                            Icons.search,
                            size: 35,
                          ),
                          tooltip: 'Show Snackbar',
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.SEARCH);
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 35,
                          ),
                          tooltip: 'Show Snackbar',
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.ADD_REVIEW);
                          },
                        )
            ]),
        bottomNavigationBar: CurvedNavigationBar(
          color: Theme.of(context).colorScheme.background,
          buttonBackgroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.primary,
          height: 50,
          items: [
            Icon(
              Icons.collections_bookmark,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(
              Icons.clear_all,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(
              Icons.all_inclusive,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(
              Icons.person,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
          index: 1,
          onTap: (index) {
            setState(() => this.index = index);
          },
        ),
        body: pages[index]);
  }
}

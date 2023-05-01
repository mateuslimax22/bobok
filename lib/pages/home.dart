import 'package:bobok/pages/profile.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/listCard/list_card_home.dart';
import 'package:bobok/wisgets/src/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

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
    const Text("mundo"),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 35,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.ADD_REVIEW);
              },
            ),
          ],
        ),
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

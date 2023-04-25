import 'package:bobok/pages/profile.dart';
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
                Icons.account_box,
                size: 40,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
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
              Icons.menu_book_rounded,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(
              Icons.add,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            Icon(
              Icons.compare_arrows,
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

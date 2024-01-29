import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/pages/books.dart';
import 'package:bobok/pages/my_list.dart';
import 'package:bobok/pages/profile.dart';
import 'package:bobok/pages/world.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/listCard/list_card_home.dart';
import 'package:bobok/wisgets/src/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late List<Widget> _pages;
  late UserStore userStore;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    userStore = UserStore();
    _getUser();

    _pageController = PageController(initialPage: _currentIndex);
    _pages = [
      MyList(),
      ListCard(userStore: userStore),
      World(
        uid: FirebaseAuth.instance.currentUser!.uid,
        userStore: userStore,
      ),
      Profile(
        uid: FirebaseAuth.instance.currentUser!.uid,
        currentUid: true,
        userStore: userStore,
      ),
    ];
  }

  Future<void> _getUser() async {
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    DocumentSnapshot snap = await userDocRef.get();
    var userData = UserData.fromSnap(snap);
    userStore.setUser(userData);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
            _currentIndex == 3
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
                : _currentIndex == 2
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
                          Navigator.of(context).pushNamed(AppRoutes.ADD_REVIEW);
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
          index: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            });
          }),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
    );
  }
}

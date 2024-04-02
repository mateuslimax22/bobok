import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/pages/my_list.dart';
import 'package:bobok/pages/profile.dart';
import 'package:bobok/pages/settings.dart';
import 'package:bobok/pages/world.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/listCard/list_card_home.dart';
import 'package:bobok/wisgets/src/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.userData});
  final UserData? userData;
  @override
  // ignore: library_private_types_in_public_api
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

    userStore.setUser(widget.userData!);

    _pageController = PageController(initialPage: _currentIndex);
    _pages = [
      MyList(
        userStore: userStore,
      ),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void openDrawer(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SettingsMenu(
            userStore: userStore,
          );
        },
      );
    }

    Brightness currentBrightness = Theme.of(context).brightness;
    String imagePath = currentBrightness == Brightness.light
        ? 'images/logoLight.png'
        : 'images/logoDark.png';

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.primary,
          titleSpacing: 5,
          title:
              Image.asset(imagePath, width: 133, height: 45, fit: BoxFit.fill),
          actions: [
            _currentIndex == 3
                ? IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => openDrawer(context),
                  )
                : _currentIndex == 2
                    ? IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 35,
                        ),
                        tooltip: 'Show Snackbar',
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.SEARCH,
                            arguments: {
                              'userStore': userStore,
                            },
                          );
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

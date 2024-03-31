import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key, this.userStore});
  final UserStore? userStore;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  void logout() async {
    print("asdasd");
    await widget.userStore?.clearUserFromCache();
    // ignore: use_build_context_synchronously
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearUser();
    final provider =
        // ignore: use_build_context_synchronously
        Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.transparent, // torna a área transparente clicável
        child: Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            )),
            child: GestureDetector(
              onTap: () {}, // impedir que o clique seja propagado para fora
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      ListTile(
                          leading: Icon(
                            Icons.palette,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: Text('Editar Perfl',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.EDITPROFILE,
                              arguments: {
                                'userStore': widget.userStore,
                              },
                            );
                          }),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        title: Text('Logout',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                        onTap: () {
                          logout();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

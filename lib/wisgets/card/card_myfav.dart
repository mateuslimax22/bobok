import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';

class CardMyFav extends StatefulWidget {
  const CardMyFav(
      {super.key,
      required this.fav,
      required this.userStore,
      required this.myfav,
      required this.attList});

  final Map<String, dynamic> fav;
  final UserStore? userStore;
  final List<dynamic>? myfav;
  final Function() attList;

  @override
  State<CardMyFav> createState() => _CardMyFavState();
}

class _CardMyFavState extends State<CardMyFav> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void removeFav(List<dynamic>? myfav, Map<String, dynamic> fav) async {
    myfav?.removeWhere((item) => item == fav);

    await FirestoreMethods().removeFav(widget.userStore!.user!.uid, fav);
    widget.userStore?.setUser(
      UserData(
          username: widget.userStore!.user!.username,
          uid: widget.userStore!.user!.uid,
          email: widget.userStore!.user!.email,
          avatar: widget.userStore!.user!.avatar,
          followers: widget.userStore!.user!.followers,
          following: widget.userStore!.user!.following,
          blocked: widget.userStore!.user!.blocked,
          blocking: widget.userStore!.user!.blocking,
          myfav: myfav),
    );

    widget.attList();
  }

  void fecharPopupMenu() {
    // Chame hideMenu para fechar o PopupMenu
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double cardSizeWidth = deviceWidth;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: cardSizeWidth * 0.5,
          height: 200,
          child: Stack(
            children: [
              Image.network(
                widget.fav['imageUrl'],
                width: cardSizeWidth * 0.5,
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                width: cardSizeWidth * 0.5,
                height: 200,
                color: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          PopupMenuButton(
                              color: Theme.of(context).colorScheme.onError,
                              child: Container(
                                height: 35,
                                width: 20,
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    child: ListTile(
                                      title: Text(
                                        'Remover',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 15,
                                            letterSpacing: 1.5),
                                      ),
                                      onTap: () {
                                        removeFav(widget.myfav, widget.fav);
                                        fecharPopupMenu();
                                      },
                                    ),
                                  ),
                                ];
                              })
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.fav['title'],
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 15,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

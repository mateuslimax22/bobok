// ignore_for_file: dead_code
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/wisgets/btn/elevated.dart';
import 'package:bobok/wisgets/listCard/List_card_profile.dart';
import 'package:bobok/wisgets/listCard/list_recom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key, required this.uid, required this.currentUid, this.userStore});
  final UserStore? userStore;
  final String? uid;
  final bool? currentUid;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //late UserStore userStore;
  bool isEdit = false;
  List<dynamic>? addFollower = [];
  List<dynamic>? removeFollower = [];

  final user = FirebaseAuth.instance.currentUser!;
  var userData = {};
  String userName = "";
  String avatar = "";
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicialize o userStore no initState
  }

  void onChangedEdit() {
    setState(() {
      isEdit = !isEdit;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.currentUid == false) {
      addFollower = widget.userStore?.user?.following;
      removeFollower = widget.userStore?.user?.following;
      getUserNameReviwer();
    } else {
      getUserName();
    }
  }

  void getUserName() async {
    try {
      setState(() {
        isFollowing = widget.userStore!.user!.followers!.contains(user.uid);
      });
    } catch (e) {
      if (e.toString() == "Null check operator used on a null value") {
        getUserName();
      }
    }
  }

  void getUserNameReviwer() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();

      setState(() {
        followers = userDocument['followers'].length;
        following = userDocument['following'].length;
        isFollowing = userDocument['followers'].contains(user.uid);
        userName = userDocument['username'].toString();
        avatar = userDocument['photoUrl'].toString();
      });
    } catch (e) {
      if (e.toString() == "Null check operator used on a null value") {
        getUserName();
      }
    }
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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: widget.currentUid == false
            ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.primary,
                titleSpacing: 5,
                title: Image.asset('images/logoName.png',
                    width: 138, height: 31, fit: BoxFit.fill),
                actions: [
                    PopupMenuButton<String>(
                        onSelected: menuAppbar,
                        itemBuilder: (BuildContext context) {
                          return {'Logout', 'Settings'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        })
                  ])
            : null,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Avaliadores",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        letterSpacing: 1.5),
                                  ),
                                  Observer(builder: (_) {
                                    return Text(
                                      widget.currentUid != false
                                          ? widget.userStore!.user!.following!
                                              .length
                                              .toString()
                                          : following.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 20,
                                          letterSpacing: 1.5),
                                    );
                                  }),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Leitores",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        letterSpacing: 1.5),
                                  ),
                                  Observer(builder: (_) {
                                    return Text(
                                      widget.currentUid != false
                                          ? widget.userStore!.user!.followers!
                                              .length
                                              .toString()
                                          : followers.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 20,
                                          letterSpacing: 1.5),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 110,
                          width: 110,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(4), // Border width
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                    child: Observer(builder: (_) {
                                      return ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: SizedBox.fromSize(
                                            size: const Size.fromRadius(
                                                48), // Image radius
                                            child: widget.currentUid == false &&
                                                    avatar == ''
                                                ? IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    icon: Icon(
                                                      Icons.person,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      size: 80,
                                                    ),
                                                    onPressed: () {},
                                                  )
                                                : widget.currentUid != false &&
                                                        widget.userStore!.user!
                                                                .avatar
                                                                .toString() ==
                                                            ''
                                                    ? IconButton(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        icon: Icon(
                                                          Icons.person,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          size: 80,
                                                        ),
                                                        onPressed: () {},
                                                      )
                                                    : Image(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          widget.currentUid !=
                                                                  false
                                                              ? widget
                                                                  .userStore!
                                                                  .user!
                                                                  .avatar
                                                                  .toString()
                                                              : avatar
                                                                  .toString(),
                                                          maxHeight: 150,
                                                          maxWidth: 110,
                                                        ))),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              if (isEdit)
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 2.0,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ))
                              else
                                const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.uid == user.uid
                                      ? ElevatedButtonTh(
                                          label: 'Config',
                                          //target: onChangedEdit,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          width: 260,
                                          height: 30,
                                          target: () {
                                            var userData = UserData(
                                                username: 'mateus7', email: '');
                                            widget.userStore?.setUser(userData);
                                          })
                                      : isFollowing
                                          ? ElevatedButtonTh(
                                              label: 'Remover',
                                              target: () async {
                                                await FirestoreMethods()
                                                    .followUser(
                                                        user.uid, widget.uid);

                                                removeFollower?.remove(
                                                    widget.uid.toString());
                                                widget.userStore?.setUser(
                                                  UserData(
                                                      username: widget
                                                          .userStore!
                                                          .user!
                                                          .username,
                                                      uid: widget
                                                          .userStore!.user!.uid,
                                                      email: widget.userStore!
                                                          .user!.email,
                                                      avatar: widget.userStore!
                                                          .user!.avatar,
                                                      followers: widget
                                                          .userStore!
                                                          .user!
                                                          .followers,
                                                      following:
                                                          removeFollower),
                                                );

                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              width: 260,
                                              height: 30,
                                            )
                                          : ElevatedButtonTh(
                                              label: 'Adicionar',
                                              target: () async {
                                                await FirestoreMethods()
                                                    .followUser(
                                                        user.uid, widget.uid);

                                                addFollower?.add(
                                                    widget.uid.toString());
                                                widget.userStore?.setUser(
                                                  UserData(
                                                    username: widget.userStore!
                                                        .user!.username,
                                                    uid: widget
                                                        .userStore!.user!.uid,
                                                    email: widget
                                                        .userStore!.user!.email,
                                                    avatar: widget.userStore!
                                                        .user!.avatar,
                                                    followers: widget.userStore!
                                                        .user!.followers,
                                                    following: addFollower,
                                                  ),
                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              width: 260,
                                              height: 30,
                                            ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
                                      child: Observer(
                                        builder: (_) {
                                          return Text(widget.currentUid != false
                                              ? widget.userStore!.user!.username
                                                  .toString()
                                              : userName);
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Indicações",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      letterSpacing: 1.5),
                                ),
                              ),
                              ListCardRecommendation(
                                  uid: widget.uid, userId: user.uid)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Resenhas",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      letterSpacing: 1.5),
                                ),
                              ),
                              ListCardProfile(
                                  uid: widget.uid, userId: user.uid),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

// ignore_for_file: dead_code
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/pages/settings.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/btn/elevated.dart';
import 'package:bobok/wisgets/modal/modal_block.dart';
import 'package:bobok/wisgets/listCard/List_card_profile.dart';
import 'package:bobok/wisgets/listCard/list_recom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<dynamic>? removeFollowing = [];
  List<dynamic> updatedBlocking = [];
  List<dynamic> listFollowing = [];
  List<dynamic> listFollowers = [];

  final user = FirebaseAuth.instance.currentUser!;
  var userData = {};
  String userName = "";
  String avatar = "";
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isFollowers = false;
  bool isBlocking = false;
  bool isBlocked = false;
  bool isLoading = false;
  bool isModalVisible = false;
  bool isLoadingBtnAdd = false;
  bool isLoadingBtnRmv = false;

  @override
  void initState() {
    super.initState();

    // Inicialize o userStore no initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.currentUid == false) {
      addFollower = widget.userStore?.user?.following;
      removeFollower = widget.userStore?.user?.following;
      removeFollowing = widget.userStore?.user?.followers;
      getUserNameReviwer();
    } else {
      getUserName();
    }
  }

  void block() async {
    // Sempre executar essas ações independentemente das condições.
    if (isFollowing) {
      removeFollow();
    }
    if (isFollowers) {
      removeFollowrs();
    }

    closeModal();
    updatedBlocking.add(widget.uid);
    await FirestoreMethods().blockUser(user.uid, widget.uid);

    setState(() {
      isBlocking = true;
      isEdit = false;
    });

    // Atualiza o usuário uma vez, depois de manipular as condições necessárias.
    widget.userStore?.setUser(
      UserData(
        username: widget.userStore!.user!.username,
        uid: widget.userStore!.user!.uid,
        email: widget.userStore!.user!.email,
        avatar: widget.userStore!.user!.avatar,
        followers:
            isFollowers ? removeFollowing : widget.userStore!.user!.followers,
        following:
            isFollowing ? removeFollower : widget.userStore!.user!.following,
        blocked: widget.userStore!.user!.blocked,
        blocking: updatedBlocking,
        myfav: widget.userStore!.user!.myfav,
      ),
    );
  }

  void unblock() async {
    setState(() {
      isEdit = true;
    });
    updatedBlocking.remove(widget.uid);
    await FirestoreMethods().blockUser(user.uid, widget.uid);
    setState(() {
      isBlocked = false;
      isEdit = false;
    });
    widget.userStore?.setUser(
      UserData(
          username: widget.userStore!.user!.username,
          uid: widget.userStore!.user!.uid,
          email: widget.userStore!.user!.email,
          avatar: widget.userStore!.user!.avatar,
          followers: widget.userStore!.user!.followers,
          following: widget.userStore!.user!.following,
          blocked: widget.userStore!.user!.blocked,
          blocking: updatedBlocking,
          myfav: widget.userStore!.user!.myfav),
    );
  }

  void removeFollowrs() async {
    await FirestoreMethods().followUser(widget.uid, user.uid);

    removeFollowing?.remove(user.uid.toString());
    widget.userStore?.setUser(
      UserData(
          username: widget.userStore!.user!.username,
          uid: widget.userStore!.user!.uid,
          email: widget.userStore!.user!.email,
          avatar: widget.userStore!.user!.avatar,
          followers: removeFollowing,
          following: widget.userStore!.user!.following,
          blocked: widget.userStore!.user!.blocked,
          blocking: widget.userStore!.user!.blocking,
          myfav: widget.userStore!.user!.myfav),
    );
  }

  void removeFollow() async {
    setState(() {
      isLoadingBtnRmv = true;
    });
    await FirestoreMethods().followUser(user.uid, widget.uid);

    removeFollower?.remove(widget.uid.toString());
    widget.userStore?.setUser(
      UserData(
          username: widget.userStore!.user!.username,
          uid: widget.userStore!.user!.uid,
          email: widget.userStore!.user!.email,
          avatar: widget.userStore!.user!.avatar,
          followers: widget.userStore!.user!.followers,
          following: removeFollower,
          blocked: widget.userStore!.user!.blocked,
          blocking: widget.userStore!.user!.blocking,
          myfav: widget.userStore!.user!.myfav),
    );

    setState(() {
      isFollowing = false;
      followers--;
      isLoadingBtnRmv = false;
    });
  }

  void getUserName() async {
    try {
      setState(() {
        isFollowing = widget.userStore!.user!.followers!.contains(user.uid);
        listFollowers = widget.userStore!.user!.followers!;
        listFollowing = widget.userStore!.user!.following!;
      });
    } catch (e) {
      if (e.toString() == "Null check operator used on a null value") {
        getUserName();
      }
    }
  }

  void getUserNameReviwer() async {
    updatedBlocking = widget.userStore!.user!.blocking ?? [];
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();
      setState(() {
        listFollowers = userDocument['followers'];
        listFollowing = userDocument['following'];
        followers = userDocument['followers'].length;
        following = userDocument['following'].length;
        isFollowing = userDocument['followers'].contains(user.uid);
        isBlocking = userDocument['blocking'].contains(user.uid);
        isBlocked = userDocument['blocked'].contains(user.uid);
        isFollowers = userDocument['following'].contains(user.uid);
        userName = userDocument['username'].toString();
        avatar = userDocument['photoUrl'] == null
            ? ''
            : userDocument['photoUrl'].toString();
      });
    } catch (e) {
      if (e.toString() == "Null check operator used on a null value") {
        getUserName();
      }
    }
  }

  void closeModal() {
    setState(() {
      isModalVisible = !isModalVisible;
    });
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
            userStore: widget.userStore,
          );
        },
      );
    }

    Brightness currentBrightness = Theme.of(context).brightness;
    String imagePath = currentBrightness == Brightness.light
        ? 'images/logoLight.png'
        : 'images/logoDark.png';

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: widget.currentUid == false
            ? AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.primary,
                titleSpacing: 5,
                title: Image.asset(imagePath,
                    width: 133, height: 45, fit: BoxFit.fill),
              )
            : null,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                  child: SizedBox(
                    child: Observer(
                      builder: (_) {
                        return Text(
                          widget.currentUid != false
                              ? widget.userStore!.user!.username.toString()
                              : userName,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 1.8),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context).pushNamed(
                                AppRoutes.LISTFRIENDS,
                                arguments: {
                                  'following': true,
                                  'listFollowers': listFollowers,
                                  'listFollowing': listFollowing,
                                  'userStore': widget.userStore
                                },
                              )
                            },
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.reviewers,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
                                              .onPrimary,
                                          fontSize: 20,
                                          letterSpacing: 1.5),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context).pushNamed(
                                AppRoutes.LISTFRIENDS,
                                arguments: {
                                  'following': false,
                                  'listFollowers': listFollowers,
                                  'listFollowing': listFollowing,
                                  'userStore': widget.userStore
                                },
                              )
                            },
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.readers,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
                                              .onPrimary,
                                          fontSize: 20,
                                          letterSpacing: 1.5),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 110,
                                width: 110,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 110,
                                      padding: const EdgeInsets.all(
                                          4), // Border width
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: SizedBox(
                                        child: Observer(builder: (_) {
                                          return ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: SizedBox.fromSize(
                                                size: const Size.fromRadius(
                                                    48), // Image radius
                                                child: widget.currentUid ==
                                                            false &&
                                                        avatar == ''
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
                                                    : widget.currentUid !=
                                                                false &&
                                                            widget
                                                                    .userStore!
                                                                    .user!
                                                                    .avatar
                                                                    .toString() ==
                                                                'null'
                                                        ? IconButton(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            icon: Icon(
                                                              Icons.person,
                                                              color: Theme.of(
                                                                      context)
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
                                                              maxHeight: 140,
                                                              maxWidth: 110,
                                                            ))),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      widget.uid == user.uid
                          ? ElevatedButtonTh(
                              label: AppLocalizations.of(context)!.setting,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              target: () async {
                                openDrawer(context);
                              },
                              width: 120,
                              height: 30,
                              isLoading: false,
                            )
                          : isFollowing
                              ? Column(
                                  children: [
                                    ElevatedButtonTh(
                                      label:
                                          AppLocalizations.of(context)!.remove,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      target: () async {
                                        removeFollow();
                                      },
                                      width: 120,
                                      height: 30,
                                      isLoading: isLoadingBtnRmv,
                                    ),
                                    ElevatedButtonTh(
                                      label:
                                          AppLocalizations.of(context)!.block,
                                      target: () async {
                                        closeModal();
                                      },
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      width: 120,
                                      height: 30,
                                      isLoading: false,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ],
                                )
                              : isBlocked
                                  ? Column(
                                      children: [
                                        ElevatedButtonTh(
                                          label: '-------',
                                          isLoading: isLoadingBtnAdd,
                                          target: () async {},
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          width: 120,
                                          height: 30,
                                        ),
                                        ElevatedButtonTh(
                                          label: AppLocalizations.of(context)!
                                              .unblock,
                                          target: () async {
                                            unblock();
                                          },
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          width: 120,
                                          height: 30,
                                          isLoading: isEdit,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ],
                                    )
                                  : isBlocking
                                      ? Column(
                                          children: [
                                            ElevatedButtonTh(
                                              label: '-------',
                                              isLoading: isLoadingBtnAdd,
                                              target: () async {},
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              width: 120,
                                              height: 30,
                                            ),
                                            ElevatedButtonTh(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .blocked,
                                              target: () async {},
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              width: 120,
                                              height: 30,
                                              isLoading: isEdit,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            ElevatedButtonTh(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .add,
                                              isLoading: isLoadingBtnAdd,
                                              target: () async {
                                                setState(() {
                                                  isLoadingBtnAdd = true;
                                                });
                                                await FirestoreMethods()
                                                    .followUser(
                                                        user.uid, widget.uid);

                                                addFollower?.add(
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
                                                      following: addFollower,
                                                      blocked: widget.userStore!
                                                          .user!.blocked,
                                                      blocking: widget
                                                          .userStore!
                                                          .user!
                                                          .blocking,
                                                      myfav: widget.userStore!
                                                          .user!.myfav),
                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                  isLoadingBtnAdd = false;
                                                });
                                              },
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              width: 120,
                                              height: 30,
                                            ),
                                            ElevatedButtonTh(
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .block,
                                              target: () async {
                                                closeModal();
                                              },
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              width: 120,
                                              height: 30,
                                              isLoading: false,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ],
                                        )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3.0,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.onError),
                    child: Row(
                      children: [
                        BlockConfirmationModal(
                          item: userName.toUpperCase(),
                          onDelete: () {
                            block();
                          },
                          isVisible: isModalVisible,
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_play_rounded,
                                      size: 22,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .indications,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                isBlocking || isBlocked
                                    ? Text(
                                        AppLocalizations.of(context)!.blocked,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                    : ListCardRecommendation(
                                        uid: widget.uid,
                                        userId: user.uid,
                                        userStore: widget.userStore,
                                      )
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.movie_filter,
                                        size: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.reviews,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                isBlocking || isBlocked
                                    ? Text(
                                        AppLocalizations.of(context)!.blocked,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                    : ListCardProfile(
                                        uid: widget.uid,
                                        userId: user.uid,
                                        userStore: widget.userStore,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

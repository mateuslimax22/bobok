import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/pages/profile.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardReview extends StatefulWidget {
  const CardReview(
      {super.key,
      required this.colorback,
      required this.review,
      required this.avatar,
      required this.user,
      required this.reviewUid,
      required this.attList,
      this.userStore});
  final Review review;
  final UserStore? userStore;
  final Color colorback;
  final String? avatar;
  final String? reviewUid;
  final user;
  final Function() attList;

  @override
  State<CardReview> createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReview> {
  bool isLike = false;
  bool isSave = false;
  int countLikes = 0;
  int commentLen = 0;
  List<QueryDocumentSnapshot>? comments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      countLikes = widget.review.likes.length;
    });
    if (widget.review.likes.contains(widget.user.uid)) {
      setState(() {
        isLike = true;
      });
    }
    if (widget.userStore!.user!.myfav!
        .any((map) => map['imageUrl'] == widget.review.imageUrl)) {
      setState(() {
        isSave = true;
      });
    }
  }

  void navigateToReviewDetail(BuildContext context, bool isComment) {
    Navigator.of(context).pushNamed(
      AppRoutes.REVIEW_DETAIL,
      arguments: {
        'review': widget.review.review,
        'title': widget.review.title,
        'postId': widget.review.postId,
        'imageUrl': widget.review.imageUrl,
        'profileImg': widget.review.profileImg,
        'userName': widget.review.username,
        'userUid': widget.user.uid,
        'isComment': isComment,
        'currentUserName': widget.userStore!.user?.username,
        'currentUserPhoto': widget.userStore!.user?.avatar,
      },
    );
  }

  void removeFav(List<dynamic>? myfav, Map<String, dynamic> fav) async {
    myfav?.removeWhere((item) => item['imageUrl'] == fav['imageUrl']);

    await FirestoreMethods().removeFav(widget.userStore!.user!.uid, fav);
  }

  void setFav(Map<String, dynamic> fav) {
    FirestoreMethods().addFav(widget.userStore!.user!.uid, [fav]);
    widget.userStore!.user!.myfav?.add(fav);
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.review.postId)
          .collection('comments')
          .get();

      setState(() {
        comments = snap.docs;
        commentLen = comments!.length;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    void menuAppbar(String value) {
      switch (value) {
        case 'Delete resenha':
          FirestoreMethods().deleteReview(widget.review.postId);
          widget.attList();
          break;
        case 'Colocar na minha lista':
          break;
      }
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      color: widget.colorback,
      child: SizedBox(
        width: deviceWidth,
        height: 320,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(48), // Image radius
                                child: widget.avatar == null
                                    ? IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 25,
                                        ),
                                        onPressed: () {},
                                      )
                                    : Image.network(widget.avatar!,
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                      uid: widget.reviewUid,
                                      currentUid: false,
                                      userStore: widget.userStore,
                                    ),
                                  ),
                                )
                              },
                              child: Text(
                                widget.review.username,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 15,
                                    letterSpacing: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: PopupMenuButton<String>(
                            color: Theme.of(context).colorScheme.background,
                            onSelected: menuAppbar,
                            itemBuilder: (BuildContext context) {
                              if (widget.user.uid == widget.review.uid) {
                                return {'Delete resenha'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 15,
                                          letterSpacing: 1.5),
                                    ),
                                  );
                                }).toList();
                              } else {
                                return {'Colocar na minha lista'}
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 15,
                                          letterSpacing: 1.5),
                                    ),
                                  );
                                }).toList();
                              }
                            })
                        // IconButton(
                        //   color: Theme.of(context).colorScheme.primary,
                        //   iconSize: 20,
                        //   onPressed: () {
                        //     print("sdasd");
                        //   },
                        //   icon: const Icon(
                        //     Icons.more_vert_outlined,
                        //   ),
                        // ),
                        ),
                  ],
                ),
                SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox.fromSize(
                                    child: GestureDetector(
                                      child: Image.network(
                                          widget.review.imageUrl,
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover),
                                      onTap: () {
                                        navigateToReviewDetail(context, false);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: deviceWidth * 0.6,
                                    child: Text(
                                      widget.review.title.toUpperCase(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 14,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Resenha: ".toUpperCase(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 10,
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.6,
                                    height: 100,
                                    child: Row(
                                      crossAxisAlignment:
                                          widget.review.spoiler != true
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: widget.review.spoiler != true
                                              ? Text(
                                                  widget.review.review
                                                      .toUpperCase(),
                                                  maxLines: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                      fontSize: 10,
                                                      letterSpacing: 1.5),
                                                )
                                              : IconButton(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  iconSize: 50,
                                                  onPressed: () {
                                                    print("sdasd");
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .visibility_off_rounded,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      onPressed: () {
                                        navigateToReviewDetail(context, false);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.review.spoiler != true
                                                ? "ver mais.".toUpperCase()
                                                : "A resenha contém spoiler. "
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              color:
                                                  widget.review.spoiler != true
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                              fontSize: 10,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Text(
                                            widget.review.spoiler != true
                                                ? ""
                                                : "Ver mais?".toUpperCase(),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 10,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
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
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: SizedBox(
                        height: 35,
                        width: 25,
                        child: IconButton(
                          icon: Icon(Icons.star_border_rounded,
                              size: 25,
                              color: isLike
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary),
                          tooltip: 'Show Snackbar',
                          onPressed: () async {
                            setState(() {
                              isLike = !isLike;
                            });
                            setState(() {
                              isLike
                                  ? countLikes = ++countLikes
                                  : countLikes = --countLikes;
                            });
                            await FirestoreMethods().likePost(
                                widget.review.postId, widget.user.uid, isLike);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 30,
                        width: 40,
                        child: Text(
                          countLikes.toString(),
                          style: TextStyle(
                              color: isLike
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary),
                        )),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        height: 40,
                        width: 30,
                        child: IconButton(
                          icon: Icon(
                            Icons.messenger_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          tooltip: 'Show Snackbar',
                          onPressed: () {
                            navigateToReviewDetail(context, true);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        height: 40,
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            size: 20,
                            color: isSave
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                          tooltip: 'Show Snackbar',
                          onPressed: () {
                            setState(() {
                              isSave = !isSave;
                            });
                            setState(() {
                              isSave
                                  ? setFav({
                                      "title": widget.review.title,
                                      "category": widget.review.category,
                                      "imageUrl": widget.review.imageUrl
                                    })
                                  : removeFav(widget.userStore!.user!.myfav, {
                                      "title": widget.review.title,
                                      "category": widget.review.category,
                                      "imageUrl": widget.review.imageUrl
                                    });
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      navigateToReviewDetail(context, true);
                    },
                    child: Text(
                      "Ver todos os comentários",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 13,
                          letterSpacing: 1.5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

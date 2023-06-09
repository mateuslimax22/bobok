import 'package:bobok/models/review.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CardReview extends StatefulWidget {
  const CardReview({
    Key? key,
    required this.colorback,
    required this.review,
    required this.avatar,
    required this.user,
  }) : super(key: key);
  final Review review;
  final Color colorback;
  final String? avatar;
  final user;

  @override
  State<CardReview> createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReview> {
  bool isLike = false;
  int countLikes = 0;
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
    setState(() {
      countLikes = widget.review.likes.length;
    });
    if (widget.review.likes.contains(widget.user.uid)) {
      setState(() {
        isLike = true;
      });
    }
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.review.postId)
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void menuAppbar(String value) {
      switch (value) {
        case 'Delete resenha':
          FirestoreMethods().deleteReview(widget.review.postId);
          break;
        case 'Ocutar resenhas desse usuário':
          break;
      }
    }

    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 1,
      color: widget.colorback,
      child: SizedBox(
        width: deviceWidth,
        height: 300,
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
                      padding: const EdgeInsets.only(left: 5),
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
                                              .background,
                                          size: 80,
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
                            child: Text(
                              widget.review.username,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 15,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 40,
                        height: 35,
                        child: PopupMenuButton<String>(
                            onSelected: menuAppbar,
                            itemBuilder: (BuildContext context) {
                              if (widget.user.uid == widget.review.uid) {
                                return {'Delete resenha'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              } else {
                                return {'Ocutar resenhas desse usuário'}
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
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
                  height: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox.fromSize(
                                  child: GestureDetector(
                                    child: Image.network(widget.review.imageUrl,
                                        width: 100,
                                        height: 150,
                                        fit: BoxFit.cover),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.REVIEW_DETAIL,
                                        arguments: {
                                          'review': widget.review.review,
                                          'title': widget.review.title,
                                          'postId': widget.review.postId,
                                          'imageUrl': widget.review.imageUrl,
                                          'profileImg': widget.user.photoURL,
                                          'userName': widget.review.username,
                                          'userUid': widget.user.uid,
                                          'isComment': false
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.review.review.toUpperCase(),
                                            maxLines: 8,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 10,
                                                letterSpacing: 1.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      child: Text(
                                        "ver mais.".toUpperCase(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 10,
                                            letterSpacing: 1.5),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.REVIEW_DETAIL,
                                          arguments: {
                                            'review': widget.review.review,
                                            'title': widget.review.title,
                                            'postId': widget.review.postId,
                                            'imageUrl': widget.review.imageUrl,
                                            'profileImg': widget.user.photoURL,
                                            'userName': widget.review.username,
                                            'userUid': widget.user.uid,
                                            'isComment': false
                                          },
                                        );
                                      },
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
                    SizedBox(
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
                          await FirestoreMethods().likePost(
                              widget.review.postId,
                              widget.user.uid,
                              widget.review.likes);

                          setState(() {
                            countLikes = widget.review.likes.length;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                        height: 40,
                        width: 10,
                        child: Text(
                          countLikes.toString(),
                          style: TextStyle(
                              color: isLike
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary),
                        )),
                    SizedBox(
                      height: 40,
                      width: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.messenger_outline,
                          size: 20,
                        ),
                        tooltip: 'Show Snackbar',
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.REVIEW_DETAIL,
                            arguments: {
                              'review': widget.review.review,
                              'postId': widget.review.postId,
                              'title': widget.review.title,
                              'imageUrl': widget.review.imageUrl,
                              'profileImg': widget.user.photoURL,
                              'userName': widget.review.username,
                              'userUid': widget.user.uid,
                              'isComment': true
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.share,
                          size: 20,
                        ),
                        tooltip: 'Show Snackbar',
                        onPressed: () {
                          print("sdasd");
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.REVIEW_DETAIL,
                        arguments: {
                          'review': widget.review.review,
                          'postId': widget.review.postId,
                          'title': widget.review.title,
                          'imageUrl': widget.review.imageUrl,
                          'profileImg': widget.user.photoURL,
                          'userName': widget.review.username,
                          'userUid': widget.user.uid,
                          'isComment': true
                        },
                      );
                    },
                    child: Text(
                      "Ver todos os $commentLen comentários",
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

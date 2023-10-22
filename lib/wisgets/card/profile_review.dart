import 'package:bobok/models/review.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileReview extends StatefulWidget {
  const ProfileReview({
    Key? key,
    required this.itemReview,
    required this.userId,
    required this.uid,
  }) : super(key: key);

  final Review itemReview;
  final String? userId;
  final String? uid;

  @override
  State<ProfileReview> createState() => _ProfileReviewState();
}

class _ProfileReviewState extends State<ProfileReview> {
  Future<void> _submitForm() async {
    try {
      String res =
          await FirestoreMethods().addFavorite(widget.itemReview.postId);
      if (res != "Review adicionada aos favoritos!") {
        // ignore: use_build_context_synchronously
        showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Ocorreu um erro!"),
                  content:
                      const Text("Não foi possivel adicionar sua indicação ;("),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"))
                  ],
                ));
      }
    } catch (e) {
      showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Ocorreu um erro!"),
                content:
                    const Text("Não foi possivel adicionar sua indicação ;("),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.REVIEW_DETAIL,
          arguments: {
            'review': widget.itemReview.review,
            'title': widget.itemReview.title,
            'postId': widget.itemReview.postId,
            'imageUrl': widget.itemReview.imageUrl,
            'profileImg': widget.itemReview.profileImg,
            'userName': widget.itemReview.username,
            'userUid': widget.userId,
            'isComment': false
          },
        );
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            Image.network(
              widget.itemReview.imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Container(
              width: 200,
              height: 200,
              color: Colors.black.withOpacity(0.7),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            widget.itemReview.username,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: 14,
                                letterSpacing: 1.5),
                          ),
                        ),
                        widget.uid == widget.userId
                            ? PopupMenuButton(
                                child: Container(
                                  height: 35,
                                  width: 20,
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                            'Adicionar aos Favoritos'),
                                        onTap: () {
                                          _submitForm();
                                        },
                                      ),
                                    ),
                                  ];
                                })
                            : const Spacer()
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.itemReview.title,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
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
    );
  }
}

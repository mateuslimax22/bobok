import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';

class CardFavorite extends StatefulWidget {
  const CardFavorite(
      {Key? key,
      required this.itemReview,
      required this.userId,
      required this.uid,
      required this.userStore})
      : super(key: key);

  final Review itemReview;
  final String? userId;
  final String? uid;
  final UserStore? userStore;

  @override
  State<CardFavorite> createState() => _CardFavoriteState();
}

class _CardFavoriteState extends State<CardFavorite> {
  Future<void> _submitForm() async {
    try {
      String res = await FirestoreMethods()
          .removeFromFavorites(widget.itemReview.postId);
      if (res != "Favorito removido com sucesso!") {
        // ignore: use_build_context_synchronously
        showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Ocorreu um erro!"),
                  content:
                      const Text("Não foi possivel remover sua indicação ;("),
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
                    const Text("Não foi possivel remover sua indicação ;("),
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
    Widget listCard = GestureDetector(
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
            'isComment': false,
            'currentUserName': widget.userStore!.user?.username,
            'currentUserPhoto': widget.userStore!.user?.avatar,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
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
                color: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.itemReview.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
    return widget.uid == widget.userId
        ? Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Deseja remover esta indicação?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Remover'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                _submitForm();
              }
            },
            child: listCard)
        : listCard;
  }
}

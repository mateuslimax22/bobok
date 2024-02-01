import 'package:bobok/models/review.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardTop5 extends StatefulWidget {
  const CardTop5({
    Key? key,
    required this.itemReview,
    required this.userId,
    required this.uid,
  }) : super(key: key);

  final Review itemReview;
  final String? userId;
  final String? uid;

  @override
  State<CardTop5> createState() => _CardTop5State();
}

class _CardTop5State extends State<CardTop5> {
  late UserProvider _userProvider;
  UserData? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
    currentUser = _userProvider.user;
  }

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
  }

  @override
  Widget build(BuildContext context) {
    double cardSizeWidth = deviceWidth;
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
            'isComment': false,
            'currentUserName': currentUser?.username,
            'currentUserPhoto': currentUser?.avatar,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: cardSizeWidth * 0.5,
          height: 200,
          child: Stack(
            children: [
              Image.network(
                widget.itemReview.imageUrl,
                width: cardSizeWidth * 0.5,
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                width: cardSizeWidth * 0.5,
                height: 200,
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: cardSizeWidth * 0.3,
                        child: Text(
                          widget.itemReview.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                              letterSpacing: 1.5),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.itemReview.title,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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

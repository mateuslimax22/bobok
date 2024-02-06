import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileReview extends StatefulWidget {
  const ProfileReview(
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
  State<ProfileReview> createState() => _ProfileReviewState();
}

class _ProfileReviewState extends State<ProfileReview> {
  late UserProvider _userProvider;
  UserData? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
    currentUser = _userProvider.user;
  }

  void fecharPopupMenu() {
    // Chame hideMenu para fechar o PopupMenu
    Navigator.of(context).pop();
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
            'currentUserName': widget.userStore!.user?.username,
            'currentUserPhoto': widget.userStore!.user?.avatar,
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
                color: Colors.black.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: cardSizeWidth * 0.2,
                            child: Text(
                              widget.itemReview.username,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 14,
                                  letterSpacing: 1.5),
                            ),
                          ),
                          widget.uid == widget.userId
                              ? PopupMenuButton(
                                  color: Theme.of(context).colorScheme.onError,
                                  child: Container(
                                    height: 35,
                                    width: 20,
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            'Adicionar aos Indicados',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                          ),
                                          onTap: () {
                                            _submitForm();
                                            fecharPopupMenu();
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

import 'package:bobok/models/review.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardMyFav extends StatefulWidget {
  const CardMyFav({
    Key? key,
    required this.fav,
  }) : super(key: key);

  final Map<String, dynamic> fav;

  @override
  State<CardMyFav> createState() => _CardMyFavState();
}

class _CardMyFavState extends State<CardMyFav> {
  late UserProvider _userProvider;
  UserData? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
    currentUser = _userProvider.user;
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
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.fav['title'],
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

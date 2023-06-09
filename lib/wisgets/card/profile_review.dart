import 'package:bobok/models/review.dart';
import 'package:flutter/material.dart';

class ProfileReview extends StatelessWidget {
  const ProfileReview({
    Key? key,
    required this.itemReview,
  }) : super(key: key);
  final Review itemReview;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      color: Theme.of(context).colorScheme.onBackground,
      child: GridTile(
          child: Image.network(itemReview.imageUrl,
              cacheHeight: 150, cacheWidth: 110, fit: BoxFit.cover)),
    );
  }
}

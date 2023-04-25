import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/cardReview.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final List<Review> loadReviews = dummyReviws;

  ListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: loadReviews.length,
          itemBuilder: (context, index) {
            Review review = loadReviews[index];
            return CardReview(
              colorback: review.spoiler == true
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              listReview: review,
            );
          },
        )
      ],
    );
  }
}

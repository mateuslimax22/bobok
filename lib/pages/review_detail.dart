import 'package:bobok/models/review.dart';
import 'package:flutter/material.dart';

class ReviewDetail extends StatelessWidget {
  const ReviewDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Review review = ModalRoute.of(context)!.settings.arguments as Review;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          review.title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(review.imageUrl), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.85),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20))),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: dead_code

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _World();
}

class _World extends State<World> {
  @override
  Widget build(BuildContext context) {
    final List<Review> loadedReviewUser = dummyReviws;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            children: [
                              const Text("Indicações"),
                              Expanded(
                                child: SizedBox(
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: loadedReviewUser.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: (2.8 / 4),
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 2),
                                      itemBuilder: (ctx, i) => ProfileReview(
                                          itemReview: loadedReviewUser[i])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              const Text("Resenhas"),
                              Expanded(
                                child: SizedBox(
                                    child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('reviews')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return const Text('Error');
                                    }

                                    final reviews = snapshot.data!.docs
                                        .map((doc) => Review.fromSnap(doc))
                                        .toList();

                                    return Expanded(
                                      child: SizedBox(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: reviews.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: (2.8 / 4),
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 2,
                                          ),
                                          itemBuilder: (ctx, i) {
                                            return ProfileReview(
                                                itemReview: reviews[i]);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )),
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
        ));
  }
}

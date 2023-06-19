import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final List<Review> loadReviews = dummyReviws;

  ListCard({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .orderBy("datePublish", descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Review review = Review.fromSnap(snapshot.data!.docs[index]);
            return CardReview(
              colorback: review.spoiler == true
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              review: review,
              avatar: review.profileImg,
              user: user,
            );
          },
        );
      },
    );
  }
}

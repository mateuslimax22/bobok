import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCardTop5 extends StatefulWidget {
  const ListCardTop5({super.key, required this.uid, required this.userId});
  final String? uid;
  final String? userId;

  @override
  State<ListCardTop5> createState() => _ListCardTop5State();
}

class _ListCardTop5State extends State<ListCardTop5> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text('Error');
        }

        final reviews =
            snapshot.data!.docs.map((doc) => Review.fromSnap(doc)).toList();

        // Ordenar as revisões com base na contagem de likes
        reviews.sort((a, b) => b.likes.length.compareTo(a.likes.length));

        // Pegar as 5 primeiras revisões
        final top5Reviews = reviews.take(5).toList();

        return Expanded(
          child: SizedBox(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: top5Reviews.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (2.8 / 4),
                crossAxisCount: 1,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (ctx, i) {
                return ProfileReview(
                  itemReview: top5Reviews[i],
                  userId: widget.userId,
                  uid: widget.uid,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

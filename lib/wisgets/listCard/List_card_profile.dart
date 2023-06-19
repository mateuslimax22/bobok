import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListCardProfile extends StatefulWidget {
  const ListCardProfile({super.key});

  @override
  State<ListCardProfile> createState() => _ListCardProfileState();
}

class _ListCardProfileState extends State<ListCardProfile> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
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

        return Expanded(
          child: SizedBox(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: reviews.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (2.8 / 4),
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (ctx, i) {
                return ProfileReview(itemReview: reviews[i]);
              },
            ),
          ),
        );
      },
    );
  }
}

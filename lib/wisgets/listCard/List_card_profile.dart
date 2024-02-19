import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:bobok/wisgets/btn/elevated.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCardProfile extends StatefulWidget {
  const ListCardProfile(
      {super.key,
      required this.uid,
      required this.userId,
      required this.userStore});
  final String? uid;
  final String? userId;
  final UserStore? userStore;

  @override
  State<ListCardProfile> createState() => _ListCardProfileState();
}

class _ListCardProfileState extends State<ListCardProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('uid', isEqualTo: widget.uid)
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
            child: reviews.isEmpty
                ? Column(
                    children: [
                      ElevatedButtonTh(
                        label: 'Add Resenha',
                        target: () {
                          Navigator.of(context).pushNamed(AppRoutes.ADD_REVIEW);
                        },
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        width: 200,
                        height: 45,
                        progress: false,
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (2.8 / 4),
                        crossAxisCount: 2,
                        crossAxisSpacing: 7,
                        mainAxisSpacing: 7,
                      ),
                      itemBuilder: (ctx, i) {
                        return ProfileReview(
                          itemReview: reviews[i],
                          userId: widget.userId,
                          uid: widget.uid,
                          userStore: widget.userStore,
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}

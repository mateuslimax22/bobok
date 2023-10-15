import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String? reviewId;

  Favorite({required this.reviewId});

  static Favorite fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Favorite(
      reviewId: snapshot['reviewId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
    };
  }
}

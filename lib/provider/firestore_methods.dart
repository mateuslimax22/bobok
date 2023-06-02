import 'package:bobok/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //save review
  Future<String> uploadReview(
      String imageUrl,
      String userName,
      String title,
      String review,
      bool spoiler,
      String category,
      List<String> genresSelect) async {
    String res = "Some error occured";
    try {
      Reference fileRef =
          _storage.ref().child("reviews").child(_auth.currentUser!.uid);

      String id = const Uuid().v1();
      fileRef = fileRef.child(id);

      await fileRef.putString(imageUrl, format: PutStringFormat.dataUrl);

      String postId = const Uuid().v1();
      final newReview = Review(
        uid: _auth.currentUser!.uid,
        username: userName,
        title: title,
        review: review,
        imageUrl: imageUrl,
        postId: postId,
        likes: [],
        datePublish: DateTime.now(),
        spoiler: spoiler,
        category: category,
        genres: genresSelect,
      );
      _firestore.collection('reviews').doc(postId).set(newReview.toJson());

      res = "sucess";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

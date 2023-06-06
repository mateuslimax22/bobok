import 'package:bobok/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

      var response = await http.get(Uri.parse(imageUrl));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = File(join(documentDirectory.path, 'imagetest.png'));
      file.writeAsBytesSync(response.bodyBytes);

      await fileRef.putFile(file);
      String fileUrl = await fileRef.getDownloadURL();

      String postId = const Uuid().v1();
      final newReview = Review(
        uid: _auth.currentUser!.uid,
        username: userName,
        title: title,
        review: review,
        imageUrl: fileUrl,
        profileImg: _auth.currentUser!.photoURL!,
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

  Future<void> likePost(String? postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('reviews').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('reviews').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postid, String text, String uid, String name,
      String profileImg) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('reviews')
            .doc(postid)
            .collection('comments')
            .doc(commentId)
            .set({
          'profileImg': profileImg,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:bobok/models/review.dart';
import 'package:bobok/models/user.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bobok/models/favorite.dart';

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

  Future<String> addFavorite(String? reviewId) async {
    try {
      Favorite favorite = Favorite(reviewId: reviewId);
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc(reviewId)
          .set(favorite.toJson());
      return "Review adicionada aos favoritos!";
    } catch (e) {
      return "Erro ao adicionar aos favoritos: $e";
    }
  }

  Future<String> removeFromFavorites(String? reviewId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc(reviewId)
          .delete();
      return 'Favorito removido com sucesso!';
    } catch (e) {
      return 'Erro ao remover favorito: $e';
    }
  }

  Future<void> likePost(String? postId, String uid, bool likes) async {
    try {
      if (!likes) {
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

  Future<void> addListPdf(String files, int? pdfs) async {
    try {
      String pdfsId = const Uuid().v1();
      _storage.ref().child("pdfs").child(_auth.currentUser!.uid);
      await _firestore.collection('pdfs').doc(pdfsId).set({
        'pdfsId': pdfsId,
        'uid': _auth.currentUser!.uid,
        'listPdf': [files]
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePdf(String? pdfId) async {
    try {
      await _firestore.collection('pdfs').doc(pdfId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteReview(String? postId) async {
    try {
      await _firestore.collection('reviews').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot document =
        await _firestore.collection('users').doc(currentUser.uid).get();

    var currentData = (document.data()! as dynamic);

    return currentData;
  }

  Future<void> getUserDataFromFirestore(BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDocument.exists) {
      UserData user = UserData(
        username: userDocument['username'],
        uid: userDocument['uid'],
        email: userDocument['email'],
        followers: List<String>.from(userDocument['followers']),
        following: List<String>.from(userDocument['following']),
        myfav: List<Map<String, dynamic>>.from(userDocument['myfav']),
        avatar: userDocument['photoUrl'],
      );

      // ignore: use_build_context_synchronously
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
  }

  Future<void> addFav(String? uid, List<dynamic>? myfav) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List myfavCheck = (snap.data()! as dynamic)['myfav'];

      if (myfavCheck.contains(myfav) != true) {
        await _firestore.collection('users').doc(uid).update({
          'myfav': FieldValue.arrayUnion([myfav![0]])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeFav(String? uid, Map<String, dynamic>? myfav) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'myfav': FieldValue.arrayRemove([myfav])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String? followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();

      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

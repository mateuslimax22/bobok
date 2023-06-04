import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? uid;
  final String? postId;
  final String username;
  final String title;
  final String review;
  final datePublish;
  final String imageUrl;
  final String? profileImg;
  final likes;
  final bool spoiler;
  final String category;
  final genres;

  Review({
    this.uid,
    required this.username,
    required this.title,
    required this.review,
    required this.imageUrl,
    this.profileImg,
    this.datePublish,
    this.postId,
    required this.likes,
    required this.spoiler,
    required this.category,
    required this.genres,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "title": title,
        "review": review,
        "imageUrl": imageUrl,
        "profileImg": profileImg,
        "postId": postId,
        "likes": [],
        "datePublish": datePublish,
        "spoiler": spoiler,
        "category": category,
        "genres": genres,
      };

  static Review fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Review(
        uid: snapshot['uid'],
        username: snapshot['username'],
        title: snapshot['title'],
        review: snapshot['review'],
        imageUrl: snapshot['imageUrl'],
        profileImg: snapshot['profileImg'],
        postId: snapshot['postId'],
        likes: snapshot['likes'],
        datePublish: ['datePublish'],
        spoiler: snapshot['spoiler'],
        category: snapshot['category'],
        genres: snapshot['genres']);
  }
}

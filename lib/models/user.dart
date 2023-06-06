import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? uid;
  final String? avatar;
  final String? username;
  final String? email;
  final List? followers;
  final List? following;

  UserData({
    this.uid,
    this.avatar,
    required this.username,
    required this.email,
    this.followers,
    this.following,
  });

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      avatar: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatar": avatar,
        "followers": followers,
        "following": following,
      };
}

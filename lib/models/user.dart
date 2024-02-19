import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? uid;
  final String? avatar;
  final String? username;
  final String? email;
  final List? followers;
  final List? following;
  final List<dynamic>? myfav;

  UserData(
      {this.uid,
      this.avatar,
      required this.username,
      required this.email,
      this.followers,
      this.following,
      this.myfav});

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      avatar: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      myfav: snapshot["myfav"],
    );
  }

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'],
      uid: map['uid'],
      email: map['email'],
      avatar: map['photoUrl'],
      followers: List<dynamic>.from(map['followers']),
      following: List<dynamic>.from(map['following']),
      myfav: List<dynamic>.from(map['myfav']),
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatar": avatar,
        "followers": followers,
        "following": following,
        "myfav": myfav
      };
}

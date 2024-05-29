import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? uid;
  final String? avatar;
  final String? username;
  final String? email;
  final List? followers;
  final List? following;
  final List? blocked;
  final List? blocking;
  final List<dynamic>? myfav;
  final int? ads;

  UserData(
      {this.uid,
      this.avatar,
      required this.username,
      required this.email,
      this.followers,
      this.following,
      this.blocked,
      this.blocking,
      this.myfav,
      this.ads});

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      avatar: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      blocked: snapshot["blocked"],
      blocking: snapshot["blocking"],
      myfav: snapshot["myfav"],
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      uid: json['uid'],
      email: json['email'],
      avatar: json['avatar'],
      followers: List<dynamic>.from(json['followers']),
      following: List<dynamic>.from(json['following']),
      blocked:
          json['blocked'] != null ? List<dynamic>.from(json['blocked']) : [],
      blocking:
          json['blocking'] != null ? List<dynamic>.from(json['blocking']) : [],
      myfav: json['myfav'] != null ? List<dynamic>.from(json['myfav']) : [],
    );
  }

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'],
      uid: map['uid'],
      email: map['email'],
      avatar: map['avatar'],
      followers: List<dynamic>.from(map['followers']),
      following: List<dynamic>.from(map['following']),
      blocked: map['blocked'] != null ? List<dynamic>.from(map['blocked']) : [],
      blocking:
          map['blocking'] != null ? List<dynamic>.from(map['blocking']) : [],
      myfav: map['myfav'] != null ? List<dynamic>.from(map['myfav']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatar": avatar,
        "followers": followers,
        "following": following,
        "blocked": blocked,
        "blocking": blocking,
        "myfav": myfav
      };
}

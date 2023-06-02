class UserData {
  final String? uid;
  final String? avatar;
  final String? username;
  final String? email;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;

  UserData({
    this.uid,
    this.avatar,
    required this.username,
    required this.email,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
  });
}

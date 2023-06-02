class Review {
  final String? uid;
  final String? postId;
  final String username;
  final String title;
  final String review;
  final datePublish;
  final String imageUrl;
  final likes;
  final bool spoiler;
  final String category;

  final List<String> genres;

  Review({
    this.uid,
    required this.username,
    required this.title,
    required this.review,
    required this.imageUrl,
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
        "postId": postId,
        "likes": [],
        "datePublish": datePublish,
        "spoiler": spoiler,
        "category": category,
        "genres": genres,
      };
}

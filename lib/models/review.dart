class Review {
  final String id;
  final String username;
  final String title;
  final String review;
  final String imageUrl;
  final String likes;
  final bool spoiler;
  final String category;

  Review({
    required this.id,
    required this.username,
    required this.title,
    required this.review,
    required this.imageUrl,
    required this.likes,
    required this.spoiler,
    required this.category,
  });
}

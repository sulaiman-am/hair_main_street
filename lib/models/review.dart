class Review {
  final String user;
  final String comment;
  final int stars;

  Review(this.user, this.comment, this.stars);
}

List<Review> reviews = [
  Review('User1', 'Great product!', 5),
  Review('User2', 'Good product, but could be better.', 4),
  Review('User3', 'Not satisfied with the quality.', 2),

  // Add more reviews as needed
];

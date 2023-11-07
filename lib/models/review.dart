import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? reviewID;
  String? user;
  final String? comment;
  final double? stars;
  dynamic createdAt;

  Review({this.user, this.comment, this.stars, this.createdAt, this.reviewID});
}

List<Review> reviews = [
  Review(
      user: 'User1',
      comment: 'Great product!',
      stars: 5,
      createdAt: FieldValue.serverTimestamp()),
  Review(
      user: 'User2',
      comment: 'Good product, but could be better.',
      stars: 4,
      createdAt: FieldValue.serverTimestamp()),
  Review(
      user: 'User3',
      comment: 'Not satisfied with the quality.',
      stars: 2,
      createdAt: FieldValue.serverTimestamp()),

  // Add more reviews as needed
];

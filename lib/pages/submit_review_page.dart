import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:material_symbols_icons/symbols.dart';

class SubmitReviewPage extends StatefulWidget {
  String? productID;
  SubmitReviewPage({this.productID, Key? key}) : super(key: key);

  @override
  _SubmitReviewPageState createState() => _SubmitReviewPageState();
}

class _SubmitReviewPageState extends State<SubmitReviewPage> {
  UserController userController = Get.find<UserController>();
  ReviewController reviewController = Get.find<ReviewController>();
  final _formKey = GlobalKey<FormState>();
  Review review = Review(comment: "", stars: 0.0);
  String displa = '';
  String comment = '';
  double _rating = 0.0;
  List selectedImages = List.filled(3, null);
  TextEditingController displayNameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  void _selectImage(int index) async {
    reviewController.selectImage();
    // You can implement image selection logic here
    // For example, you can use image_picker package
    // For simplicity, we'll just use placeholder URLs
    // String? imageUrl = "https://via.placeholder.com/150";
    // setState(() {
    //   selectedImages[index] = imageUrl;
    // });
  }

  // Function to remove an image
  void _removeImage(int index) {
    // setState(() {
    //   selectedImages[index] = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Write a Review',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        //alignment: Alignment.center,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Display Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: displayNameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your display name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        review.displayName = value!;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Comment",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Type Comment Here",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                      minLines: 5,
                      maxLines: 10,
                      onSaved: (value) {
                        review.comment = value!;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Image",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        3,
                        (index) => GestureDetector(
                          onTap: () => _selectImage(index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.black, width: 0.8),
                            ),
                            child: selectedImages[index] != null
                                ? Stack(
                                    children: [
                                      Image.network(selectedImages[index]!),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: const Icon(Icons.close,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Icon(Icons.add, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rate this product',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                // Assuming you're using a package like flutter_rating_bar to display star ratings

                RatingBar.builder(
                  itemSize: 56,
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5, // Set to 6 for a "0 to 5 stars" rating system
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      review.stars = rating;
                    });
                  },
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        //review.productID = widget.productID;
                        review.userID = userController.userState.value!.uid!;
                        await reviewController.addAReview(
                            review, widget.productID!);
                        // Here you can handle the submission of the review
                        // For example, you can send the review to Firestore
                        // and then navigate back to the previous screen
                        //Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Submit Review',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

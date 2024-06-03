import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReviewPage extends StatelessWidget {
  final List<Review>? reviews;

  ReviewPage(this.reviews);

  @override
  Widget build(BuildContext context) {
    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime

      // Add days to the DateTime
      //DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

      return dateTime;
    }

    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Gradient appBarGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 200, 242, 237),
        Color.fromARGB(255, 255, 224, 139),
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'User Reviews',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        //decoration: BoxDecoration(gradient: myGradient),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: reviews!.length,
              itemBuilder: (context, index) {
                return ReviewCard(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ClientReviewPage extends StatefulWidget {
  ClientReviewPage({super.key});

  @override
  State<ClientReviewPage> createState() => _ClientReviewPageState();
}

class _ClientReviewPageState extends State<ClientReviewPage> {
  ReviewController reviewController = Get.find<ReviewController>();
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    reviewController.getMyReviews(userController.userState.value!.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Reviews",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: DataBaseService()
              .getUserReviews(userController.userState.value!.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return reviewController.myReviews.isEmpty
                  ? BlankPage(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      // buttonStyle: ElevatedButton.styleFrom(
                      //   backgroundColor: Color(0xFF392F5A),
                      //   shape: RoundedRectangleBorder(
                      //     side: const BorderSide(
                      //       width: 1.2,
                      //       color: Colors.black,
                      //     ),
                      //     borderRadius: BorderRadius.circular(16),
                      //   ),
                      // ),
                      pageIcon: const Icon(
                        Icons.do_disturb_alt_rounded,
                        size: 48,
                      ),
                      text: "You Current Have Not Reviewed Any Products",
                      // interactionText: "Add Products",
                      // interactionIcon: const Icon(
                      //   Icons.person_2_outlined,
                      //   size: 24,
                      //   color: Colors.white,
                      // ),
                      // interactionFunction: () =>
                      //     Get.to(() => AddproductPage()),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shrinkWrap: true,
                      itemCount: reviewController.myReviews.length,
                      itemBuilder: (context, index) => ClientReviewCard(
                        index: index,
                      ),
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class EditReviewPage extends StatefulWidget {
  final String? reviewID;
  final String? productID;
  const EditReviewPage({this.productID, this.reviewID, super.key});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  UserController userController = Get.find<UserController>();
  ReviewController reviewController = Get.find<ReviewController>();
  TextEditingController commentController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Review review = Review(comment: "", stars: 0.0);
  double _rating = 0.0;
  List<File?>? selectedImages = [];

  @override
  void initState() {
    super.initState();
    review = reviewController.getSingleReview(widget.reviewID!)!;
    _rating = review.stars;
  }

  @override
  Widget build(BuildContext context) {
    //print(review.displayName);
    void _selectImage(int index) async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImages![index] = File(pickedFile.path);
        });
      }
    }

    void _removeImage(int index) {
      setState(() {
        selectedImages![index] = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Edit Your Review',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                    TextInputWidget(
                      labelText: "Display Name",
                      controller: displayNameController,
                      initialValue: review.displayName ?? "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your display name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          review.displayName = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      labelText: "Comment",
                      controller: commentController,
                      initialValue: review.comment,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                      minLines: 5,
                      maxLines: 10,
                      onChanged: (value) {
                        setState(() {
                          review.comment = value!;
                        });
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
                            child: selectedImages!.isNotEmpty &&
                                    selectedImages![index] != null
                                ? Stack(
                                    children: [
                                      Image.file(selectedImages![index]!),
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
                        reviewController.isLoading.value = true;
                        _formKey.currentState!.save();
                        if (selectedImages!.isNotEmpty) {
                          await reviewController.uploadImage(selectedImages!);
                          print("doing this");
                        }
                        if (reviewController.downloadUrls.isNotEmpty) {
                          print("now this");
                          review.reviewImages =
                              reviewController.downloadUrls.value;
                        }
                        if (reviewController.isLoading.value == true) {
                          Get.dialog(const LoadingWidget(),
                              barrierDismissible: false);
                        }
                        review.userID = userController.userState.value!.uid!;
                        review.reviewID = widget.reviewID;
                        review.productID = widget.productID;
                        print("hello");
                        await reviewController.editReview(review);
                        //review.productID = widget.productID;
                      }
                    },
                    child: const Text(
                      'Edit Review',
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
      backgroundColor: Colors.white,
    );
  }
}

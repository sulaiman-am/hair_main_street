import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
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

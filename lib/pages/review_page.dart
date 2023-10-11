import 'package:flutter/material.dart';
import 'package:hair_main_street/models/review.dart';

class ReviewPage extends StatelessWidget {
  final List<Review> reviews;

  ReviewPage(this.reviews);

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: const Text(
          'User Reviews',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: appBarGradient),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: myGradient),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('User: ${reviews[index].user}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comment: ${reviews[index].comment}'),
                  Row(
                    children: List.generate(
                      reviews[index].stars,
                      (index) => Icon(Icons.star,
                          color: const Color.fromARGB(255, 213, 201, 90)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237),
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
    CarouselController carouselController = CarouselController();
    return Scaffold(
      appBar: AppBar(
        // bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(screenHeight * 0.04),
        //     child: Form(child: child)),
        title: const Text(
          'Hair Main Street',
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

        //backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(gradient: myGradient),
        child: ListView(
          //shrinkWrap: true,
          children: [
            HeaderText(text: "Explore"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   //color: Color(0xFFF4D06F),
                //   onPressed: () => carouselController.previousPage(
                //     duration: const Duration(milliseconds: 200),
                //     curve: Curves.easeIn,
                //   ),
                //   icon: Icon(
                //     Icons.arrow_back_ios_new_rounded,
                //     size: 20,
                //     color: Colors.black,
                //   ),
                // ),
                Container(
                  width: screenWidth * 0.90,
                  child: CarouselSlider(
                    items: [
                      Container(
                        color: Colors.black,
                      ),
                      Container(
                        color: Colors.amber,
                      ),
                      Container(
                        color: Colors.blue,
                      ),
                    ],
                    carouselController: carouselController,
                    options: CarouselOptions(
                      enlargeFactor: 0.1,
                      height: screenHeight * 0.30,
                      autoPlay: true,
                      pauseAutoPlayOnManualNavigate: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.70,
                    ),
                  ),
                ),
                // IconButton(
                //   //color: Colors.white,
                //   onPressed: () => carouselController.nextPage(
                //     duration: const Duration(milliseconds: 200),
                //     curve: Curves.easeIn,
                //   ),
                //   icon: Icon(
                //     Icons.arrow_forward_ios_rounded,
                //     size: 20,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            HeaderText(text: "Products"),
            SizedBox(
              height: 4,
            ),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: screenHeight * 0.295,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              itemBuilder: (_, index) => ProductCard(),
              itemCount: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String? text;
  const HeaderText({
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}

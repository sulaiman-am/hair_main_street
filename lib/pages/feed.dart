import 'package:flutter/material.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    InfiniteScrollController controller = InfiniteScrollController();
    Gradient myGradient = const LinearGradient(
      colors: [Color(0xFFF4D06F), Color(0xFF9DD9D2)],
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
          'Hair Main Street',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(
              0xFFFF8811,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(gradient: myGradient),
        child: ListView(
          //shrinkWrap: true,
          children: [
            Container(
              height: 200,
              child: InfiniteCarousel.builder(
                controller: controller,
                itemCount: 4,
                itemExtent: 250,
                loop: true,
                anchor: 4,
                onIndexChanged: (index) {
                  setState(() {
                    controller.jumpToItem(index);
                  });
                },
                itemBuilder: (context, itemIndex, realIndex) => CarouselCard(),
              ),
            ),
            HeaderText(text: "Explore"),
            SizedBox(
              height: 4,
            ),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 28,
              ),
              itemBuilder: (_, index) => ProductCard(),
              itemCount: 10,
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

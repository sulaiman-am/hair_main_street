import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

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
        Color.fromARGB(255, 255, 224, 139)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Text? referralText = Text(
      "https://hairmainstreet/referral/w7621581762817/",
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      maxLines: 3,
      overflow: TextOverflow.clip,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Referral',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0E4D92),
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        //backgroundColor: Colors.transparent,
      ),
      body: Container(
        //decoration: BoxDecoration(gradient: myGradient),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 32),
          children: [
            HeaderText(
              text: "Invite Your Friends",
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurStyle: BlurStyle.normal,
                    offset: Offset.fromDirection(-4.0),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                "On Hair Main Street, you get 10% earnings by using your referral link to invite your friends",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            HeaderText(
              text: "Referral Link",
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurStyle: BlurStyle.normal,
                    offset: Offset.fromDirection(-4.0),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: referralText,
                    flex: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF392F5A),
                        padding: EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            width: 1.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () {
                        FlutterClipboard.copy(referralText.data!);
                        Get.snackbar(
                          "Link Copied",
                          "Successful",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 1, milliseconds: 400),
                          forwardAnimationCurve: Curves.decelerate,
                          reverseAnimationCurve: Curves.easeOut,
                          backgroundColor: Color.fromARGB(255, 200, 242, 237),
                          margin: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: screenHeight * 0.16,
                          ),
                        );
                      },
                      child: Text(
                        "Copy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            HeaderText(
              text: "Statistics",
            ),
            SizedBox(
              height: 4,
            ),
            ReferralCard(
              title: "Referrals",
              text: "200",
            ),
            SizedBox(
              height: 8,
            ),
            ReferralCard(
              title: "Earnings",
              text: "2000NGN",
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
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

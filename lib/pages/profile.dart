import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Profile',
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
      body: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        decoration: BoxDecoration(gradient: myGradient),
        child: ListView(
          padding: EdgeInsets.only(top: 8),
          children: [
            Center(
              child: Stack(
                //alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurStyle: BlurStyle.normal,
                          offset: Offset.fromDirection(-4.0),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: screenWidth * 0.28,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF392F5A),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ProfileLabel(
              hintText: "${userController.myUser.value.fullname}",
              isVisible: true,
              labelText: "Full Name",
            ),
            const SizedBox(
              height: 8,
            ),
            ProfileLabel(
              hintText: "${userController.myUser.value.address}",
              isVisible: true,
              labelText: "Address",
            ),
            const SizedBox(
              height: 8,
            ),
            ProfileLabel(
              hintText: "${userController.myUser.value.email}",
              isVisible: true,
              labelText: "Email",
            ),
            const SizedBox(
              height: 8,
            ),
            ProfileLabel(
              hintText: "${userController.myUser.value.phoneNumber}",
              isVisible: true,
              labelText: "Phone Number",
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.only(right: screenWidth * .32),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  //alignment: Alignment.centerLeft,
                  backgroundColor: Color(0xFF392F5A),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Symbols.edit_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        //margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        decoration: BoxDecoration(color: Color(0xFF9DD9D2)),
        child: SafeArea(
          child: TextButton(
            style: TextButton.styleFrom(
              //alignment: Alignment.centerLeft,
              backgroundColor: Colors.red[400],
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            onPressed: () {
              userController.signOut();
              Get.offAll(() => HomePage());
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileLabel extends StatelessWidget {
  final String? hintText, labelText;
  final bool? isVisible;
  final Function? onPressed;
  const ProfileLabel(
      {this.hintText,
      this.isVisible,
      this.labelText,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText == null ? "label" : labelText!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Visibility(
              visible: isVisible ?? true,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF392F5A),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    )),
                onPressed: onPressed == null ? () {} : onPressed!(),
                icon: const Icon(
                  Symbols.edit_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  "edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: screenWidth * 0.99,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000),
                blurStyle: BlurStyle.normal,
                offset: Offset.fromDirection(-4.0),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            hintText == null ? "hint" : hintText!,
            style: const TextStyle(
              color: Colors.black26,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}

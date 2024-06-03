import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:string_validator/string_validator.dart' as validator;

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  GlobalKey<FormState>? formKey = GlobalKey();

  TextEditingController? emailController = TextEditingController();
  String email = "";
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          'Forgotten Password',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: const Text.rich(
                  TextSpan(
                    text:
                        "You can request a password reset below. We will send a security code to the email address, make sure it is correct",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      leadingDistribution: TextLeadingDistribution.proportional,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextInputWidget(
                      textInputType: TextInputType.emailAddress,
                      controller: emailController,
                      labelText: "Email address",
                      hintText: "user@example.com",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter an email address";
                        } else if (!validator.isEmail(val)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        if (val!.isNotEmpty) {
                          emailController!.text = val;
                          email = emailController!.text;
                        } else {}
                      },
                    ),
                    SizedBox(
                      height: screenHeight * .02,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              bool? validate =
                                  formKey!.currentState!.validate();
                              if (validate) {
                                formKey!.currentState!.save();
                                print(email);
                              }
                            },
                            style: TextButton.styleFrom(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: screenWidth * 0.24),
                              backgroundColor: Colors.black,
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Reset",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

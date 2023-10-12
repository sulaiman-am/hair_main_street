// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/forgotten_password.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/pages/menu.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;

class SignInUpPage extends StatefulWidget {
  const SignInUpPage({super.key});

  @override
  State<SignInUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInUpPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  UserController userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  GlobalKey<FormState> formKey = GlobalKey();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    dismissKeyBoard() {
      FocusScope.of(context).requestFocus(FocusNode());
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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();
    return GestureDetector(
      onTap: dismissKeyBoard,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Sign Up/In',
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
          bottom: TabBar(
            controller: tabController,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            indicator: BoxDecoration(
              color: Color(0xFF392F5A),
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: Colors.black,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Sign Up",
                  // style: TextStyle(
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.w600,
                  //   color: Colors.white,
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Sign In",
                ),
              ),
            ],
            //indicatorColor: Colors.white,
          ),
          //backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(top: 20, left: 12, right: 12),
                height: screenHeight * 1,
                decoration: BoxDecoration(gradient: myGradient),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    // Sign up screen
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "hello@gmail.com",
                          validator: (val) {
                            if (!validator.isEmail(val!)) {
                              return "Enter a valid Email";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value!;
                            });
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<UserController>(builder: (controller) {
                          return TextInputWidget(
                            controller: passwordController,
                            obscureText: controller.isObscure.value,
                            visibilityIcon: IconButton(
                              onPressed: () => controller.toggle(),
                              icon: controller.isObscure.value
                                  ? Icon(
                                      Icons.visibility_off_rounded,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.visibility_rounded,
                                      size: 20,
                                    ),
                            ),
                            labelText: "Password",
                            hintText:
                                "Password must be at least 6 characters long",
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter Password";
                              } else if (val.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value!;
                                //return null;
                              });
                              return null;
                            },
                          );
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        TextInputWidget(
                          controller: confirmpasswordController,
                          obscureText: true,
                          labelText: "Confirm Password",
                          //hintText: "Password must be at least 6 characters long",
                          validator: (value) {
                            debugPrint(password);
                            debugPrint(email);
                            if (value != password) {
                              return "Password does not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            bool validated = formKey.currentState!.validate();
                            if (validated) {
                              formKey.currentState!.save();
                              userController.isLoading.value = true;
                              userController.createUser(email, password);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF392F5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                tabController.animateTo(1);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    //signIn Screen
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextInputWidget(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "hello@gmail.com",
                          validator: (val) {
                            if (!validator.isEmail(val!)) {
                              return "Enter a valid Email";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value!;
                            });
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<UserController>(builder: (controller) {
                          return TextInputWidget(
                            controller: passwordController,
                            labelText: "Password",
                            obscureText: controller.isObscure.value,
                            visibilityIcon: IconButton(
                              onPressed: () => controller.toggle(),
                              icon: controller.isObscure.value
                                  ? Icon(
                                      Icons.visibility_off_rounded,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.visibility_rounded,
                                      size: 20,
                                    ),
                            ),
                            hintText:
                                "Password must be at least 6 characters long",
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter Password";
                              } else if (val.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value!;
                              });
                              return null;
                            },
                          );
                        }),
                        SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(() => ForgottenPassword());
                              },
                              child: Text(
                                "Forgotten Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextButton(
                          onPressed: () {
                            bool validated = formKey.currentState!.validate();
                            if (validated) {
                              userController.isLoading.value = true;
                              //debugPrint("${userController.isLoading.value}");
                              formKey.currentState!.save();
                              //debugPrint(email!);
                              userController.signIn(email, password);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF392F5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont Have an Account?",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                tabController.animateTo(0);
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => userController.isLoading.isFalse
                              ? SizedBox.shrink()
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF392F5A),
                                    strokeWidth: 4,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

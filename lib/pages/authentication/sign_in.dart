import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/referralController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/authentication/create_account.dart';
import 'package:hair_main_street/pages/authentication/forgotten_password.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:string_validator/string_validator.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:colorful_iconify_flutter/icons/logos.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = Get.find<UserController>();
  ReferralController referralController = Get.find<ReferralController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  String? email, password;
  dismissKeyBoard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;
    var screenHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            return Get.back();
          },
          color: const Color(0xFF292D32),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back to ",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Hair Main Street",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Color(0xFF673AB7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 12,
                ),
                TextInputWidget(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "Enter email address",
                  fontSize: 15,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GetX<UserController>(builder: (controller) {
                  return TextInputWidget(
                      controller: passwordController,
                      obscureText: controller.isObscure.value,
                      fontSize: 15,
                      visibilityIcon: IconButton(
                        onPressed: () => controller.toggle(),
                        icon: controller.isObscure.value
                            ? const Icon(
                                Icons.visibility_off_rounded,
                                size: 20,
                              )
                            : const Icon(
                                Icons.visibility_rounded,
                                size: 20,
                              ),
                      ),
                      labelText: "Password",
                      hintText: "Enter password",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }

                        // Check if password length is greater than 6
                        if (!isLength(value, 6)) {
                          return 'Password must be at least 6 characters long';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value!;
                          //return null;
                        });
                      });
                }),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ForgottenPassword());
                      },
                      child: const Text(
                        "Forgotten Password?",
                        style: TextStyle(
                          color: Color(0xFF673AB7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      bool validated = formKey.currentState!.validate();
                      if (validated) {
                        formKey.currentState!.save();
                        userController.isLoading.value = true;
                        if (userController.isLoading.isTrue) {
                          Get.dialog(const LoadingWidget(),
                              barrierDismissible: false);
                        }

                        formKey.currentState!.save();

                        await userController.signIn(email, password);
                      }
                    },
                    // style: TextButton.styleFrom(
                    //   padding: EdgeInsets.all(10),
                    //   backgroundColor: Colors.black,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Or Sign in with",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: screenWidth * 0.85,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor:
                          const Color(0xFF673AB7).withOpacity(0.10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Iconify(
                          Logos.apple,
                          size: 24,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Sign in with Apple",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: screenWidth * 0.85,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor:
                          const Color(0xFF673AB7).withOpacity(0.10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Iconify(
                          Logos.google_icon,
                          size: 24,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dont have an account yet? ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const CreateAccountPage());
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF673AB7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

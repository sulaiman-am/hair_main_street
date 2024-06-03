import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/referralController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/pages/authentication/sign_in.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:string_validator/string_validator.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';

class CreateAccountPage extends StatefulWidget {
  final String? referralCode;
  const CreateAccountPage({this.referralCode, super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  UserController userController = Get.find<UserController>();
  ReferralController referralController = Get.find<ReferralController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isChecked = false;
  String? email, password;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dismissKeyBoard() {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    var screenWidth = Get.width;

    return GestureDetector(
      onTap: dismissKeyBoard(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              return Get.back();
            },
            color: const Color(0xFF292D32),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

                        // Check if password contains at least one uppercase letter
                        if (!validator.isUppercase(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }

                        // Check if password contains at least one lowercase letter
                        if (!validator.isLowercase(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }

                        // Check if password contains at least one digit
                        if (!validator.isNumeric(value)) {
                          return 'Password must contain at least one digit';
                        }

                        // Check if password contains at least one special character
                        if (!validator.isIn(value, [
                          r'!',
                          r'@',
                          r'#',
                          r'$',
                          r'%',
                          r'^',
                          r'&',
                          r'*',
                          r'(',
                          r')',
                          r'-',
                          r'_',
                          r'+',
                          r'=',
                          r'{',
                          r'}',
                          r'[',
                          r']',
                          r'|',
                          r'\',
                          r';',
                          r':',
                          r'<',
                          r'>',
                          r',',
                          r'.',
                          r'?',
                          r'/'
                        ])) {
                          return 'Password must contain at least one special character';
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
                  height: 20,
                ),
                GetX<UserController>(builder: (controller) {
                  return TextInputWidget(
                    controller: confirmPasswordController,
                    fontSize: 15,
                    obscureText: true,
                    labelText: "Confirm Password",
                    hintText: "Confirm password",
                    visibilityIcon: IconButton(
                      onPressed: () => controller.toggle1(),
                      icon: controller.isObscure1.value
                          ? const Icon(
                              Icons.visibility_off_rounded,
                              size: 20,
                            )
                          : const Icon(
                              Icons.visibility_rounded,
                              size: 20,
                            ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    //hintText: "Password must be at least 6 characters long",
                    validator: (value) {
                      if (value != password) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                FormField(
                  initialValue: isChecked,
                  builder: (FormFieldState<dynamic> state) => Row(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          activeColor: const Color(0xFF673AB7),
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          }),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Creating an account means you agree to the ',
                            style: const TextStyle(
                              wordSpacing: 2,
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style:
                                    const TextStyle(color: Color(0xFF673AB7)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Terms & Conditions tap
                                    print('Terms & Conditions Tapped');
                                    // You can navigate to another screen or open a web page here
                                  },
                              ),
                              const TextSpan(
                                text: ' and our ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style:
                                    const TextStyle(color: Color(0xFF673AB7)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Privacy Policy tap
                                    print('Privacy Policy Tapped');
                                    // You can navigate to another screen or open a web page here
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  validator: (value) {
                    setState(() {
                      value = isChecked;
                    });
                    if (value == false) {
                      return "You have to agree to proceed";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool validated = formKey.currentState!.validate();
                      if (validated) {
                        formKey.currentState!.save();
                        userController.isLoading.value = true;
                        if (userController.isLoading.isTrue) {
                          Get.dialog(const LoadingWidget(),
                              barrierDismissible: false);
                        }
                        var usercreation =
                            await userController.createUser(email, password);
                        if (usercreation == "success" &&
                            widget.referralCode != null) {
                          referralController.handleReferrals(
                              widget.referralCode!,
                              userController.myUser.value.uid!);
                        }
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
                      "Sign Up",
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
                          "Or Sign up with",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
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
                          "Sign up with Apple",
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
                          "Sign up with Google",
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
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignIn());
                      },
                      child: const Text(
                        "Sign In",
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

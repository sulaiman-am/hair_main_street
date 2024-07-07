import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:string_validator/string_validator.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  GlobalKey<FormState>? formKey = GlobalKey();
  UserController userController = Get.find<UserController>();

  TextEditingController? emailController = TextEditingController();
  TextEditingController? codeController = TextEditingController();
  TextEditingController? newPasswordController = TextEditingController();
  bool codeReceived = false;
  String email = "";
  String? code;
  String? newPassword;

  bool hasUppercaseLetter(String value) {
    RegExp regex = RegExp(r'[A-Z]');
    return regex.hasMatch(value);
  }

  bool hasLowercaseLetter(String value) {
    RegExp regex = RegExp(r'[a-z]');
    return regex.hasMatch(value);
  }

  bool hasNumber(String value) {
    RegExp regex = RegExp(r'[0-9]');
    return regex.hasMatch(value);
  }

  bool hasSpecialCharacters(String value) {
    // Define a regular expression for common special characters
    final regexp = RegExp(r'[!@#$%^&*(),.?\":{}|<>]');
    return regexp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Symbols.arrow_back_ios_new_rounded,
            size: 24,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Forgotten Password',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
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
                  color: const Color(0xFFf5f5f5),
                ),
                child: const Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                    text:
                        "Request a password by first entering the email used to create your account in textbox provided.",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w500,
                      leadingDistribution: TextLeadingDistribution.proportional,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: codeReceived == true,
                child: const Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                    text:
                        "Enter the code you received in your email into the code box below and reset your password.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      leadingDistribution: TextLeadingDistribution.proportional,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hintText: "Enter the email you used to sign in",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter an email address";
                        } else if (!validator.isEmail(val)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          if (val!.isNotEmpty) {
                            emailController!.text = val;
                            email = emailController!.text;
                          } else {}
                        });
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Visibility(
                      visible: codeReceived == true,
                      child: Column(
                        children: [
                          TextInputWidget(
                            labelText: "New Password",
                            textInputType: TextInputType.text,
                            controller: newPasswordController,
                            hintText: "Enter your new password",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty';
                              }

                              // Check if password length is greater than 6
                              if (!isLength(value, 6)) {
                                return 'Password must be at least 6 characters long';
                              }

                              // Check if password contains at least one uppercase letter
                              if (hasUppercaseLetter(value) == false) {
                                return 'Password must contain at least one uppercase letter';
                              }

                              // Check if password contains at least one lowercase letter
                              if (!hasLowercaseLetter(value)) {
                                return 'Password must contain at least one lowercase letter';
                              }

                              // Check if password contains at least one digit
                              if (!hasNumber(value)) {
                                return 'Password must contain at least one digit';
                              }

                              // Check if password contains at least one special character
                              if (!hasSpecialCharacters(value)) {
                                return 'Password must contain at least one special character\n!@#\$%^&*(),.?\\":{}|<>';
                              }

                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                if (val!.isNotEmpty) {
                                  newPasswordController!.text = val;
                                  newPassword = newPasswordController!.text;
                                }
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextInputWidgetWithoutLabel(
                            textInputType: TextInputType.number,
                            controller: codeController,
                            hintText: "Enter the code from your email",
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter the code sent to your email";
                              } else if (!validator.isAlphanumeric(val)) {
                                return "Please enter a valid code";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                if (val!.isNotEmpty) {
                                  codeController!.text = val;
                                  code = codeController!.text;
                                } else {}
                              });
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              bool? validate =
                                  formKey!.currentState!.validate();
                              if (validate) {
                                userController.isLoading.value = true;
                                if (userController.isLoading.isTrue) {
                                  Get.dialog(const LoadingWidget());
                                }
                                formKey!.currentState!.save();
                                if (codeReceived == false) {
                                  String result = await userController
                                      .sendResetPasswordEmail(email);
                                  if (result == 'success') {
                                    //codeReceived = true;
                                    Get.back();
                                  }
                                } else {
                                  String result = await userController
                                      .passwordReset(newPassword!, code!);
                                  if (result == 'success') {
                                    Get.back();
                                  }
                                }
                                print(email);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: const Color(0xFF673AB7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Reset Password",
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

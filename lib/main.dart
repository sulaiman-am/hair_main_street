import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/notificationController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/services/notification.dart';
import 'package:hair_main_street/splash_screen.dart';

import 'extras/colors.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().init();
  //await FirebaseMessaging.instance.getInitialMessage();
  Get.put(UserController());
  Get.lazyPut<NotificationController>(() => NotificationController());
  //Get.put(VendorController());
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.fadeIn,
      debugShowCheckedModeBanner: false,
      title: 'Hair Main Street',
      theme: ThemeData(
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.grey[100]),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Color(0xFF0E4D92),
            ),
            backgroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white)),
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Be Vietnam Pro',
        primarySwatch: primary,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

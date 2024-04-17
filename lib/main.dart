import 'dart:async';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hair_main_street/controllers/cartController.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/notificationController.dart';
import 'package:hair_main_street/controllers/referralController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/pages/authentication/authentication.dart';
import 'package:hair_main_street/pages/homePage.dart';
import 'package:hair_main_street/pages/menu/orders.dart';
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
  Get.put<ChatController>(ChatController());
  //Get.put(ReferralController());
  //Get.put(VendorController());
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  String referralCode = "";

  @override
  void initState() {
    handleAppLinks();
    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  handleAppLinks() async {
    _appLinks = AppLinks();

    if (!Foundation.kDebugMode) {
      // Check initial link if app was in cold state (terminated)
      final appLink = await _appLinks.getInitialAppLink();
      if (appLink != null) {
        // print('getInitialAppLink: $appLink');
        // print(appLink.queryParameters);

        if (appLink.path.contains('/register')) {
          setState(() {
            var val = appLink.queryParameters["referralCode"] ?? "";
            referralCode = val.toString();
          });
          Get.toNamed("/register");
        }
      }
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      // print('onAppLink: $uri');
      // print(uri.queryParameters);

      if (uri.path.contains('/register')) {
        setState(() {
          var val = uri.queryParameters["referralCode"] ?? "";
          referralCode = val.toString();
          //print("referral code: $referralCode");
        });
        Get.toNamed("/register");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("referral code: $referralCode");
    // var applink = AppLinks();
    // applink.allUriLinkStream.listen((Uri? uri) {
    //   print("Recieved app link: $uri");
    //   if (uri != null && uri.pathSegments.isNotEmpty) {
    //     // Extract the referral code from the URI and navigate to the signup page
    //     referralCode = uri.pathSegments.last;
    //     print(referralCode);
    //     if (referralCode.isNotEmpty) {
    //       Get.toNamed('/register?referralCode=$referralCode');
    //     }
    //   }
    // });
    return GetMaterialApp(
      initialRoute: "/",
      defaultTransition: Transition.fadeIn,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: "/orders", page: () => OrdersPage()),
        GetPage(
          name: '/register',
          parameters: {"referralCode": referralCode},
          page: () => SignInUpPage(
            referralCode: referralCode,
          ),
        ),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Hair Main Street',
      theme: ThemeData(
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.grey[100]),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.black,
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

// final router = GoRouter(routes: [
//   GoRoute(
//     path: "/",
//     name: "home",
//     builder: ((context, state) => const SplashScreen()),
//   ),
//   GoRoute(
//     path: "/register/:referralcode",
//     name: "sign up",
//     builder: ((context, state) => const SignInUpPage()),
//   ),
// ]);

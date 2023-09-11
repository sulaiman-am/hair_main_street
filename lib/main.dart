import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/pages/homePage.dart';

import 'extras/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hair Main Street',
      theme: ThemeData(
        fontFamily: 'Irish Grover',
        primarySwatch: primary,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

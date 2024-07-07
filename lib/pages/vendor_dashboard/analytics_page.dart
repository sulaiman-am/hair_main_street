import 'package:flutter/material.dart';
import 'package:hair_main_street/blankPage.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlankPage(
        text: "This page is under construction",
        haveAppBar: true,
        appBarText: "Analytics Page",
        pageIcon: const Icon(
          Icons.construction_rounded,
          color: Color(0xFF673AB7),
          size: 40,
        ),
      ),
    );
  }
}

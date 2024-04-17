import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/review_controller.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatController chatController = Get.find<ChatController>();
  UserController userController = Get.find<UserController>();
  Map vendorMap = {};

  @override
  void initState() {
    chatController.getUserChats(userController.userState.value!.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<DatabaseChatResponse> sortedList = [];
    // for (var element in chatController.myChats) {
    //   var sortedChats = element!.messages!
    //     ..sort((a, b) {
    //       // Convert timestamps to comparable values
    //       final timestampA = a.timestamp;
    //       final timestampB = b.timestamp;
    //       return timestampA.compareTo(timestampB);
    //     });
    // }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Chats",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: DataBaseService()
              .getUserChats(userController.userState.value!.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //print("hello");
              if (chatController.myChats.isEmpty) {
                return BlankPage(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  // buttonStyle: ElevatedButton.styleFrom(
                  //   backgroundColor: Color(0xFF392F5A),
                  //   shape: RoundedRectangleBorder(
                  //     side: const BorderSide(
                  //       width: 1.2,
                  //       color: Colors.black,
                  //     ),
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  // ),
                  pageIcon: const Icon(
                    Icons.do_disturb_alt_rounded,
                    size: 48,
                  ),
                  text: "You Have No Chats",
                  // interactionText: "Add Products",
                  // interactionIcon: const Icon(
                  //   Icons.person_2_outlined,
                  //   size: 24,
                  //   color: Colors.white,
                  // ),
                  // interactionFunction: () =>
                  //     Get.to(() => AddproductPage()),
                );
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shrinkWrap: true,
                    itemCount: chatController.myChats.length,
                    itemBuilder: (context, index) {
                      userController.getVendorDetails(
                          chatController.myChats[index]!.member2!);
                      return ChatsCard(
                        index: index,
                        vendorDetails: userController.vendorDetails.value,
                      );
                    });
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

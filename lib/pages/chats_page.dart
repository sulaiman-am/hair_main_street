import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

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

  //check which member the person is
  String? whoToDisplay(int index) {
    String? currentUserUid = userController.userState.value!.uid!;
    if (currentUserUid == chatController.myChats[index]!.member1) {
      return chatController.myChats[index]!.member2;
    } else if (currentUserUid == chatController.myChats[index]!.member2) {
      return chatController.myChats[index]!.member1;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // String? currentUserUid = userController.userState.value!.uid!;
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
            "Chats",
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w700,
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
                  textTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                  ),
                  text: "No Chats Yet",
                );
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    itemCount: chatController.myChats.length,
                    itemBuilder: (context, index) {
                      String? nameToDisplay = "";
                      Future<Map<String, MessagePageData>>
                          someFunction() async {
                        MessagePageData member1 =
                            await chatController.resolveNameToDisplay(
                                chatController.myChats[index]!.member1!);
                        MessagePageData member2 =
                            await chatController.resolveNameToDisplay(
                                chatController.myChats[index]!.member2!);

                        return {"member1": member1, "member2": member2};
                      }

                      return FutureBuilder(
                        future: someFunction(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("Loading...");
                          } else {
                            return ChatsCard(
                              index: index,
                              nameToDisplay: nameToDisplay,
                              member1: snapshot.data?["member1"] ??
                                  MessagePageData(),
                              member2: snapshot.data?["member2"] ??
                                  MessagePageData(),
                            );
                          }
                        },
                      );
                    });
              }
            } else {
              return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}

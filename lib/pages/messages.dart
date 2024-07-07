import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:hair_main_street/widgets/text_input.dart';

class MessagesPage extends StatefulWidget {
  final String? senderID;
  final String? receiverID;
  const MessagesPage({this.receiverID, this.senderID, super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final ScrollController scrollController = ScrollController();
  ChatController chatController = Get.find<ChatController>();

  UserController userController = Get.find<UserController>();
  MessagePageData? data;

  @override
  void initState() {
    super.initState();
    resolveMessageData(widget.receiverID);
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   if (scrollController.hasClients) {
    //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
    //   }
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatController.getMessages(widget.senderID!, widget.receiverID!);
    super.dispose();
  }

  void resolveMessageData(id) async {
    data = await chatController.resolveNameToDisplay(id);
  }

  void scrollToEnd() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    Chat chat = Chat(member1: "", member2: "");
    ChatMessages chatMessages = ChatMessages(idTo: "", idFrom: "", content: "");

    return FutureBuilder(
        future: chatController.resolveNameToDisplay(widget.receiverID!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: LoadingWidget(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 40,
              centerTitle: false,
              scrolledUnderElevation: 0,
              elevation: 0,
              title: Text(
                data!.name ?? "Message",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              color: const Color(0xFF673AB7).withOpacity(0.05),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: DataBaseService()
                            .getChats(widget.senderID!, widget.receiverID!),
                        builder: (context, snapshot) {
                          //print(snapshot.data);
                          if (snapshot.hasData) {
                            return GetX<ChatController>(
                              builder: (controller) {
                                return controller.messagesList.value!.isEmpty
                                    ? const Text(
                                        "No Messages Yet",
                                        style: TextStyle(
                                          fontSize: 40,
                                        ),
                                      )
                                    : ListView.builder(
                                        reverse: true,
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 12, 12, 8),
                                        //physics: const NeverScrollableScrollPhysics(),
                                        itemCount: controller
                                            .messagesList.value!.length,
                                        itemBuilder: (context, index) {
                                          //scrollToEnd();
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 4),
                                            child: ChatMessage(
                                                message: controller.messagesList
                                                    .value![index]!),
                                          );
                                        },
                                      );
                              },
                            );
                          } else {
                            return const Center(
                              heightFactor: 2,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          }
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(6, 8, 8, 8),
                    child: Form(
                      key: formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextInputWidgetWithoutLabel(
                              controller: messageController,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                              ),
                              hintText: "Type your message",
                              onChanged: (val) {
                                chatController.isButtonEnabled.value =
                                    val!.trim().isNotEmpty;
                                messageController.text = val;
                                return null;
                              },
                              textInputType: TextInputType.multiline,
                              maxLines: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => IconButton(
                                style: IconButton.styleFrom(
                                  disabledBackgroundColor:
                                      const Color(0xFF673AB7),
                                  backgroundColor: const Color(0xFF673AB7),
                                  shape: const CircleBorder(),
                                ),
                                onPressed: chatController.isButtonEnabled.value
                                    ? () {
                                        chatMessages.idFrom = widget.senderID;
                                        chatMessages.idTo = widget.receiverID;
                                        chat.member1 = widget.senderID;
                                        chat.member2 = widget.receiverID;
                                        chat.recentMessageSentBy =
                                            widget.senderID;
                                        chatMessages.content =
                                            messageController.text;
                                        chat.recentMessageText =
                                            messageController.text;
                                        chatController.startChat(
                                            chat, chatMessages);
                                        debugPrint(
                                            "hellow:${messageController.text}");

                                        messageController.clear();
                                        formKey.currentState!.reset();
                                        scrollToEnd();
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // bottomNavigationBar: SafeArea(
            //   child: BottomAppBar(
            //     child: Form(
            //       key: formKey,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Expanded(
            //             //flex: 6,
            //             child: TextInputWidgetWithoutLabel(
            //               hintText: "Message",
            //               onChanged: (val) {
            //                 messageController.text = val!;
            //               },
            //               textInputType: TextInputType.text,
            //             ),
            //           ),
            //           IconButton(
            //             style: IconButton.styleFrom(
            //               shape: const CircleBorder(
            //                 side: BorderSide(
            //                   color: Colors.white,
            //                   width: 1.2,
            //                 ),
            //               ),
            //             ),
            //             onPressed: () {
            //               formKey.currentState!.save();
            //               debugPrint(messageController.text);
            //             },
            //             icon: const Icon(
            //               Icons.send_rounded,
            //               color: Colors.white,
            //               size: 28,
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          );
        });
  }
}

class ChatMessage extends StatefulWidget {
  final ChatMessages message;

  ChatMessage({
    required this.message,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  UserController userController = Get.find<UserController>();
  ChatController chatController = Get.find<ChatController>();
  Future? myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = chatController.resolveTheNames(widget.message);
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = Get.width;
    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      final timestampDateTime = timestamp.toDate();

      return DateTime(
        0,
        0,
        0,
        timestampDateTime.hour,
        timestampDateTime.minute,
        timestampDateTime.second,
      );
    }

    return GetX<ChatController>(builder: (controller) {
      bool isUsertheSender =
          widget.message.idFrom == userController.userState.value!.uid;
      return Align(
        alignment:
            isUsertheSender ? Alignment.centerRight : Alignment.centerLeft,
        child: isUsertheSender
            ? Row(
                mainAxisAlignment: isUsertheSender
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF673AB7),
                    ),
                    child: Text(
                      widget.message.content!,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FutureBuilder(
                      future: chatController
                          .resolveNameToDisplay(widget.message.idFrom!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const CircleAvatar(
                            radius: 18,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return snapshot.data!.imageUrl == null ||
                                  snapshot.data!.imageUrl!.isEmpty
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF703535),
                                  child: SvgPicture.asset(
                                    "assets/Icons/user.svg",
                                    color: Colors.white,
                                    height: 24,
                                    width: 24,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.imageUrl!,
                                  ),
                                );
                        }
                      }),
                ],
              )
            : Row(
                mainAxisAlignment: isUsertheSender
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: chatController
                          .resolveNameToDisplay(widget.message.idTo!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const CircleAvatar(
                            radius: 18,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return snapshot.data!.imageUrl == null ||
                                  snapshot.data!.imageUrl!.isEmpty
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF703535),
                                  child: SvgPicture.asset(
                                    "assets/Icons/user.svg",
                                    color: Colors.white,
                                    height: 24,
                                    width: 24,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.imageUrl!,
                                  ),
                                );
                        }
                      }),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black38,
                      ),
                    ),
                    child: Text(
                      widget.message.content!,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

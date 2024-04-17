import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/chatController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/text_input.dart';

class MessagesPage extends StatelessWidget {
  String? senderID;
  String? receiverID;
  MessagesPage({this.receiverID, this.senderID, super.key});

  ChatController chatController = Get.find<ChatController>();
  UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    chatController.getMessages(senderID!, receiverID!);
    // chatController.member1UID.value = senderID!;
    // chatController.member2UID.value = receiverID!;
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController messageController = TextEditingController();
    Chat chat = Chat(member1: "", member2: "");
    ChatMessages chatMessages = ChatMessages(idTo: "", idFrom: "", content: "");
    // bool isButtonEnabled = chatController.isButtonEnabled.value;
    // List<Message> messages = [
    //   Message(sender: 'John', text: 'Hello, how are you?'),
    //   Message(sender: 'You', text: 'I\'m good, thanks!'),
    //   // Add more messages here
    // ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
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
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: StreamBuilder(
                stream: DataBaseService().getChats(senderID!, receiverID!),
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
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                //physics: const NeverScrollableScrollPhysics(),
                                //shrinkWrap: true,
                                itemCount:
                                    controller.messagesList.value!.length,
                                itemBuilder: (context, index) {
                                  userController.getBuyerDetails(controller
                                      .messagesList.value![index]!.idFrom!);
                                  userController.getVendorDetails(controller
                                      .messagesList.value![index]!.idTo!);
                                  return ChatMessage(
                                      message: controller
                                          .messagesList.value![index]!);
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
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              //color: Color(0xFF0E4D92),
              child: Form(
                key: formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextInputWidgetWithoutLabel(
                        controller: messageController,
                        hintText: "Message",
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
                            disabledBackgroundColor: Color(0xFF0E4D92),
                            backgroundColor: Color(0xFF0E4D92),
                            shape: const CircleBorder(
                                // side: BorderSide(
                                //   color: Colors.white,
                                //   width: 2.8,
                                // ),
                                ),
                          ),
                          onPressed: chatController.isButtonEnabled.value
                              ? () {
                                  formKey.currentState!.save();
                                  chatMessages.idFrom = senderID;
                                  chatMessages.idTo = receiverID;
                                  chat.member1 = senderID;
                                  chat.member2 = receiverID;
                                  chat.recentMessageSentBy = senderID;
                                  chatMessages.content = messageController.text;
                                  chat.recentMessageText =
                                      messageController.text;
                                  chatController.startChat(chat, chatMessages);
                                  debugPrint(
                                      "hellow:${messageController.text}");

                                  messageController.clear();
                                  formKey.currentState!.reset();
                                }
                              : null,
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 33,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
  // var buyerDetails;

  // getUserDetails() async {
  //   buyerDetails = await userController.getUserDetails(widget.message.idFrom!);
  // }

  // @override
  // void initState() {
  //   getUserDetails();
  //   userController.getVendorDetails(widget.message.idTo!);
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    num screenWidth = Get.width;
    DateTime resolveTimestampWithoutAdding(Timestamp timestamp) {
      final timestampDateTime = timestamp.toDate();

      // Return only the time component (hour, minute, second)
      return DateTime(
        0, // Year
        0, // Month
        0, // Day
        timestampDateTime.hour,
        timestampDateTime.minute,
        timestampDateTime.second,
      );
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black,
              //     blurStyle: BlurStyle.normal,
              //     offset: Offset.fromDirection(-4.0),
              //     blurRadius: 0.5,
              //   ),
              // ],
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundColor: Colors.black,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: widget.message.idFrom ==
                              userController.buyerDetails.value!.uid
                          ? Text(
                              userController.buyerDetails.value!.fullname!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              userController.vendorDetails.value!.shopName!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    Text(
                      "${resolveTimestampWithoutAdding(widget.message.timestamp!).toString().split(" ")[1]}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.message.content ?? "hello",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.star_half_rounded,
                //       color: Colors.yellow[700],
                //     ),
                //     Text(
                //       "${review.stars}",
                //       style: const TextStyle(fontSize: 14),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

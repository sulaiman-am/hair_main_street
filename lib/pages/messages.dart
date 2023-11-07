import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/widgets/text_input.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    TextEditingController messageController = TextEditingController();
    List<Message> messages = [
      Message(sender: 'John', text: 'Hello, how are you?'),
      Message(sender: 'You', text: 'I\'m good, thanks!'),
      // Add more messages here
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFFFF8811),
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
              //physics: const NeverScrollableScrollPhysics(),
              //shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(message: messages[index]);
              },
            ),
          ),
          Container(
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
                      hintText: "Message",
                      onChanged: (val) {
                        messageController.text = val!;
                        return null;
                      },
                      textInputType: TextInputType.multiline,
                      maxLines: 10,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF0E4D92),
                        shape: const CircleBorder(
                            // side: BorderSide(
                            //   color: Colors.white,
                            //   width: 2.8,
                            // ),
                            ),
                      ),
                      onPressed: () {
                        formKey.currentState!.save();
                        debugPrint(messageController.text);
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  )
                ],
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

class ChatMessage extends StatelessWidget {
  final Message message;

  ChatMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: message.sender == 'You'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: message.sender == 'You' ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

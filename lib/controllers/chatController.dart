import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/services/database.dart';

class ChatController extends GetxController {
  Rx<List<ChatMessages?>?> messagesList = Rx<List<ChatMessages?>?>([]);
  RxList<DatabaseChatResponse?> myChats = RxList<DatabaseChatResponse?>([]);
  var member1UID = "".obs;
  var member2UID = "".obs;
  var isButtonEnabled = false.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   messagesList.bindStream(getMessages(member1UID.value, member2UID.value));
  //   print(messagesList);
  //   // print(member1UID.value);
  //   // print(member2UID.value);
  // }

  void getMessages(String member1, member2) {
    //print(DataBaseService().getChats(member1, member2));
    messagesList.bindStream(DataBaseService().getChats(member1, member2));
    // for (var element in messagesList.value!) {
    //   print(element!.idFrom);
    //   print(element.idTo);
    // }
  }

  startChat(Chat chat, ChatMessages chatMessages) {
    return DataBaseService().startChat(chat, chatMessages);
  }

  List<ChatMessages> sortByFirestoreTimestamp(List<ChatMessages> list) {
    if (list.isEmpty) return []; // Handle empty list case

    return list
      ..sort((a, b) {
        // Convert timestamps to comparable values
        final timestampA = a.timestamp as Timestamp;
        final timestampB = b.timestamp as Timestamp;
        return timestampA.compareTo(timestampB);
      });
  }

  getUserChats(String userID) {
    var resultStream = DataBaseService().getUserChats(userID);
    resultStream.listen((chats) {
      myChats.assignAll(chats);
      // for (var element in myChats) {
      //   sortByFirestoreTimestamp(element!.messages!);
      // }
    });
    return resultStream;
  }
}

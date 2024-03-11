import 'package:get/get.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/services/database.dart';

class ChatController extends GetxController {
  Rx<List<ChatMessages?>?> messagesList = Rx<List<ChatMessages?>?>([]);
  var member1UID = "".obs;
  var member2UID = "".obs;
  var isButtonEnabled = false.obs;

  @override
  void onReady() {
    super.onReady();
    messagesList.bindStream(getMessages(member1UID.value, member2UID.value));
    // print(messagesList);
    // print(member1UID.value);
    // print(member2UID.value);
  }

  Stream<List<ChatMessages?>?> getMessages(String member1, member2) {
    print(DataBaseService().getChats(member1, member2));
    return DataBaseService().getChats(member1, member2);
  }

  startChat(Chat chat, ChatMessages chatMessages) {
    return DataBaseService().startChat(chat, chatMessages);
  }
}

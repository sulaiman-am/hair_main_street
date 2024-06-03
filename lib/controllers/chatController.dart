import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';

class ChatController extends GetxController {
  UserController userController = Get.find<UserController>();
  Rx<List<ChatMessages?>?> messagesList = Rx<List<ChatMessages?>?>([]);
  RxList<Chat?> myChats = RxList<Chat?>([]);
  var member1UID = "".obs;
  var member2UID = "".obs;
  var isButtonEnabled = false.obs;
  var isLoading = false.obs;

  Rx<MessagePageData?> idTo = MessagePageData().obs;
  Rx<MessagePageData?> idFrom = MessagePageData().obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   messagesList.bindStream(getMessages(member1UID.value, member2UID.value));
  //   print(messagesList);
  //   // print(member1UID.value);
  //   // print(member2UID.value);
  // }

  void getMessages(String member1, member2) {
    isLoading.value = true;
    //print(DataBaseService().getChats(member1, member2));
    messagesList.bindStream(DataBaseService().getChats(member1, member2));
    isLoading.value = false;
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
    });
    return resultStream;
  }

  void resolveTheNames(ChatMessages message) async {
    idTo.value = await resolveNameToDisplay(message.idTo!);
    idFrom.value = await resolveNameToDisplay(message.idFrom!);
    update(); // This will trigger a rebuild of the widget
  }

  Future<MessagePageData> resolveNameToDisplay(String displayID) async {
    MessagePageData nameToDisplay = MessagePageData();
    MyUser? userDetails = await userController.getUserDetails(displayID);

    if (userDetails!.isVendor!) {
      var vendorData =
          await userController.getVendorDetailsFuture(userDetails.uid!);
      nameToDisplay.id = vendorData!.userID!;
      nameToDisplay.name = vendorData.shopName!;
      //nameToDisplay.imageUrl = vendorData.shopPicture!;
    } else {
      nameToDisplay.id = userDetails.uid!;
      nameToDisplay.name = userDetails.fullname!;
      nameToDisplay.imageUrl = userDetails.profilePhoto!;
    }

    return nameToDisplay;
  }
}

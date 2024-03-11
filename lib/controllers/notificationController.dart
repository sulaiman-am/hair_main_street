import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hair_main_street/models/notificationsModel.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/services/notification.dart';

class NotificationController extends GetxController {
  var notifications = <Notifications>[].obs;

  // @override
  // void onInit() {
  //   NotificationService().init();
  //   super.onInit();
  // }

  subscribeToTopics(String userType, String userID) {
    NotificationService().subscribeToTopics(userType, userID);
  }

  getNotifications() {
    notifications.bindStream(DataBaseService().getNotifications());
  }
}

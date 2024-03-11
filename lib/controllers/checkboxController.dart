import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/auxModels.dart';
import 'package:hair_main_street/models/userModel.dart';

class CheckBoxController extends GetxController {
  var checkOutTickBoxModel = CheckOutTickBoxModel().obs;
// Map to store the checkbox state for each productID
  final Map<String, RxBool> itemCheckboxState = {};

  // List to store selected items
  List<CheckOutTickBoxModel> checkoutList = <CheckOutTickBoxModel>[].obs;

  // RxBool for the master checkbox
  final RxBool isMasterCheckboxChecked = false.obs;
}

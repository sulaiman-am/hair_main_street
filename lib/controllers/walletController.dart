import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/models/wallet_transaction.dart';
import 'package:hair_main_street/services/database.dart';

class WalletController extends GetxController {
  var wallet = Wallet().obs;
  RxList<Transactions> transactions = RxList<Transactions>([]);
  RxList<WithdrawalRequest> withdrawalRequests = RxList<WithdrawalRequest>([]);
  RxBool isLoading = false.obs;
  RxString id = "".obs;

  @override
  void onReady() {
    super.onReady();
    wallet.bindStream(getWalletBalance(id.value));
    //withdrawalRequests.bindStream(getWithdrawalRequests(id.value));
    transactions.bindStream(getTransaction(id.value));
  }

  Stream<Wallet> getWalletBalance(String userID) {
    return DataBaseService().getWalletBalance(userID);
  }

  Stream<List<Transactions>> getTransaction(String userID) {
    return DataBaseService().getTransactions(userID);
  }

  Stream<List<WithdrawalRequest>> getWithdrawalRequests(String userID) {
    return DataBaseService().getWithdrawalRequests(userID);
  }

  Future withdrawalRequest(
      num withdrawalAmount, Map accountDetails, String userId) async {
    var result = await DataBaseService()
        .requestWithdrawal(withdrawalAmount, accountDetails, userId);
    isLoading.value = true;
    if (result == 'success') {
      isLoading.value = false;
      var screenHeight = Get.height;
      Get.snackbar(
        "Success",
        "Withdrawal Request Submitted",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1, milliseconds: 800),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.green[200],
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: screenHeight * 0.08,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/controllers/vendorController.dart';
import 'package:hair_main_street/controllers/walletController.dart';
import 'package:hair_main_street/pages/vendor_dashboard/withdrawal_Page.dart';
import 'package:hair_main_street/pages/vendor_dashboard/withdrawal_requests.dart';
import 'package:hair_main_street/widgets/text_input.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:string_validator/string_validator.dart' as validator;

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  UserController userController = Get.find<UserController>();
  WalletController walletController = Get.put(WalletController());
  VendorController vendorController = Get.find<VendorController>();

  @override
  Widget build(BuildContext context) {
    //print(vendorAccountDetails);
    walletController.id.value = userController.userState.value!.uid!;
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;

    void _showBottomSheet(BuildContext context) {
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        builder: (BuildContext context) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            //shrinkWrap: true,
            itemCount: walletController.transactions.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                style: ListTileStyle.drawer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                title: Text(
                  "${walletController.transactions.value[index].description}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                leading: walletController.transactions[index].type == 'credit'
                    ? Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        color: Colors.green[800],
                        size: 28,
                      )
                    : Icon(
                        Icons.keyboard_double_arrow_up_rounded,
                        color: Colors.red[800],
                        size: 28,
                      ),
                subtitle: Text(
                  "${walletController.transactions[index].transactionId}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  "₦${walletController.transactions[index].amount}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Gradient myGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 224, 139),
        Color.fromARGB(255, 200, 242, 237)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    Gradient appBarGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 200, 242, 237),
        Color.fromARGB(255, 255, 224, 139)
      ],
      stops: [
        0.05,
        0.99,
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomCenter,
      //transform: GradientRotation(math.pi / 4),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        // title: const Text(
        //   'Wallet',
        //   style: TextStyle(
        //     fontSize: 32,
        //     fontWeight: FontWeight.w900,
        //     color: Color(
        //       0xFFFF8811,
        //     ),
        //   ),
        // ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        //backgroundColor: Colors.transparent,
      ),
      body: Obx(
        () => ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              height: screenHeight * 1,
              //padding: EdgeInsets.symmetric(horizontal: 12),
              //decoration: BoxDecoration(gradient: myGradient),
              child: Stack(
                //padding: EdgeInsets.only(top: 8),
                children: [
                  Container(
                    height: screenHeight * 0.27,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                      color: Colors.black,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color(0xFF000000),
                      //     blurStyle: BlurStyle.normal,
                      //     offset: Offset.fromDirection(-4.0),
                      //     blurRadius: 4,
                      //   ),
                      // ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "My Wallet",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "N${walletController.wallet.value.balance}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Withdrawable Balance:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 0,
                                  // ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "N${walletController.wallet.value.withdrawableBalance}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset.fromDirection(-4.0),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: screenWidth * 0.1,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 0,
                    //right: ,
                    width: screenWidth * 1,
                    height: screenHeight * .73,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 52, 12, 0),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(
                                () => WithdrawalRequestsPage(
                                  userID: userController.userState.value!.uid!,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 0.8,
                                  color: Colors.black54,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "See Withdrawal Requests",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Transaction History",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  //alignment: Alignment.centerLeft,
                                  //backgroundColor: Colors.red[400],
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black,
                                        width: 1.6,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _showBottomSheet(context);
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * .01,
                          ),
                          walletController.transactions.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black38,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "No Transactions",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(
                                        "${walletController.transactions.value[index].description}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24,
                                        ),
                                      ),
                                      leading: walletController.transactions
                                                  .value[index].type ==
                                              'credit'
                                          ? Icon(
                                              Icons
                                                  .keyboard_double_arrow_down_rounded,
                                              color: Colors.green[800],
                                              size: 28,
                                            )
                                          : Icon(
                                              Icons
                                                  .keyboard_double_arrow_up_rounded,
                                              color: Colors.red[800],
                                              size: 28,
                                            ),
                                      subtitle: Text(
                                        "${walletController.transactions.value[index].transactionId}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: Text(
                                        "₦${walletController.transactions.value[index].amount}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  GetX<VendorController>(
                    builder: (_) {
                      return Visibility(
                        visible:
                            vendorController.vendor.value!.secondVerification ==
                                true,
                        child: Positioned(
                          top: screenHeight * .21,
                          left: screenWidth * 0.08,
                          right: screenWidth * 0.08,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  //alignment: Alignment.centerLeft,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(() => WithdrawalPage());
                                },
                                icon: const Icon(
                                  Icons.wallet,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  "Request Withdrawal",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

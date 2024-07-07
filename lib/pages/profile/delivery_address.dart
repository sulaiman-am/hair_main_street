import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/pages/profile/add_delivery_address.dart';
import 'package:hair_main_street/pages/profile/edit_delivery_address.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  UserController userController = Get.find<UserController>();
  // GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    userController.getDeliveryAddresses(userController.userState.value!.uid!);
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = userController.userState.value!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 20, color: Colors.black),
        ),
        title: const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: DataBaseService().getDeliveryAddresses(user.uid!),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            }
            return Obx(
              () {
                return userController.deliveryAddresses.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Iconify(
                                Carbon.location,
                                size: 156,
                                color: Color(0xFF673AB7).withOpacity(0.30),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Oops No Delivery Address Added Yet",
                                style: TextStyle(
                                  color: Color(0xFF673AB7).withOpacity(0.70),
                                  fontSize: 30,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: userController.deliveryAddresses.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Iconify(
                                Carbon.location,
                                size: 28,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userController.deliveryAddresses[index]!.landmark ?? ""},${userController.deliveryAddresses[index]!.streetAddress},${userController.deliveryAddresses[index]!.lGA},${userController.deliveryAddresses[index]!.state}.${userController.deliveryAddresses[index]!.zipCode ?? ""}",
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${userController.deliveryAddresses[index]!.contactName ?? ""},${userController.deliveryAddresses[index]!.contactPhoneNumber}",
                                      style: const TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => EditDeliveryAddressPage(
                                            addressID: userController
                                                .deliveryAddresses[index]!
                                                .addressID!,
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/Icons/edit.svg",
                                              color: Color(0xFF673AB7),
                                              height: 24,
                                              width: 24,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const Text(
                                              "Edit",
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF673AB7),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.to(() => const AddDeliveryAddressPage());
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                backgroundColor: const Color(0xFF673AB7),
                // side:
                //     const BorderSide(color: Colors.white, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Add New Address",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/notificationController.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/pages/menu/order_detail.dart';
import 'package:hair_main_street/pages/vendor_dashboard/order_details.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  dynamic data;
  NotificationsPage({this.data, super.key});

  @override
  Widget build(BuildContext context) {
    print("data: $data");
    var screenWidth = Get.width;
    CheckOutController checkOutController = Get.find<CheckOutController>();
    ProductController productController = Get.find<ProductController>();
    UserController userController = Get.find<UserController>();
    NotificationController notificationController =
        Get.find<NotificationController>();
    if (userController.userState.value != null) {
      notificationController.getNotifications();
    }
    String resolveTimestampWithoutAdding(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
      var newDate = DateFormat("dd-MM-yyyy").format(dateTime);
      // Add days to the DateTime
      //DateTime newDateTime = dateTime.add(Duration(days: daysToAdd));

      return newDate;
    }

    return userController.userState.value == null
        ? BlankPage(
            haveAppBar: true,
            text: "You are not Logged In",
            pageIcon: const Icon(
              Icons.person_off_outlined,
              size: 48,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: StreamBuilder(
                stream: DataBaseService().getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var notification = notificationController.notifications;
                    if (notificationController.notifications.isEmpty) {
                      return BlankPage(
                        text: "No Notifications",
                        pageIcon: const Icon(
                          Icons.notifications_off_rounded,
                          size: 48,
                        ),
                      );
                    } else {}
                    return ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        itemCount: notificationController.notifications.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              DatabaseOrderResponse order =
                                  await checkOutController.getSingleOrder(
                                      notification[index].extraData!);
                              var product = productController.getSingleProduct(
                                  order.orderItem!.first.productId!);
                              // var user = await userController
                              //     .getUserDetails(notification[index].userID!);
                              if (notification[index].userID == order.buyerId) {
                                Get.to(
                                  () => OrderDetailsPage(
                                    product: product,
                                    orderDetails: order,
                                  ),
                                );
                              } else if (notification[index].userID ==
                                  order.vendorId) {
                                Get.to(
                                  () => VendorOrderDetailsPage(
                                    product: product,
                                    orderDetails: order,
                                  ),
                                );
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification[index].title!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          resolveTimestampWithoutAdding(
                                              notification[index].timestamp!),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 36,
                                          child: Icon(
                                            Icons.list_alt_rounded,
                                            size: 48,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.60,
                                              child: Text(
                                                "${notification[index].body}",
                                                maxLines: 5,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            const Text("See Details")
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                }),
          );
  }
}

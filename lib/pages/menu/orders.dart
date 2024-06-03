import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/pages/menu/order_detail.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  CheckOutController checkOutController = Get.find<CheckOutController>();

  UserController userController = Get.find<UserController>();
  bool showContent = false;

  @override
  void initState() {
    super.initState();
    checkOutController.getBuyerOrders(userController.userState.value!.uid!);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showContent = true;
      });
    });
    // checkOutController
    //     .filterTheBuyerOrderList(checkOutController.buyerOrderList);
  }

  @override
  Widget build(BuildContext context) {
    List categories = [
      "All",
      "Once",
      "Installment",
      "Confirmed",
      "Expired",
      "Cancelled",
      "Deleted",
    ];
    TabController tabController =
        TabController(length: categories.length, vsync: this);
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
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
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Symbols.arrow_back_ios_new_rounded,
                size: 24, color: Colors.black),
          ),
          title: const Text(
            'Orders',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  controller: tabController,
                  indicatorWeight: 4,
                  indicatorColor: Colors.black,
                  tabs: categories
                      .map((e) => Text(
                            e,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ))
                      .toList()),
            ),
          ),
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(gradient: appBarGradient),
          // ),
          //backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder(
          stream: DataBaseService()
              .getBuyerOrders(userController.userState.value!.uid!),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (snapshot.hasData) {
              if (!showContent) {
                return const SizedBox(); // Return an empty SizedBox if content should not be displayed yet
              }
              return checkOutController.buyerOrderList.isEmpty
                  ? BlankPage(
                      text: "No Orders Currently",
                      textStyle: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      pageIcon: const Icon(
                        Icons.do_disturb_alt_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    )
                  : TabBarView(
                      controller: tabController,
                      children: [
                        _buildTabContent("All"),
                        _buildTabContent("Once"),
                        _buildTabContent("Installment"),
                        _buildTabContent("Confirmed"),
                        _buildTabContent("Expired"),
                        _buildTabContent("Cancelled"),
                        _buildTabContent("Deleted"),
                      ],
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(String tabName) {
    return Obx(() {
      final orders = checkOutController.buyerOrderMap[tabName]!;
      return orders.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    OrderCard(mapKey: tabName, index: index),
                itemCount: orders.length,
              ),
            )
          : const Center(
              child: Text(
                "Nothing Here",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            );
    });
  }
}

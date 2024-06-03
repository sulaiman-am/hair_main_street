import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/blankPage.dart';
import 'package:hair_main_street/controllers/order_checkoutController.dart';
import 'package:hair_main_street/controllers/userController.dart';
import 'package:hair_main_street/services/database.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:hair_main_street/widgets/loading.dart';
import 'package:material_symbols_icons/symbols.dart';

class VendorOrdersPage extends StatefulWidget {
  VendorOrdersPage({super.key});

  @override
  State<VendorOrdersPage> createState() => _VendorOrdersPageState();
}

class _VendorOrdersPageState extends State<VendorOrdersPage>
    with TickerProviderStateMixin {
  UserController userController = Get.find<UserController>();

  CheckOutController checkOutController = Get.find<CheckOutController>();
  bool showContent = false;

  @override
  void initState() {
    super.initState();
    checkOutController.getSellerOrders(userController.userState.value!.uid!);
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
    List categories = ["Active", "Expired", "Cancelled"];
    TabController tabController =
        TabController(length: categories.length, vsync: this);
    //s checkOutController.userUID.value = userController.userState.value!.uid!;
    print("print:${checkOutController.userUID.value}");
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    checkOutController.getSellerOrders(userController.userState.value!.uid!);
    // print(
    //     "value: ${checkOutController.getBuyerOrders(checkOutController.userUID.value).first}");
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
            'Vendors Orders',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
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
        ),
        body: StreamBuilder(
          stream: DataBaseService()
              .getVendorsOrders(userController.userState.value!.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!showContent) {
                return const SizedBox();
              }
              return checkOutController.vendorOrderList.isEmpty
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
                        _buildTabContent("Active"),
                        _buildTabContent("Expired"),
                        _buildTabContent("Cancelled"),
                      ],
                    );
            } else {
              return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(String tabName) {
    return Obx(() {
      final orders = checkOutController.vendorOrdersMap[tabName]!;
      return orders.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    VendorOrderCard(mapKey: tabName, index: index),
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

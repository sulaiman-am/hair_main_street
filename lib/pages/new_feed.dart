import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/controllers/productController.dart';
import 'package:hair_main_street/extras/delegate.dart';
import 'package:hair_main_street/pages/notifcation.dart';
import 'package:hair_main_street/widgets/cards.dart';

class NewFeedPage extends StatefulWidget {
  const NewFeedPage({super.key});

  @override
  State<NewFeedPage> createState() => _NewFeedPageState();
}

class _NewFeedPageState extends State<NewFeedPage>
    with TickerProviderStateMixin {
  int? itemCount;

  @override
  void initState() {
    super.initState();
    itemCount = 4;
  }

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    //VendorController vendorController = Get.find<VendorController>();
    GlobalKey<FormState> formKey = GlobalKey();
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    List<Map> categories = [
      {
        "Natural Hair":
            "assets/images/DALL·E 2024-02-13 10.22.29 - an image i can use as the category image for  natural hair on an app.png"
      },
      {"Wigs": "assets/images/wigs.jpeg"},
      {"Accessories": "assets/images/accessories.jpeg"},
      {"Lashes": "assets/images/DIY lash extensions.jpeg"},
    ];
    TabController tabController =
        TabController(length: categories.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
        // bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(screenHeight * 0.04),
        //     child: Form(child: child)),
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    backgroundColor: Colors.grey.shade50,
                    //elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey.shade500,
                        width: 0.5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => showSearch(
                      context: context, delegate: MySearchDelegate()),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 24,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Search for hairs, shops and more",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 1,
                child: TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    controller: tabController,
                    indicatorWeight: 4,
                    indicatorColor: Colors.black,
                    tabs: categories
                        .map((e) => Text(
                              e.keys.first,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ))
                        .toList()),
              ),
            ],
          ),
        ),

        actions: [
          // IconButton(
          //   onPressed: () {
          //     showSearch(context: context, delegate: MySearchDelegate());
          //   },
          //   icon: const Icon(
          //     Icons.search,
          //     color: Colors.black,
          //     size: 28,
          //   ),
          // ),
          Transform.rotate(
            angle: 0.3490659,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                onPressed: () {
                  Get.to(() => NotificationsPage());
                },
                icon: const Icon(
                  Icons.notifications_active_rounded,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
        centerTitle: true,
        //backgroundColor: const Color(0xFF0E4D92),

        //backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      body: GetX<ProductController>(builder: (controller) {
        return controller.products.value.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              )
            : TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.28,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) => ProductCard(
                                index: index,
                                id: productController
                                    .products.value[index]!.productID,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  //print(controller.products.value.length);
                                  setState(() {
                                    itemCount = itemCount! + 2;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Load More...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "Vendor Highlights",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: controller.vendorsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.25,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) =>
                                  VendorHighlightsCard(
                                index: index,
                                // id: productController
                                //     .products.value[index]!.productID,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
                  // Repeat the above pattern for other TabBarView children
                  ListView.builder(
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.28,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) => ProductCard(
                                index: index,
                                id: productController
                                    .products.value[index]!.productID,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    itemCount = itemCount! + 2;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Load More...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "Vendor Highlights",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: controller.vendorsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.25,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) =>
                                  VendorHighlightsCard(
                                index: index,
                                // id: productController
                                //     .products.value[index]!.productID,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
                  ListView.builder(
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.28,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) => ProductCard(
                                index: index,
                                id: productController
                                    .products.value[index]!.productID,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    itemCount = itemCount! + 2;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Load More...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "Vendor Highlights",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: controller.vendorsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.25,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) =>
                                  VendorHighlightsCard(
                                index: index,
                                // id: productController
                                //     .products.value[index]!.productID,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
                  ListView.builder(
                    // padding:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.28,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) => ProductCard(
                                index: index,
                                id: productController
                                    .products.value[index]!.productID,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    itemCount = itemCount! + 2;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Load More...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "Vendor Highlights",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: controller.vendorsList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: screenHeight * 0.25,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) =>
                                  VendorHighlightsCard(
                                index: index,
                                // id: productController
                                //     .products.value[index]!.productID,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
                ],
              );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/widgets/cards.dart';
import 'package:material_symbols_icons/symbols.dart';

class ClientShopPage extends StatefulWidget {
  final String? vendorName;
  const ClientShopPage({this.vendorName, super.key});

  @override
  State<ClientShopPage> createState() => _ClientShopPageState();
}

class _ClientShopPageState extends State<ClientShopPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  //UserController userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num screenHeight = MediaQuery.of(context).size.height;
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: Text(
          widget.vendorName == null ? 'Vendor' : '${widget.vendorName}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0E4D92),
          ),
        ),
        centerTitle: true,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(gradient: appBarGradient),
        // ),
        bottom: TabBar(
          controller: tabController,
          //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          indicatorColor: Colors.black,
          indicatorWeight: 8,
          labelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Vendor Products",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Vendor Info",
              ),
            ),
          ],
          //indicatorColor: Colors.white,
        ),
        //backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TabBarView(
          controller: tabController,
          //physics: NeverScrollableScrollPhysics(),
          children: [
            //vendor products page
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: screenHeight * 0.24,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              itemBuilder: (_, index) => ClientShopCard(
                index: index,
              ),
              itemCount: 5,
            ),

            //vendor info page
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shop Name",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Sulaiman Abubakar",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shop Address",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              "No 224 Darmanawa Gabas\nTarauni LGA\nKano\nNigeria",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    color: Colors.grey[300],
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tel No.",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "081022728764",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

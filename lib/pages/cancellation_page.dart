import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recase/recase.dart';

class CancellationPage extends StatefulWidget {
  final String orderId; // Pass the actual order ID as a String

  const CancellationPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends State<CancellationPage> {
  String selectedReason = "Changed My Mind"; // Initial selected reason
  TextEditingController othersController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded,
              size: 24, color: Colors.black),
        ),
        title: const Text(
          "Cancel Order",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          clipBehavior: Clip.hardEdge,
          children: [
            // Order ID Row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Text(
                    "Order ID:",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.orderId, // Display the actual order ID
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Reason for Refund Row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reason for Cancellation:",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    elevation: 0,
                    color: Colors.white,
                    initialValue: selectedReason,
                    //icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String? newValue) {
                      setState(() {
                        selectedReason = newValue!;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "Changed My Mind",
                        child: Text("Changed My Mind"),
                      ),
                      const PopupMenuItem<String>(
                        value: "Wrong Order",
                        child: Text("Wrong Order"),
                      ),
                      const PopupMenuItem<String>(
                        value: "No Funds To Complete Order",
                        child: Text("No Funds To Complete Order"),
                      ),
                      const PopupMenuItem<String>(
                        value: "Others",
                        child: Text("Others"),
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          selectedReason.titleCase,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: selectedReason == "Others",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: othersController,
                  onChanged: (value) {
                    othersController.text = value;
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Specify Reason",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.symmetric(
                  //     horizontal: screenWidth * 0.24),
                  backgroundColor: Colors.black,
                  side: const BorderSide(color: Colors.white, width: 1),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle submit button press (e.g., submit refund request)
                },
                child: const Text(
                  "Submit Cancellation Request",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

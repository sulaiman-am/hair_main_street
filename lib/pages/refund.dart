import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recase/recase.dart';

class RefundPage extends StatefulWidget {
  final String orderId; // Pass the actual order ID as a String

  const RefundPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  String selectedReason = "Defective Product"; // Initial selected reason
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
          "Refund",
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
                    "Reason for Refund:",
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
                        value: "Defective Product",
                        child: Text("Defective Product"),
                      ),
                      const PopupMenuItem<String>(
                        value: "Changed My Mind",
                        child: Text("Changed My Mind"),
                      ),
                      const PopupMenuItem<String>(
                        value: "Received Wrong Item",
                        child: Text("Received Wrong Item"),
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

            // Text for additional details (optional)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Please provide additional details about your refund request (optional):",
                style: TextStyle(fontSize: 16.0),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                controller: detailsController,
                onChanged: (value) {
                  detailsController.text = value;
                },
                maxLines: 5,
                minLines: 3,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Added Details",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            // Add a TextField or other widgets here for additional details

            // Submit button (optional)
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
                  "Submit Refund Request",
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

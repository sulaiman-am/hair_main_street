import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street/extras/country_state.dart';
import 'package:hair_main_street/widgets/text_input.dart';

class ChangeAddressWidget extends StatelessWidget {
  final String? text;
  final Function(String)? onFilled;
  const ChangeAddressWidget({this.onFilled, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    CountryAndStatesAndLocalGovernment countryAndStatesAndLocalGovernment =
        CountryAndStatesAndLocalGovernment();
    String? country, state, localGovernment, streetAddress;
    TextEditingController streetAddressController = TextEditingController();
    return StatefulBuilder(
      builder: (context, StateSetter setState) => AlertDialog(
        scrollable: true,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(8),
        elevation: 0,
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$text",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Column(
                  children: [
                    buildPicker(
                        "Country",
                        countryAndStatesAndLocalGovernment.countryList,
                        country, (val) {
                      setState(() {
                        country = val;
                      });
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    buildPicker(
                        "State",
                        countryAndStatesAndLocalGovernment.statesList,
                        state, (val) {
                      setState(() {
                        state = val;
                        localGovernment = null;
                      });
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    buildPicker(
                        "Local Government",
                        countryAndStatesAndLocalGovernment
                                .stateAndLocalGovernments[state] ??
                            [],
                        localGovernment ?? "select", (val) {
                      setState(() {
                        localGovernment = val;
                      });
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    TextInputWidgetWithoutLabelForDialog(
                      controller: streetAddressController,
                      // initialValue: vendorController
                      //         .vendor.value!.contactInfo!["street address"] ??
                      //     "",
                      hintText: "Street Address",
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Cannot be Empty";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        streetAddressController.text = val!;
                        streetAddress = streetAddressController.text;
                        return null;
                      },
                    ),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    var validated = formKey.currentState!.validate();
                    if (validated) {
                      formKey.currentState!.save();
                      String address =
                          "$streetAddress $localGovernment $state $country";
                      onFilled!(address);
                    }
                    Get.back();
                  },
                  child: const Text(
                    "Confirm Edit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicker(String label, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isDense: true,
              onChanged: onChanged,
              items: [
                const DropdownMenuItem(
                  value: 'select',
                  child: Text('Select'),
                ),
                ...items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/Controllers/adminDataController.dart';
import 'package:kotc/Material/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddNewKitchen extends StatefulWidget {
  const AddNewKitchen({super.key});

  @override
  State<AddNewKitchen> createState() => _AddNewKitchenState();
}

class _AddNewKitchenState extends State<AddNewKitchen> {
  AdminDataController adminDataController = AdminDataController();

  String radioGroup = "Domain And Location";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceMonthlyController = TextEditingController();
  TextEditingController priceYearlyController = TextEditingController();

  InputDecoration inputDecoration({String? label, String? suffex}) =>
      InputDecoration(
        label: Text(label!),
        suffix: Text(
          suffex ?? "",
          style: TextStyle(
            color: secondColor,
          ),
        ),
        labelStyle: TextStyle(
          color: secondColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
      );

  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoad,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: inputDecoration(label: "Name", suffex: ""),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: descriptionController,
                      decoration:
                          inputDecoration(label: "Description", suffex: ""),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                              groupValue: radioGroup,
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  radioGroup = value!;
                                });
                              },
                              value: "Domain And Location",
                              activeColor: secondColor,
                            ),
                            Text("Domain And Location".tr),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              groupValue: radioGroup,
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  radioGroup = value!;
                                });
                              },
                              value: "Domain Only",
                              activeColor: secondColor,
                            ),
                            Text("Domain Only".tr),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: priceMonthlyController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(
                          label: "Price Per Month", suffex: "ILS"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: priceYearlyController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(
                          label: "Price Per Year", suffex: "ILS"),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  isLoad = true;
                });
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    priceMonthlyController.text.isNotEmpty &&
                    priceYearlyController.text.isNotEmpty) {
                  await adminDataController.addNewKitchen(
                    nameController.text.trim(),
                    descriptionController.text.trim(),
                    radioGroup,
                    priceMonthlyController.text.trim(),
                    priceYearlyController.text.trim(),
                  );

                  setState(() {
                    nameController.clear();
                    descriptionController.clear();
                    priceMonthlyController.clear();
                    priceYearlyController.clear();
                  });
                } else {
                  Get.snackbar("", "Plz Fill in all fields");
                }

                setState(() {
                  isLoad = false;
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      20,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    "ADD".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kotc/Controllers/availableKitchenController.dart';
import 'package:kotc/Material/colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RequestRentRestaurant extends StatefulWidget {
  const RequestRentRestaurant({super.key});

  @override
  State<RequestRentRestaurant> createState() => _RequestRentRestaurantState();
}

class _RequestRentRestaurantState extends State<RequestRentRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Text(
                      """On this page, you can choose between:

- A place for you in the app with a kitchen from our kitchens
or
- In app only"""
                          .tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.info_outline,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        90,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text("Domain Only".tr),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        90,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text("Domain And Location".tr)
              ],
            ),
          ),
          Expanded(
            child: Consumer<AvailableKitchenController>(
              builder: (context, value, child) {
                if (value.listOfAvailableKitchen.isNotEmpty) {
                  return ListView.builder(
                    itemCount: value.listOfAvailableKitchen.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Alert(
                                context: context,
                                title: value.listOfAvailableKitchen[index].name,
                                content: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text("Price Monthly : ".tr),
                                        Text(value.listOfAvailableKitchen[index]
                                            .priceMonthly
                                            .toString()),
                                        Text("ILS".tr),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text("Price Yearly : ".tr),
                                        Text(value.listOfAvailableKitchen[index]
                                            .priceYearly
                                            .toString()),
                                        Text("ILS".tr),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(value.listOfAvailableKitchen[index]
                                        .description),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Alert(
                                          context: context,
                                          title: "Rent Request",
                                          content: Column(
                                            children: [
                                              Text(
                                                  "Are you sure you want to rent a restaurant?"
                                                      .tr),
                                            ],
                                          ),
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                await value.sendRentRequest(
                                                  value
                                                      .listOfAvailableKitchen[
                                                          index]
                                                      .id,
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);

                                                Get.snackbar(
                                                  "",
                                                  "Your request has been sent successfully"
                                                      .tr,
                                                  colorText: Colors.white,
                                                );
                                              },
                                              color: secondColor,
                                              child: Text(
                                                "Send".tr,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            )
                                          ]).show();
                                    },
                                    color: secondColor,
                                    child: Text(
                                      "Rent".tr,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context),
                                    color: secondColor,
                                    child: Text(
                                      "Cancel".tr,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ]).show();
                          },
                          tileColor: const Color.fromARGB(93, 226, 226, 226),
                          title: Text(
                            value.listOfAvailableKitchen[index].name,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                value.listOfAvailableKitchen[index]
                                    .domainOrLocatonAndDomain,
                                style: GoogleFonts.firaSans(),
                              ),
                            ],
                          ),
                          leading: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: value.listOfAvailableKitchen[index]
                                          .domainOrLocatonAndDomain ==
                                      "Domain And Location"
                                  ? Colors.blue
                                  : Colors.red,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  90,
                                ),
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: secondColor),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

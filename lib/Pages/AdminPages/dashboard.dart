import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/Controllers/adminDataController.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/AdminPages/addNewKitchen.dart';
import 'package:kotc/classes/rentRequestClass.dart';
import 'package:kotc/main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AdminDataController adminDataController = AdminDataController();
  bool progress = false;

  refreshMethod() {
    FirebaseFirestore.instance
        .collection("RentRequest")
        .snapshots()
        .listen((event) {
      setState(() {});
      print("wow");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshMethod();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: secondColor,
      inAsyncCall: progress,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AddNewKitchen(),
                ));
          },
          backgroundColor: secondColor,
          child: const Icon(
            Icons.add_card,
          ),
        ),
        appBar: AppBar(
          backgroundColor: secondColor,
          title: Text(
            "Dashboard".tr,
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                await authController.signout();
                Navigator.of(context).pushReplacementNamed("/sign");
              },
              child: Text("Signout".tr),
            ),
          ),
        ),
        body: FutureBuilder<List<RentRequestClass>>(
          future: adminDataController.getRenRequests(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Request: ".tr + (index + 1).toString(),
                            style: TextStyle(
                              color: secondColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 212, 212, 212),
                          ),
                        ),
                        Row(children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "User".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data![index].user!.name,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].user!.email,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].user!.phone,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].user!.position,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Kitchen".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data![index].kitchen!.name,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].kitchen!.description,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].kitchen!
                                      .domainOrLocatonAndDomain,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].kitchen!.priceMonthly
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data![index].kitchen!.priceYearly
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ]),
                        const Spacer(),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 212, 212, 212),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  progress = true;
                                });

                                await adminDataController.generateKitchenAdmin(
                                    snapshot.data![index].user!.id,
                                    snapshot.data![index].kitchen!.id);
                                setState(() {
                                  progress = false;
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Accept".tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  progress = true;
                                });

                                await adminDataController.rejectRequest(
                                    snapshot.data![index].user!.id,
                                    snapshot.data![index].kitchen!.id);
                                setState(() {
                                  progress = false;
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Reject".tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: secondColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/classes/meal.dart';
import 'package:kotc/main.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  MyKitchenDataModel myKitchenDataModel = MyKitchenDataModel();
  // void loadMyMenu() async {
  //   myMealList = await myKitchenDataModel.getAllMyMealForMyKitchen();
  //   setState(() {});
  // }
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // loadMyMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondColor,
        child: Container(
          margin: const EdgeInsets.all(
            5,
          ),
          child: Image.asset(
            "image/icons/addnewmeal.png",
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/addNewMeal");
        },
      ),
      body: Scaffold(
          appBar: AppBar(
            backgroundColor: secondColor,
            title: Text("My Menu".tr),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore
                .collection("Meal")
                .where("kitchenownerid", isEqualTo: myKitchen?.kitchenId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(
                        6,
                      ),
                      height: 140,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(56, 158, 158, 158),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!.docs
                                  .elementAt(index)
                                  .get("img"),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 100),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: AutoSizeText(
                                  snapshot.data!.docs
                                      .elementAt(index)
                                      .get("name"),
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 214, 214, 214),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      15,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "${snapshot.data!.docs.elementAt(index).get("price")} ILS",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 130,
                            width: 1,
                            color: const Color.fromARGB(255, 207, 207, 207),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CircleAvatar(
                              //   backgroundColor: Colors.blue,
                              //   child: IconButton(
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.edit,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                child: IconButton(
                                  onPressed: () async {
                                    await myKitchenDataModel.deleteMeal(
                                        snapshot.data!.docs
                                            .elementAt(index)
                                            .get("img"),
                                        snapshot.data!.docs
                                            .elementAt(index)
                                            .id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
          )),
    );
  }
}

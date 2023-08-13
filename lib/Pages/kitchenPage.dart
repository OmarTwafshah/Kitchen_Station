import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/ItemsPatterns/itemFoodCardKitchenPageVisitor.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/allMenu.dart';
import 'package:provider/provider.dart';

//هاي الصفحة بتعرض المطعم للزاءر
// ignore: must_be_immutable
class KitchenPage extends StatefulWidget {
  int index;
  KitchenPage({super.key, required this.index});

  @override
  // ignore: no_logic_in_create_state
  State<KitchenPage> createState() => _KitchenPageState(
        index: index,
      );
}

class _KitchenPageState extends State<KitchenPage> {
  int index;
  _KitchenPageState({required this.index});

  bool isMealLoad = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<DataController>(
      builder: (context, value, child) => WillPopScope(
        onWillPop: () async {
          value.listOfMealVisitorKitchen = [];

          return true;
        },
        child: Scaffold(
          body: ListView(
            children: [
              Container(
                height: screenSize.height / 4,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      30,
                    ),
                    bottomRight: Radius.circular(
                      30,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(100, 0, 0, 0),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: value.listOfKitchenWillDisplay[index].img,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        value.listOfMealVisitorKitchen = [];
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: value.listOfKitchenWillDisplay[index].status
                              ? Colors.green
                              : Colors.red,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              15,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        height: 40,
                        width: 80,
                        child: Center(
                          child: Text(
                            value.listOfKitchenWillDisplay[index].status
                                ? "Open".tr
                                : "Close".tr,
                            style: TextStyle(
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
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      30,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(59, 0, 0, 0),
                      blurRadius: 10,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  value.listOfKitchenWillDisplay[index].name,
                  style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Builder(builder: (context) {
                if (!isMealLoad) {
                  value.loadAllKitchenMealForVisitor(
                      value.listOfKitchenWillDisplay[index].uid);
                  isMealLoad = true;
                }

                if (value.listOfMealVisitorKitchen.isNotEmpty) {
                  return SizedBox(
                    height: 480,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / 1.2,
                        crossAxisCount: 2,
                      ),
                      itemCount: value.listOfMealVisitorKitchen.length > 4
                          ? 4
                          : value.listOfMealVisitorKitchen.length,
                      itemBuilder: (context, index) {
                        return ItemFoodCardKitchenPageVisitor(
                          meal: value.listOfMealVisitorKitchen[index],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: secondColor,
                    ),
                  );
                }
              }),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AllMenu(list: value.listOfMealVisitorKitchen),
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      "View All".tr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

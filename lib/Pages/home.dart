import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kotc/Component/skeleton.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/ItemsPatterns/itemFoodCard.dart';
import 'package:kotc/ItemsPatterns/itemResturantsCard.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/kitchenPage.dart';
import 'package:kotc/main.dart';
import 'package:provider/provider.dart';

import '../Component/skeletonRestorant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DataController dataController;
  @override
  void initState() {
    dataController = Provider.of(context, listen: false);
    super.initState();
    loadingMeals();
  }

  ScrollController scrollController = ScrollController();
  //bool isLoading = false;

  void loadingMeals() async {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        await dataController.loadMeals();
      } else {}
    });
  }

  // AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: secondColor,
          title: Text(
            "${"Hi".tr} ${authController.displayName}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/cart");
                },
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            controller: scrollController,
            // physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
              ),

              //Populer Resturants

              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                height: 20,
                child: Row(
                  children: [
                    Text(
                      "Popular restaurants".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 200,
                child: Consumer<DataController>(
                  builder: (context, value, child) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: value.listOfKitchenWillDisplay.length == 0
                        ? 5
                        : value.listOfKitchenWillDisplay.length > 10
                            ? 9
                            : value.listOfKitchenWillDisplay.length,
                    itemBuilder: (context, index) {
                      return value.listOfKitchenWillDisplay.length == 0
                          ? SkeletonRest()
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          KitchenPage(index: index),
                                    ));
                              },
                              child: ItemResturantsCard(
                                index: index,
                              ),
                            );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Populer Food
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                height: 20,
                child: Row(
                  children: [
                    Text(
                      "Popular food".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Consumer<DataController>(
                  builder: (context, value, child) => MasonryGridView.count(
                    itemCount: value.listOfMealWillDisplay.length + 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 500 ? 3 : 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      if (index >= value.listOfMealWillDisplay.length) {
                        return Skeleton();
                      }
                      return ItemFoodCard(
                          meal: value.listOfMealWillDisplay[index]);
                    },
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //   ),
              //   child: Row(
              //     children: [
              //       Skeleton(),
              //       Skeleton(),
              //     ],
              //   ),
              // )
            ],
          ),
        ));
  }
}

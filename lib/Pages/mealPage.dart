import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kotc/Controllers/cartController.dart';
import 'package:kotc/Controllers/recomendationModel.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/pageManager.dart';
import 'package:kotc/classes/meal.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class MealPage extends StatefulWidget {
  Meal meal;
  MealPage({super.key, required this.meal});

  @override
  State<MealPage> createState() => _MealPageState(meal: meal);
}

class _MealPageState extends State<MealPage> {
  Meal meal;
  _MealPageState({
    required this.meal,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recomendationSystemMethod();
  }

  void recomendationSystemMethod() async {
    List<String> tags = meal.tags.split(",");

    tags.forEach((element) {
      recomendatinSysytem.update(
        element,
        (value) => ++value,
        ifAbsent: () => 1,
      );
    });

    print(recomendatinSysytem);

    await RecomendationModel.setData(recomendatinSysytem);
  }

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ModalProgressHUD(
      color: secondColor,
      inAsyncCall: isLoad,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.heart,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: screenSize.height * 0.5,
                child: CachedNetworkImage(
                  imageUrl: meal.img,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: screenSize.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: secondColor.withOpacity(.9),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        40,
                      ),
                    ),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Container(
                                width: screenSize.width * .8,
                                child: AutoSizeText(
                                  meal.name,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Text("${meal.price} ₪")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                FontAwesomeIcons.clock,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                meal.time,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                FontAwesomeIcons.moneyBill1Wave,
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${meal.price} ₪",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoad = true;
                            });
                            CartController.cartList.add(meal.id);
                            await CartController.setCartList();
                            await Future.delayed(Duration(milliseconds: 500));
                            setState(() {
                              isLoad = false;
                            });
                            Get.snackbar("", "",
                                colorText: Colors.green,
                                backgroundColor: Colors.white,
                                messageText: Row(
                                  children: [
                                    Text(
                                      "Added".tr,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ],
                                ));
                          },
                          splashColor: secondColor,
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  25,
                                ),
                              ),
                              border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add To Cart".tr,
                                  style: TextStyle(
                                    color: secondColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.cartPlus,
                                  color: secondColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: AutoSizeText(
                          meal.description,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
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

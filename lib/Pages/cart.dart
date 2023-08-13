import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kotc/Controllers/cartController.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/classes/meal.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMeal();
  }

  bool isLoad = true;
  void loadMeal() async {
    CartController.loadCartMeal();
    await CartController.loadMealFromDatabase();
    for (Meal d in CartController.cartMealList) {
      totalMealPrice += d.price;
    }
    totalPrice = totalMealPrice + 30;
    setState(() {
      isLoad = false;
    });
  }

  double totalMealPrice = 0;
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CartController.cartMealList.clear();
        return true;
      },
      child: ModalProgressHUD(
        color: secondColor,
        inAsyncCall: isLoad,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: secondColor,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "My Cart".tr,
              style: TextStyle(
                color: secondColor,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: CartController.cartMealList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(88, 0, 0, 0),
                                  blurRadius: 5,
                                )
                              ]),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      CartController.cartMealList[index].img,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 110,
                                          child: AutoSizeText(
                                            CartController
                                                .cartMealList[index].name,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 84, 84, 84),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          CartController
                                              .cartMealList[index].price
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          height: 50,
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                CartController.cartList.remove(
                                                    CartController
                                                        .cartMealList[index]
                                                        .id);
                                                CartController.cartMealList
                                                    .remove(CartController
                                                        .cartMealList[index]);
                                              });
                                              await CartController
                                                  .setCartList();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(105, 0, 0, 0),
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20,
                        ),
                        topRight: Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Items Total:".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                totalMealPrice.toStringAsFixed(2) + "ILS".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Dilevery Service:".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                "30 " + "ILS".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "Total:".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                totalPrice.toStringAsFixed(2) + "ILS".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const Spacer(),
                          MaterialButton(
                            onPressed: () {},
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                                color: secondColor,
                              ),
                              child: const Center(
                                child: Text(
                                  "Check out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

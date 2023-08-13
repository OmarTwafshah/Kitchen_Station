import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kotc/classes/meal.dart';
import 'package:kotc/main.dart';

class CartController {
  static Set<String> cartList = {};
  static List<Meal> cartMealList = [];
  static void loadCartMeal() async {
    try {
      List<String>? list = sharedPreferences!.getStringList("cartList");

      cartList.addAll(list!);
    } catch (e) {}
  }

  static Future<void> setCartList() async {
    List<String> l = cartList.toList();
    print(l);
    print(cartList.length);
    await sharedPreferences!.setStringList("cartList", l);
  }

  static Future<void> loadMealFromDatabase() async {
    for (String str in cartList) {
      await FirebaseFirestore.instance
          .collection("Meal")
          .doc(str)
          .get()
          .then((v) {
        Meal meal = Meal(
            id: v.id,
            name: v.get("name"),
            description: v.get("description"),
            time: v.get("preparationtime"),
            price: v.get("price"),
            tags: v.get("tags"),
            kitchenOwnerId: v.get("kitchenownerid"),
            img: v.get("img"));

        cartMealList.add(meal);
      });
    }
  }
}

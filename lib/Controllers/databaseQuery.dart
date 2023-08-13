import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kotc/classes/kitchen.dart';
import 'package:kotc/classes/meal.dart';

import '../Pages/pageManager.dart';

class DataBaseQuery {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Kitchen>> loadKitchens() async {
    var res = await firebaseFirestore.collection("CustomerKitchen").get();

    List<Kitchen> list = [];
    for (var k in res.docs) {
      List<String> paths = [];
      var ress = await firebaseFirestore
          .collection("CustomerKitchen")
          .doc(k.id)
          .collection("OurMealPaths")
          .get();
      for (var p in ress.docs) {
        paths.add(p.get("path"));
      }

      Kitchen newK = Kitchen(
        uid: k.id,
        name: k.get("kitchenName"),
        img: k.get("profileImg"),
        id: k.get("kitchenId"),
        status: k.get("open"),
        mealPaths: paths,
      );

      list.add(newK);
    }

    return list;
  }

  List<Meal> list = [];
  int afterRecomendedMealLoaded =
      0; //هاي بعد ميخلصو الوجبات اللي ممكن تتشابه مع الاشيائ اللي بحبها بصير يزيد
  bool isInReco = true;
  Future<List<Meal>> loadMeals(int pageSize, int mealLoaded) async {
    List<Meal> tempList = [];
    if (recomendatinSysytem.isEmpty || recomendatinSysytem.length < 3) {
      var res = await firebaseFirestore.collection("Meal").get().then((value) {
        for (int i = 0; mealLoaded < value.size && i < pageSize; i++) {
          QueryDocumentSnapshot v = value.docs.elementAt(mealLoaded);
          Meal newMeal = Meal(
              id: v.id,
              name: v.get("name"),
              description: v.get("description"),
              time: v.get("preparationtime"),
              price: v.get("price"),
              tags: v.get("tags"),
              kitchenOwnerId: v.get("kitchenownerid"),
              img: v.get("img"));

          mealLoaded++;
          list.add(newMeal);
        }
      });
    } else {
      if (isInReco) {
        sort();

        var res = await firebaseFirestore
            .collection("Meal")
            .orderBy("tags")
            .get()
            .then((value) {
          for (int i = 0; mealLoaded < value.size && i < pageSize;) {
            QueryDocumentSnapshot v = value.docs.elementAt(mealLoaded);

            if (v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(0)) ||
                v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(1)) ||
                v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(2)) ||
                v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 1)) ||
                v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 2)) ||
                v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 3))) {
              
              Meal newMeal = Meal(
                  id: v.id,
                  name: v.get("name"),
                  description: v.get("description"),
                  time: v.get("preparationtime"),
                  price: v.get("price"),
                  tags: v.get("tags"),
                  kitchenOwnerId: v.get("kitchenownerid"),
                  img: v.get("img"));

              tempList.add(newMeal);
              i++;
            }
            mealLoaded++;
          }
        });
        if (tempList.length < 10) isInReco = false;
      } else {
        var res = await firebaseFirestore
            .collection("Meal")
            .orderBy("tags")
            .get()
            .then((value) {
          for (int i = 0;
              afterRecomendedMealLoaded < value.size && i < pageSize;) {
            QueryDocumentSnapshot v =
                value.docs.elementAt(afterRecomendedMealLoaded);
            if (!v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(0)) &&
                !v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(1)) &&
                !v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(2)) &&
                !v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 1)) &&
                !v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 2)) &&
                !v
                    .get("tags")
                    .toString()
                    .contains(sortedMap.keys.elementAt(sortedMap.length - 3))) {
              Meal newMeal = Meal(
                  id: v.id,
                  name: v.get("name"),
                  description: v.get("description"),
                  time: v.get("preparationtime"),
                  price: v.get("price"),
                  tags: v.get("tags"),
                  kitchenOwnerId: v.get("kitchenownerid"),
                  img: v.get("img"));

              tempList.add(newMeal);
              i++;
            }
            afterRecomendedMealLoaded++;
          }
        });
      }
    }
    print(tempList.length.toString() + "wwwwwwww");
    list.addAll(tempList);
    return list;
  }

  Map<String, int> sortedMap = {};
  void sort() {
    sortedMap = Map.fromEntries(recomendatinSysytem.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));
  }

  Future<List<Meal>> searchMeal(String search) async {
    var temp = await firebaseFirestore.collection("Meal").get();
    print(search);
    List<Meal> list = [];
    for (var v in temp.docs) {
      print(v.get("name"));
      if (v.get("name").toLowerCase().contains(search.toLowerCase()) ||
          v.get("tags").toLowerCase().contains(search.toLowerCase())) {
        print(v.get("name") + " ...................");
        Meal newMeal = Meal(
            id: v.id,
            name: v.get("name"),
            description: v.get("description"),
            time: v.get("preparationtime"),
            price: v.get("price"),
            tags: v.get("tags"),
            kitchenOwnerId: v.get("kitchenownerid"),
            img: v.get("img"));

        list.add(newMeal);
      }
    }
    print(list.length);
    return list;
  }

  Future<List<Meal>> loadKitchenMealsForVisitor(String uidKitchen) async {
    var res = await firebaseFirestore
        .collection("Meal")
        .where("kitchenownerid", isEqualTo: uidKitchen)
        .get();
    print(uidKitchen);
    List<Meal> list = [];

    for (var v in res.docs) {
      Meal newMeal = Meal(
          id: v.id,
          name: v.get("name"),
          description: v.get("description"),
          time: v.get("preparationtime"),
          price: v.get("price"),
          tags: v.get("tags"),
          kitchenOwnerId: v.get("kitchenownerid"),
          img: v.get("img"));
      list.add(newMeal);
    }

    return list;
  }

  //recomanded
}

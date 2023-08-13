import 'package:flutter/material.dart';
import 'package:kotc/Controllers/databaseQuery.dart';
import 'package:kotc/classes/kitchen.dart';
import 'package:kotc/classes/meal.dart';

class DataController extends ChangeNotifier {
  DataBaseQuery dataBaseQuery = DataBaseQuery();

  List<Kitchen> listOfKitchenWillDisplay = [];
  List<Meal> listOfMealWillDisplay = [];

  Future<void> loadKitchens() async {
    listOfKitchenWillDisplay = await dataBaseQuery.loadKitchens();

    listOfKitchenWillDisplay.shuffle();
    notifyListeners();
  }

  int pageLength = 10;
  int mealLoaded = 0;

  Future<void> loadMeals() async {
    print(mealLoaded);
    listOfMealWillDisplay =
        await dataBaseQuery.loadMeals(pageLength, mealLoaded);
    mealLoaded = listOfMealWillDisplay.length;

    notifyListeners();
  }

  List<Meal> listOfMealSearch = [];

  Future<void> searchBar(String searchText) async {
    listOfMealSearch = [];
    notifyListeners();

    listOfMealSearch = await dataBaseQuery.searchMeal(searchText);

    notifyListeners();
  }

  List<Meal> listOfMealVisitorKitchen = [];
  Future<void> loadAllKitchenMealForVisitor(String uid) async {
    listOfMealVisitorKitchen =
        await dataBaseQuery.loadKitchenMealsForVisitor(uid);
    print(listOfMealVisitorKitchen.length);

    notifyListeners();
  }
}

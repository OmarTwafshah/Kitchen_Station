import 'package:flutter/material.dart';
import 'package:kotc/ItemsPatterns/itemFoodCardKitchenPageVisitor.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/classes/meal.dart';

// ignore: must_be_immutable
class AllMenu extends StatefulWidget {
  List<Meal> list;
  AllMenu({super.key, required this.list});

  @override
  State<AllMenu> createState() => _AllMenuState(list: list);
}

class _AllMenuState extends State<AllMenu> {
  List<Meal> list;
  _AllMenuState({required this.list});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
      ),
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.2,
            crossAxisCount: 2,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ItemFoodCardKitchenPageVisitor(
              meal: list[index],
            );
          },
        ),
      ),
    );
  }
}

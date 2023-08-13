import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/Controllers/recomendationModel.dart';

import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/favorite.dart';
import 'package:kotc/Pages/home.dart';
import 'package:kotc/Pages/myKitchen.dart';
import 'package:kotc/Pages/search.dart';
import 'package:kotc/Pages/stores.dart';
import 'package:kotc/main.dart';
import 'package:provider/provider.dart';

Map<String, int> recomendatinSysytem = {};
List<String> cartIds = [];

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  late DataController dataController;
  @override
  void initState() {
    dataController = Provider.of(context, listen: false);
    super.initState();
    loadRecomendationSystem();
  }

  void loadRecomendationSystem() async {
    recomendatinSysytem = await RecomendationModel.getData();
    dataController.loadMeals();
    dataController.loadKitchens();
  }

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController pageController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        buttonBackgroundColor: secondColor,
        color: secondColor,
        backgroundColor: lightColor,
        key: _bottomNavigationKey,
        onTap: (value) {
          pageController.jumpToPage(value);
        },
        animationDuration: const Duration(
          milliseconds: 300,
        ),
        items: [
          const SizedBox(
            child: Icon(
              size: 30,
              Icons.favorite,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                )
              ],
            ),
          ),
          const SizedBox(
            child: Icon(
              size: 30,
              Icons.search,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                )
              ],
            ),
          ),
          const SizedBox(
            child: Icon(
              size: 30,
              Icons.home,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                )
              ],
            ),
          ),
          const SizedBox(
            child: Icon(
              size: 30,
              Icons.store,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                )
              ],
            ),
          ),
          SizedBox(
            child: Icon(
              myKitchen == null ? Icons.settings : FontAwesomeIcons.kitchenSet,
              size: 30,
              color: Colors.white,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 1,
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: lightColor,
        ),
        child: Builder(builder: (context) {
          return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Favorite(),
                Search(),
                Home(),
                Stores(),
                MyKitchen(),
              ]);
        }),
      ),
    );
  }
}

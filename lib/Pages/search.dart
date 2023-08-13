import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/ItemsPatterns/itemFoodCardSearch.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/pageManager.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Timer? depounce;
  String lastSearch = "";
  bool isSearch = false;
  Map<String, int> sortedMap = {};
  void recomendedSortPriorty() {
    sortedMap = Map.fromEntries(recomendatinSysytem.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recomendedSortPriorty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DataController>(
        builder: (context, dataController, child) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      onChanged: (value) async {
                        if (value == ' ' || value.isEmpty) {
                          searchController.text = "";
                          setState(() {
                            isSearch = false;
                          });
                          return;
                        }
                        if (depounce?.isActive ?? false) depounce?.cancel();
                        depounce = Timer(
                          const Duration(milliseconds: 300),
                          () async {
                            if (lastSearch != searchController.text) {
                              lastSearch = value.trim();
                              //controller.loadControl(lastSearch, false);

                              await dataController.searchBar(lastSearch);
                              setState(() {
                                isSearch = true;
                              });
                            }
                          },
                        );
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minLines: 1,
                      controller: searchController,
                      decoration: InputDecoration(
                        label: Text(
                          "Search".tr,
                        ),
                        labelStyle: TextStyle(
                          color: secondColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            color: secondColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: secondColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                          borderSide: BorderSide(
                            width: 2,
                            color: secondColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                          borderSide: BorderSide(
                            width: 2,
                            color: secondColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: isSearch
                            ? MasonryGridView.count(
                                itemCount:
                                    dataController.listOfMealSearch.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 500
                                        ? 3
                                        : 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                itemBuilder: (context, index) {
                                  return ItemFoodCardSearch(
                                    index: index,
                                    list: dataController.listOfMealSearch,
                                  );
                                },
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 11,
                                        ),
                                        child: Text(
                                          "Varieties you may like".tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: secondColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 4 / 1,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount: sortedMap.length > 8
                                        ? 8
                                        : sortedMap.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            searchController.text = sortedMap
                                                .entries
                                                .elementAt(index)
                                                .key
                                                .toString();
                                            isSearch = true;
                                          });
                                          await dataController
                                              .searchBar(searchController.text);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color((math.Random()
                                                            .nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                                .withOpacity(.1)
                                                .withRed(255),
                                            border: Border.all(
                                              color:
                                                  secondColor.withOpacity(.6),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                25,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              sortedMap.entries
                                                  .elementAt(index)
                                                  .key
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color((math.Random()
                                                                  .nextDouble() *
                                                              0xFFFFFF)
                                                          .toInt())
                                                      .withOpacity(1)
                                                      .withRed(200),
                                                  shadows: const [
                                                    Shadow(
                                                      blurRadius: 1,
                                                      color: Colors.white,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ), //bahaa add the defaultpage
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

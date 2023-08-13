import 'package:flutter/material.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/ItemsPatterns/itemResturantsCard.dart';
import 'package:kotc/Pages/kitchenPage.dart';
import 'package:provider/provider.dart';

class Stores extends StatefulWidget {
  const Stores({super.key});

  @override
  State<Stores> createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     height: 55,
            //     child: TextField(
            //       onChanged: (value) {},
            //       textAlign: TextAlign.start,
            //       maxLines: 1,
            //       minLines: 1,
            //       controller: searchController,
            //       decoration: InputDecoration(
            //         label: Text(
            //           "Search".tr,
            //         ),
            //         labelStyle: TextStyle(
            //           color: secondColor,
            //         ),
            //         suffixIcon: IconButton(
            //           onPressed: () {
            //             setState(() {
            //               searchController.clear();
            //             });
            //           },
            //           icon: Icon(
            //             Icons.clear,
            //             color: secondColor,
            //           ),
            //         ),
            //         prefixIcon: Icon(
            //           Icons.search,
            //           color: secondColor,
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(
            //               20,
            //             ),
            //           ),
            //           borderSide: BorderSide(
            //             width: 2,
            //             color: secondColor,
            //           ),
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(
            //               20,
            //             ),
            //           ),
            //           borderSide: BorderSide(
            //             width: 2,
            //             color: secondColor,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Consumer<DataController>(
                builder: (context, value, child) => GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: false,
                  itemCount: value.listOfKitchenWillDisplay.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      KitchenPage(index: index),
                            ),
                          );
                        },
                        child: ItemResturantsCard(
                          index: index,
                        ));
                  },
                ),
              ),
            ),
            Container(
              height: 10,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

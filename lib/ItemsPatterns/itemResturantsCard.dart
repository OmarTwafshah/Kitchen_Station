import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ItemResturantsCard extends StatefulWidget {
  int index;
  ItemResturantsCard({super.key, required this.index});

  @override
  State<ItemResturantsCard> createState() =>
      // ignore: no_logic_in_create_state
      _ItemResturantsCardState(index: index);
}

class _ItemResturantsCardState extends State<ItemResturantsCard> {
  int index;
  _ItemResturantsCardState({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      width: 130,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey,
          ),
        ],
      ),
      child: Consumer<DataController>(
        builder: (context, value, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: value.listOfKitchenWillDisplay[index].img,
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
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                value.listOfKitchenWillDisplay[index].name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kotc/Pages/mealPage.dart';
import 'package:kotc/classes/meal.dart';

// ignore: must_be_immutable
class ItemFoodCardSearch extends StatefulWidget {
  int index;
  List<Meal> list;
  ItemFoodCardSearch({
    super.key,
    required this.index,
    required this.list,
  });

  @override
  State<ItemFoodCardSearch> createState() => _ItemFoodCardSearchState(
        index: index,
        list: list,
      );
}

class _ItemFoodCardSearchState extends State<ItemFoodCardSearch> {
  int index;
  List<Meal> list;
  _ItemFoodCardSearchState({
    required this.index,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double height =
        screenSize.width < 400 ? 200 : (screenSize.aspectRatio * 200) + 100;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MealPage(meal: list[index]),
            ));
      },
      child: Container(
        width: height * 0.65,
        height: height,
        margin: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 5,
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: height / 1.5,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: list[index].img,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 60,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        50,
                      ),
                    ),
                  ),
                  child: Text(
                    "${list[index].price}",
                    maxLines: 1,
                    style: GoogleFonts.inconsolata(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 50,
                  ),
                  child: AutoSizeText(
                    "ILS",
                    maxLines: 1,
                    style: GoogleFonts.inconsolata(
                      textStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: AutoSizeText(
                list[index].name,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Color.fromARGB(255, 84, 84, 84),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

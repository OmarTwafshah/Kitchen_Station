import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("image/jsonfiles/132642-fast-food.json"),
      ),
    );
  }
}

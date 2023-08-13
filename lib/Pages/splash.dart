import 'package:flutter/material.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/main.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  checkSign() async {
    bool check = await authController.checkSignin();

    String myKitchenId = await authController.checkIfUserHaveKitchen();
    if (myKitchenId == "No Kitchen") {
      myKitchen = null;
    } else {
      MyKitchenDataModel myKitchenDataModel = MyKitchenDataModel();
      await myKitchenDataModel.readKitchenInfo();
    }
    if (check) {
      bool admin = await authController.checkIfAdmin();
      if (admin) {
        Navigator.of(context).pushReplacementNamed("/dashboard");
      } else {
        Navigator.of(context).pushReplacementNamed("/pageManager");
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/sign");
    }
  }

  @override
  void initState() {
    super.initState();
    checkSign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "image/jsonfiles/18563-cooking.json",
        ),
      ),
    );
  }
}

import 'pcleanackage:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kotc/Controllers/authController.dart';
import 'package:kotc/Controllers/availableKitchenController.dart';
import 'package:kotc/Controllers/dataController.dart';
import 'package:kotc/Localization/localeController.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/Sign/sign.dart';
import 'package:kotc/Pages/addNewMeal.dart';
import 'package:kgit otc/Pages/cart.dart';
import 'package:kotc/Pages/AdminPages/dashboard.dart';
import 'package:kotc/Pages/pageManager.dart';
import 'package:kotc/Pages/requstRentRestaurant.dart';
import 'package:kotc/Pages/splash.dart';
import 'package:kotc/Models/myKitchen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Localization/myLocale.dart';

SharedPreferences? sharedPreferences;
AuthController authController = AuthController();
MyKitchen? myKitchen;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  LocaleController local = LocaleController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AvailableKitchenController(),
        ),
      ],
      child: GetMaterialApp(
        translations: MyLocale(),
        locale: local.initialLocale,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          tabBarTheme: TabBarTheme(
            labelColor: secondColor,
            labelStyle: GoogleFonts.alegreya(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.red,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/pageManager": (context) => const PageManager(),
          "/cart": (context) => const Cart(),
          "/sign": (context) => const Sign(),
          "/splash": (context) => const Splash(),
          "/requestRentRestaurant": (context) => const RequestRentRestaurant(),
          "/addNewMeal": (context) => const AddNewMeal(),
          "/dashboard": (context) => const Dashboard(),
        },
      ),
    );
  }
}

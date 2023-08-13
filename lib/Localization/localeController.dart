import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/main.dart';

class LocaleController extends GetxController {
  Locale? get initialLocale {
    if (sharedPreferences!.getString("lang") == null) {
      return Get.deviceLocale;
    } else {
      String? lang = sharedPreferences!.getString("lang");
      return Locale(lang!);
    }
  }

  void changeLocal(String newLang) {
    sharedPreferences!.setString("lang", newLang);
    Get.updateLocale(Locale(newLang));
  }
}

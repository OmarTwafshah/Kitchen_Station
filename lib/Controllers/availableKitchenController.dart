import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kotc/classes/availableKitchens.dart';
import 'package:kotc/main.dart';

class AvailableKitchenController extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<AvailableKitchens> listOfAvailableKitchen = [];

  Future<void> loadAvailableKitchen() async {
    var res = await firebaseFirestore.collection("Kitchen").get();
    listOfAvailableKitchen = [];
    for (var t in res.docs) {
      if (t.get("status") == "Available") {
        AvailableKitchens newA = AvailableKitchens(
          id: t.id,
          name: t.get("name"),
          description: t.get("description"),
          domainOrLocatonAndDomain: t.get("domainorlocatonanddomain"),
          status: t.get("status"),
          priceMonthly: t.get("pricepermonth"),
          priceYearly: t.get("priceperyear"),
        );

        listOfAvailableKitchen.add(newA);
      }
    }

    notifyListeners();
  }

  Future<void> sendRentRequest(String kitchenId) async {
    await firebaseFirestore
        .collection("RentRequest")
        .doc(authController.uid)
        .set({
      "kitchenId": kitchenId,
      "userId": authController.uid,
      "status": "Waiting for approval",
    });

    await firebaseFirestore.collection("Kitchen").doc(kitchenId).set({
      "status": "NotAvailable",
    }, SetOptions(merge: true));
  }

  //check

  Future<bool> checkIfIsendRequestOrNot() async {
    try {
      var res = await firebaseFirestore
          .collection("RentRequest")
          .doc(authController.uid)
          .get();
      String str = res.get("status");
      if (str == "Waiting for approval") {
        return false;
      }
    } catch (e) {
      return true;
    }

    return true;
  }
}

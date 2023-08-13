import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kotc/classes/availableKitchens.dart';
import 'package:kotc/classes/rentRequestClass.dart';
import 'package:kotc/classes/user.dart';

class AdminDataController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<RentRequestClass>> getRenRequests() async {
    var result = await firebaseFirestore.collection("RentRequest").get();

    List<RentRequestClass> list = [];

    for (var k in result.docs) {
      if (await k.get("status") == "Waiting for approval") {
        var userInfo = await firebaseFirestore
            .collection("User")
            .doc(await k.get("userId"))
            .get();

        UserInfoOwn user = UserInfoOwn(
          id: userInfo.id,
          email: userInfo.get("email"),
          kitchen: userInfo.get("myKitchenId"),
          name: userInfo.get("name"),
          phone: userInfo.get("phonenumber"),
          position: userInfo.get("position"),
          dateOfBirth: userInfo.get("dateOfBirth"),
        );

        var kitchenInfo = await firebaseFirestore
            .collection("Kitchen")
            .doc(await k.get("kitchenId"))
            .get();

        AvailableKitchens kitchen = AvailableKitchens(
          id: kitchenInfo.id,
          name: kitchenInfo.get("name"),
          description: kitchenInfo.get("description"),
          domainOrLocatonAndDomain: kitchenInfo.get("domainorlocatonanddomain"),
          status: kitchenInfo.get("status"),
          priceMonthly: kitchenInfo.get("pricepermonth"),
          priceYearly: kitchenInfo.get("priceperyear"),
        );
        RentRequestClass rrc = RentRequestClass(user: user, kitchen: kitchen);
        list.add(rrc);
      }
    }

    return list;
  }

  Future<void> generateKitchenAdmin(
    String userID,
    String kitchenID,
  ) async {
    await firebaseFirestore.collection("CustomerKitchen").doc(userID).set({
      "kitchenId": kitchenID,
      "kitchenName": "The Kitchen",
      "open": false,
      "profileImg":
          "https://firebasestorage.googleapis.com/v0/b/cloud-kitchen-a0b6d.appspot.com/o/KitchensProfilePhoto%2Fckdesign-thekitchen-logo-final-color.webp?alt=media&token=fc3b66ea-d4cb-4281-83b1-6d3c94ab95df&_gl=1*103yioa*_ga*Nzk2MTU1MzkyLjE2NTA5NzE0MzY.*_ga_CW55HF8NVT*MTY4NTQyOTY2Ny41LjEuMTY4NTQzMzI1OS4wLjAuMA..",
    });

    await firebaseFirestore.collection("Kitchen").doc(kitchenID).set(
      {"status": "NotAvailable"},
      SetOptions(
        merge: true,
      ),
    );

    await firebaseFirestore.collection("User").doc(userID).set(
      {
        "myKitchenId": kitchenID,
      },
      SetOptions(
        merge: true,
      ),
    );

    await firebaseFirestore.collection("RentRequest").doc(userID).set(
      {
        "status": "Accept",
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> rejectRequest(
    String userID,
    String kitchenID,
  ) async {
    await firebaseFirestore.collection("RentRequest").doc(userID).set(
      {
        "status": "Reject",
      },
      SetOptions(
        merge: true,
      ),
    );
    await firebaseFirestore.collection("Kitchen").doc(kitchenID).set({
      "status": "Available",
    }, SetOptions(merge: true));
  }

  // ADD NEW KITCHEN

  Future<void> addNewKitchen(
    String name,
    String description,
    String domainorlocatonanddomain,
    String priceMonthly,
    String priceYearly,
  ) async {
    await firebaseFirestore.collection("Kitchen").add({
      "name": name,
      "description": description,
      "domainorlocatonanddomain": domainorlocatonanddomain,
      "pricepermonth": priceMonthly,
      "priceperyear": priceYearly,
      "status": "Available",
    });
  }
}

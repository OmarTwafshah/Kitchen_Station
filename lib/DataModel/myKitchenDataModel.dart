import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kotc/classes/meal.dart';
import 'package:kotc/main.dart';
import 'package:kotc/Models/myKitchen.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

//هذا الكلاس لقراءة وكتابة وتعديل معلومات المطعم من  قبل صاحب المطعم أي المستأجر
class MyKitchenDataModel {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//kitchen profile image
  Future<void> setImageProfile(File file) async {
    UploadTask uploadTask;
    List<String> fileName = basename(file.path).split(".");
    // var uuid = const Uuid();
    var imgSpace = firebaseStorage.ref().child(
        "KitchensProfilePhoto/userid${authController.uid}.${fileName[fileName.length - 1]}");
    uploadTask = imgSpace.putFile(file);
    await uploadTask.whenComplete(() => {});
    String url = await imgSpace.getDownloadURL();

    await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .set({
      "profileImg": url,
    }, SetOptions(merge: true));
  }

  Future<String> readProfileImg() async {
    var map = await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .get();
    return map.get("profileImg");
  }

  //kitchen profile name

  Future<void> setNameProfile(String name) async {
    await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .set({
      "kitchenName": name,
    }, SetOptions(merge: true));
  }

  Future<String> readProfileName() async {
    var map = await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .get();
    return map.get("kitchenName");
  }

  //read all Kitchen info
  Future<void> readKitchenInfo() async {
    var map = await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .get();

    String name = map.get("kitchenName");
    String imgPath = map.get("profileImg");
    bool open = map.get("open");

    myKitchen = MyKitchen();
    myKitchen!.name = name;
    myKitchen!.imgPath = imgPath;
    myKitchen!.kitchenId = authController.uid;
    myKitchen!.open = open;
  }

  Future<void> setOpenClose(bool temp) async {
    await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(authController.uid)
        .set(
      {
        "open": temp,
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  //meals settings

  Future<void> addNewMeal(
    String name,
    String description,
    String time,
    double price,
    String tags,
    String img,
  ) async {
    var respons = await firebaseFirestore.collection("Meal").add({
      "name": name,
      "description": description,
      "preparationtime": "$time min",
      "price": price,
      "tags": tags,
      "kitchenownerid": myKitchen?.kitchenId,
      "img": img,
    });

    await firebaseFirestore
        .collection("CustomerKitchen")
        .doc(myKitchen?.kitchenId)
        .collection("OurMealPaths")
        .add({"path": respons.id});
  }

  Future<String> setImageMeal(File file) async {
    UploadTask uploadTask;
    List<String> fileName = basename(file.path).split(".");
    var uuid = const Uuid();
    var imgSpace = firebaseStorage.ref().child(
        "KitchenMealPhoto/${uuid.v4()}.${fileName[fileName.length - 1]}");
    uploadTask = imgSpace.putFile(file);
    await uploadTask.whenComplete(() => {});
    String url = await imgSpace.getDownloadURL();

    return url;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      getAllMyMealForMyKitchen() async {
    var respons = firebaseFirestore
        .collection("Meal")
        .where("kitchenownerid", isEqualTo: myKitchen?.kitchenId)
        .snapshots();

    return respons;
    // List<Meal> list = [];
    // for (var v in respons.docs) {
    //   Meal m = Meal(
    //       id: v.id,
    //       name: v.get("name"),
    //       description: v.get("description"),
    //       time: v.get("preparationtime"),
    //       price: v.get("price"),
    //       tags: v.get("tags"),
    //       kitchenOwnerId: v.get("kitchenownerid"),
    //       img: v.get("img"));

    //   list.add(m);
    // }

    // return list;
  }

  Future<void> deleteMeal(String img, String id) async {
    try {
      String fileUrl = img;

      String filePath = fileUrl.replaceAll(
          RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/cloud-kitchen-a0b6d.appspot.com/o/'),
          '');

      filePath = filePath.replaceAll(RegExp(r'%2F'), '/');

      filePath = filePath.replaceAll(RegExp(r'(\?alt).*'), '');

      var imgTarget = firebaseStorage.ref().child(filePath);

      await imgTarget.delete();
    } catch (e) {}

    await firebaseFirestore.collection("Meal").doc(id).delete();
  }
}

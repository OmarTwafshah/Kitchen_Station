import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotc/Controllers/availableKitchenController.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/Pages/editMenu.dart';
import 'package:kotc/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../Localization/localeController.dart';

class MyKitchen extends StatefulWidget {
  const MyKitchen({super.key});

  @override
  State<MyKitchen> createState() => _MyKitchenState();
}

class _MyKitchenState extends State<MyKitchen> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedPhoto;
  ImagePicker imagePicker = ImagePicker();
  MyKitchenDataModel myKitchenDataModel = MyKitchenDataModel();
  TextEditingController nameController = TextEditingController();
  LocaleController localeController = LocaleController();
  Border borderStyle = Border.all(
    color: const Color.fromARGB(255, 255, 255, 255),
    width: 1,
  );

  Color fontColor = const Color.fromARGB(255, 66, 66, 66);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (myKitchen != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: secondColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Settings".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 80,
                              child: Image.asset(
                                "image/icons/settings.png",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      "GENERAL".tr,
                      style: TextStyle(
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {},
                          leading: const Icon(
                            Icons.text_fields,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Change Name".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {},
                          leading: const Icon(
                            Icons.password,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Change Password".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () async {
                            try {
                              await authController.signout();
                              Navigator.of(context)
                                  .pushReplacementNamed("/sign");
                              // ignore: empty_catches
                            } catch (e) {}
                          },
                          leading: const Icon(
                            Icons.logout,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Logout".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        height: 150,
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                localeController
                                                    .changeLocal("en");
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "English",
                                                style: TextStyle(
                                                    color: secondColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                localeController
                                                    .changeLocal("ar");
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "عربي",
                                                style: TextStyle(
                                                    color: secondColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          leading: const Icon(
                            Icons.language,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Language".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: screenSize.height / 3.5),
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20,
                  ),
                  bottomRight: Radius.circular(
                    20,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: "${myKitchen!.imgPath}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    //  Image.network(
                    //                       "${myKitchen!.imgPath}",
                    //                       errorBuilder: (context, error, stackTrace) {
                    //                         return Center(
                    //                           child: Text(
                    //                             "${myKitchen!.imgPath}".tr,
                    //                           ),
                    //                         );
                    //                       },
                    //                     ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 20,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          try {
                            selectedPhoto = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            CroppedFile? croppedFile =
                                await croppedFileMethod(selectedPhoto!.path);
                            await myKitchenDataModel
                                .setImageProfile(File(croppedFile!.path));

                            myKitchen!.imgPath =
                                await myKitchenDataModel.readProfileImg();
                            setState(() {});
                          } catch (e) {}
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    30,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(59, 0, 0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
              margin: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 10,
                bottom: 10,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "${myKitchen!.name}",
                      style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: SizedBox(
                      height: 28,
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.pen,
                          size: 20,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  height: 200,
                                  width: 300,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            hintText: "Enter here".tr,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            secondColor,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (nameController.text.isNotEmpty) {
                                            await myKitchenDataModel
                                                .setNameProfile(
                                                    nameController.text);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Text(
                                          "Done".tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          myKitchen!.name =
                              await myKitchenDataModel.readProfileName();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    width: 200,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 233, 30, 98),
                          Color.fromARGB(255, 244, 67, 54),
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Total Price".tr,
                                style: const TextStyle(
                                  color: Color.fromARGB(233, 255, 255, 255),
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            SizedBox(
                              width: 40,
                              child: Image.asset(
                                "image/graph/graph.png",
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(
                              flex: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "579 ILS".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    width: 200,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Color.fromARGB(255, 121, 166, 244),
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Total Orders".tr,
                                style: const TextStyle(
                                  color: Color.fromARGB(233, 255, 255, 255),
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            SizedBox(
                              width: 40,
                              child: Image.asset(
                                "image/graph/graph.png",
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(
                              flex: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "16".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //options _____________________________________________________________________
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //Orders
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(Random().nextInt(0xffffff))
                              .withBlue(240)
                              .withOpacity(1),
                          Color(Random().nextInt(0xffffff))
                              .withBlue(255)
                              .withOpacity(1),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          4,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.email,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Orders Request".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(255, 95, 95, 95),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  //Orders
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(Random().nextInt(0xffffff))
                              .withGreen(240)
                              .withOpacity(1),
                          Color(Random().nextInt(0xffffff))
                              .withGreen(255)
                              .withOpacity(1),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          4,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.warehouse,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Warehouse".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(255, 95, 95, 95),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  //Edit menu
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const EditMenu(),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(Random().nextInt(0xffffff))
                                .withRed(240)
                                .withOpacity(1),
                            Color(Random().nextInt(0xffffff))
                                .withRed(255)
                                .withOpacity(1),
                          ],
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            4,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.list,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Edit Menu".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 95, 95, 95),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Open || Close
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                bool temp = myKitchen!.open ?? true;
                setState(() {
                  myKitchen!.open = !temp;
                });
                await myKitchenDataModel.setOpenClose(!temp);
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      5,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: myKitchen!.open ?? true
                        ? [
                            Colors.green,
                            Colors.lightGreen,
                          ]
                        : [
                            Colors.red,
                            Colors.redAccent,
                          ],
                  ),
                ),
                child: Center(
                  child: Text(
                    myKitchen!.open ?? true ? "Open".tr : "Close".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 100,
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: secondColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Settings".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 80,
                              child: Image.asset(
                                "image/icons/settings.png",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      "GENERAL".tr,
                      style: TextStyle(
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {},
                          leading: const Icon(
                            Icons.text_fields,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Change Name".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {},
                          leading: const Icon(
                            Icons.password,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Change Password".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () async {
                            try {
                              await authController.signout();
                              Navigator.of(context)
                                  .pushReplacementNamed("/sign");
                              // ignore: empty_catches
                            } catch (e) {}
                          },
                          leading: const Icon(
                            Icons.logout,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Logout".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                        ListTile(
                          iconColor: fontColor,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        height: 150,
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                localeController
                                                    .changeLocal("en");
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "English",
                                                style: TextStyle(
                                                    color: secondColor),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                localeController
                                                    .changeLocal("ar");
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "عربي",
                                                style: TextStyle(
                                                    color: secondColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          leading: const Icon(
                            Icons.language,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          title: Text(
                            "Language".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: fontColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      "KITCHEN".tr,
                      style: TextStyle(
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        Consumer<AvailableKitchenController>(
                          builder: (context, value, child) => ListTile(
                            iconColor: fontColor,
                            onTap: () async {
                              value.listOfAvailableKitchen.clear();
                              value.loadAvailableKitchen();

                              if (await value.checkIfIsendRequestOrNot()) {
                                Navigator.of(context)
                                    .pushNamed("/requestRentRestaurant");
                              } else {
                                Get.snackbar(
                                  "",
                                  "You have already submitted a request to rent a restaurant Wait for it to be approved"
                                      .tr,
                                  colorText: Colors.white,
                                  duration: const Duration(
                                    seconds: 5,
                                  ),
                                );
                              }
                            },
                            leading: const Icon(
                              FontAwesomeIcons.kitchenSet,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            title: Text(
                              "Rent Kitchen".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: fontColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<int> getPermission(Permission permission) async {
    var request = await permission.request();
    if (request.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<CroppedFile?> croppedFileMethod(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
            activeControlsWidgetColor: secondColor,
            toolbarTitle: 'Edit Size',
            toolbarColor: secondColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Edit Size',
        ),
        // ignore: use_build_context_synchronously
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return croppedFile;
  }
}

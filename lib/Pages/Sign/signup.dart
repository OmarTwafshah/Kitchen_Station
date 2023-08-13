import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/Localization/localeController.dart';

import 'package:kotc/main.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwdTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  // MyKitchenDataModel myKitchenDataModel = MyKitchenDataModel();
  // AuthController authController = AuthController();
  bool hud = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: hud,
      child: Container(
        child: ListView(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Lottie.asset("image/jsonfiles/122311-boiling-pot.json"),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                controller: nameTextEditingController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.text_fields,
                  ),
                  label: Text(
                    "name".tr,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailTextEditingController,
                decoration: InputDecoration(
                  suffix: emailTextEditingController.text.trim().isEmail
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                        ),
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                  label: Text(
                    "email".tr,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                obscureText: true,
                controller: passwdTextEditingController,
                decoration: InputDecoration(
                  hintText: "At least 8 digits".tr,
                  suffix: passwdTextEditingController.text.trim().length >= 8
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                        ),
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  label: Text(
                    "password".tr,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: phoneTextEditingController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone,
                  ),
                  label: Text(
                    "phone".tr,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                setState(() {
                  hud = true;
                });

                if (nameTextEditingController.text.trim().isEmpty ||
                    emailTextEditingController.text.trim().isEmpty ||
                    passwdTextEditingController.text.trim().isEmpty ||
                    phoneTextEditingController.text.trim().isEmail) {
                  Get.snackbar("Somthing is empty", "check you inputs");
                  setState(() {
                    hud = false;
                  });
                  return;
                }
                if (passwdTextEditingController.text.trim().length < 8) {
                  Get.snackbar("", "Password is too short!");
                  setState(() {
                    hud = false;
                  });
                } else {
                  try {
                    bool checkEmail = await authController.signupEmail(
                      nameTextEditingController.text.trim(),
                      emailTextEditingController.text.trim(),
                      passwdTextEditingController.text.trim(),
                    );
                    if (checkEmail) {
                      await authController
                          .generateId(phoneTextEditingController.text.trim());
                      setState(() {
                        nameTextEditingController.clear();
                        passwdTextEditingController.clear();
                        emailTextEditingController.clear();
                        phoneTextEditingController.clear();
                        hud = false;
                      });
                      String myKitchenId =
                          await authController.checkIfUserHaveKitchen();
                      if (myKitchenId == "No Kitchen") {
                        myKitchen = null;
                      } else {
                        MyKitchenDataModel myKitchenDataModel =
                            MyKitchenDataModel();
                        await myKitchenDataModel.readKitchenInfo();
                      }
                      Navigator.of(context)
                          .pushReplacementNamed("/pageManager");
                      Navigator.of(context)
                          .pushReplacementNamed("/pageManager");
                    } else {
                      Get.snackbar("", "This email already exist");

                      setState(() {
                        hud = false;
                      });
                    }
                  } catch (e) {
                    Get.snackbar("Somthing wrong", "check you inputs");
                    setState(() {
                      hud = false;
                    });
                  }
                }
              },
              child: Text(
                "Signup".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

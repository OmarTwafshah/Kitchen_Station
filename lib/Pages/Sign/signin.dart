import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/Material/colors.dart';
import 'package:kotc/main.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwdTextEditingController = TextEditingController();
  // AuthController authController = AuthController();
  TextEditingController resetPassTextEditingController =
      TextEditingController();

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
              child: Lottie.asset(
                  "image/jsonfiles/75820-chef-showing-the-burger.json"),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailTextEditingController,
                decoration: InputDecoration(
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
                obscureText: true,
                controller: passwdTextEditingController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  label: Text(
                    "password".tr,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                await authController.checkSignin();
                setState(() {
                  hud = true;
                });

                if (emailTextEditingController.text.isEmpty ||
                    !emailTextEditingController.text.isEmail ||
                    passwdTextEditingController.text.isEmpty) {
                  Get.snackbar("Somthing wrong", "check you inputs");
                  setState(() {
                    hud = false;
                  });
                  return;
                }
                try {
                  bool trysign = await authController.signinEmail(
                    emailTextEditingController.text,
                    passwdTextEditingController.text,
                  );
                  if (trysign) {
                    setState(() {
                      passwdTextEditingController.clear();
                      emailTextEditingController.clear();
                      hud = false;
                    });
                    bool admin = await authController.checkIfAdmin();
                    if (admin) {
                      Navigator.of(context).pushReplacementNamed("/dashboard");
                    } else {
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
                    }
                  } else {
                    setState(() {
                      hud = false;
                    });
                    Get.snackbar(
                        "Somthing wrong", "email or password is wrong!");
                  }
                } catch (e) {
                  Get.snackbar("Somthing wrong", "check you inputs");
                  setState(() {
                    hud = false;
                  });
                }
              },
              child: Text(
                "Login".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextField(
                                  controller: resetPassTextEditingController,
                                  decoration:
                                      InputDecoration(label: Text("Email".tr)),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (resetPassTextEditingController
                                        .text.isNotEmpty) {
                                      if (resetPassTextEditingController
                                          .text.isEmail) {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                          email: resetPassTextEditingController
                                              .text
                                              .trim(),
                                        );

                                        Navigator.of(context).pop();
                                        Get.snackbar("",
                                            "request sent \nYou can check your email",
                                            backgroundColor: Colors.white);
                                      } else {
                                        Get.snackbar(
                                            "", "The entered email is invalid",
                                            backgroundColor: Colors.white);
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: secondColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          5,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Send".tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
              },
              child: Text(
                "Forget password".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

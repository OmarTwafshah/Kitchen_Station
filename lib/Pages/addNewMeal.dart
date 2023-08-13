import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotc/Categories/listOfTags.dart';
import 'package:kotc/DataModel/myKitchenDataModel.dart';
import 'package:kotc/Material/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddNewMeal extends StatefulWidget {
  const AddNewMeal({super.key});

  @override
  State<AddNewMeal> createState() => _AddNewMealState();
}

class _AddNewMealState extends State<AddNewMeal> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedPhoto;
  ImagePicker imagePicker = ImagePicker();
  List<bool> tagsChoosenList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  MyKitchenDataModel myKitchenDataModel = MyKitchenDataModel();
  CroppedFile? croppedFile;
  bool modalHUD = false;
  setAllListItemFalse() {
    tagsChoosenList = [];
    for (int i = 0; i < Tags.ListPfTags().length; i++) {
      tagsChoosenList.add(false);
    }
  }

  int numOfTagsChoose() {
    int count = 0;
    for (int i = 0; i < tagsChoosenList.length; i++) {
      if (tagsChoosenList[i]) {
        count++;
      }
    }
    return count;
  }

  bool checkIfChoosenOrNot(int index) {
    return tagsChoosenList[index];
  }

  @override
  void initState() {
    setAllListItemFalse();
    super.initState();
  }

  InputDecoration inputDecoration({String? label, String? suffex}) =>
      InputDecoration(
        label: Text(label!),
        suffix: Text(
          suffex ?? "",
          style: TextStyle(
            color: secondColor,
          ),
        ),
        labelStyle: TextStyle(
          color: secondColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
          borderSide: BorderSide(
            width: 2,
            color: secondColor,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalHUD,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                try {
                                  selectedPhoto = await imagePicker.pickImage(
                                      source: ImageSource.gallery);
                                  croppedFile = await croppedFileMethod(
                                      selectedPhoto!.path);

                                  setState(() {});
                                } catch (e) {}
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: secondColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Choose Image".tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: croppedFile == null
                                  ? Center(child: Text("No Img".tr))
                                  : Image.file(File(croppedFile!.path)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: inputDecoration(
                            label: "name".tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: inputDecoration(
                            label: "Description".tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: timeController,
                          decoration: inputDecoration(
                            label: "Preparation Time".tr,
                            suffex: "min",
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          decoration: inputDecoration(
                            label: "Price".tr,
                            suffex: "ILS".tr,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${"Tags".tr} :",
                          style: GoogleFonts.robotoCondensed(
                            textStyle: TextStyle(
                              color: secondColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        for (int i = 0; i < Tags.ListPfTags().length; i++)
                          InkWell(
                            onTap: () {
                              setState(() {
                                tagsChoosenList[i] = !tagsChoosenList[i];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(
                                3,
                              ),
                              padding: checkIfChoosenOrNot(i)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    )
                                  : const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: checkIfChoosenOrNot(i)
                                      ? Colors.green
                                      : secondColor,
                                  width: checkIfChoosenOrNot(i) ? 3 : 2,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: Text(
                                Tags.ListPfTags()[i],
                                style: TextStyle(
                                  color: checkIfChoosenOrNot(i)
                                      ? Colors.green
                                      : secondColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 1,
                  right: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          modalHUD = true;
                        });

                        if (nameController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            timeController.text.isNotEmpty &&
                            priceController.text.isNotEmpty) {
                          if (numOfTagsChoose() < 1) {
                            Get.snackbar(
                              "",
                              "At least one tag must be selected",
                              colorText: Colors.white,
                            );
                          } else {
                            if (croppedFile == null) {
                              Get.snackbar(
                                "",
                                "Choose a picture of the meal",
                                colorText: Colors.white,
                              );
                            } else {
                              try {
                                double price =
                                    double.parse(priceController.text.trim());
                                String tags = "";
                                for (int i = 0;
                                    i < tagsChoosenList.length;
                                    i++) {
                                  if (tagsChoosenList[i]) {
                                    tags += "${Tags.ListPfTags()[i]},";
                                  }
                                }
                                String url = await myKitchenDataModel
                                    .setImageMeal(File(croppedFile!.path));

                                tags = tags.substring(0, tags.length - 1);
                                myKitchenDataModel.addNewMeal(
                                  nameController.text.trim(),
                                  descriptionController.text.trim(),
                                  timeController.text.trim(),
                                  price,
                                  tags,
                                  url,
                                );

                                setState(() {
                                  nameController.clear();
                                  descriptionController.clear();
                                  timeController.clear();
                                  priceController.clear();
                                  setAllListItemFalse();
                                  croppedFile = null;
                                });
                              } catch (e) {
                                Get.snackbar(
                                  "",
                                  "Make sure the price is a number",
                                  colorText: Colors.white,
                                );
                              }
                            }
                          }
                        } else {
                          Get.snackbar(
                            "",
                            "A value must be added to all fields".tr,
                            colorText: Colors.white,
                          );
                        }
                        setState(() {
                          modalHUD = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "ADD".tr,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<CroppedFile?> croppedFileMethod(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio7x5
      ],
      uiSettings: [
        AndroidUiSettings(
            activeControlsWidgetColor: secondColor,
            toolbarTitle: 'Edit Size',
            toolbarColor: secondColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
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

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:card_app/controllers/userdata_controller.dart';
import 'package:card_app/resources/firebase_storage.dart';
import 'package:card_app/screens/profile_screen.dart';
import 'package:card_app/widgets/my_widgets.dart';
import 'package:card_app/widgets/utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/colors.dart';

// ignore: must_be_immutable
class UserDataScreen extends StatefulWidget {
  UserDataScreen({Key? key}) : super(key: key);

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  UserDataController userDataController = Get.put(UserDataController());

  var arguments = Get.arguments;
  File? photo;
  String url =
      "https://www.csircmc.res.in/sites/default/files/default_images/default_man_photo.jpg";
  @override
  void initState() {
    super.initState();
    if (arguments[0]) {
      userDataController.name.text = arguments[1];
      userDataController.country.text = arguments[2];
      userDataController.description.text = arguments[3];
      userDataController.city.text = arguments[4];
      userDataController.age.text = arguments[7];
    }
  }

  setProfile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      photo = File(pickedFile.path);
    });
    try {
      if (photo != null) {
        url = await Storage().uploadImageToStorage("profilephoto", photo!);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  bool isLoading = false;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Future<void> updateUser(String? profileImage) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "image": profileImage,
      "userName": userDataController.name.text,
      "age": userDataController.age.text,
      'locationDetails':
          '${userDataController.city.text}_${userDataController.selectedCountry.value.name}',
      'country': userDataController.selectedCountry.value.flagEmoji,
    }).whenComplete(() {
      Get.offNamed('/select-role-screen', arguments: [false, '', '', false]);
    });

    setState(() {
      isLoading = false;
    });
  }

  updateTheValue() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      "userName": userDataController.name.text,
      "age": userDataController.age.text,
      'locationDetails':
          '${userDataController.city.text}_${userDataController.selectedCountry.value.name}',
      'country': userDataController.country.text,
    }).whenComplete(() {
      Get.to(() => const ProfileScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: height * .05),
                    arguments[0]
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              Container(
                                height: 4,
                                width: width * .25,
                                color: Colors.black,
                              ),
                              Container(
                                height: 4,
                                width: width * .25,
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                height: 4,
                                width: width * .25,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                    SizedBox(height: height * .05),
                    const Text(
                      'Crée votre profil',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: MyColors.newTextColor,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    arguments[0]
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              setProfile();
                            },
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade400,
                              child: CircleAvatar(
                                backgroundImage: photo != null
                                    ? FileImage(File(photo!.path))
                                    : null,
                                radius: 53,
                                child: photo == null
                                    ? const Text(
                                        "+ pic",
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : null,
                              ),
                            ),
                          )
                  ],
                ),
                SizedBox(height: height * 0.03),
                Form(
                  key: userDataController.userDataFormKey,
                  child: Column(
                    children: [
                      myTextFormFiled(
                        text: 'Nom',
                        controller: userDataController.name,
                        validator: userDataController.nameValidation(),
                      ),
                      SizedBox(height: height * 0.04),
                      myTextFormFiled(
                        inputType: TextInputType.number,
                        maxlines: 1,
                        text: 'Age',
                        controller: userDataController.age,
                        validator: userDataController.nameValidation(),
                      ),
                      SizedBox(height: height * 0.04),
                      myTextFormFiled(
                        icon: const Icon(Icons.arrow_downward),
                        ontap: () {
                          showCountryPicker(
                            // ignore: prefer_const_constructors
                            countryListTheme: CountryListThemeData(
                                bottomSheetHeight: Get.height * 0.7,
                                backgroundColor: Colors.grey),
                            context: context,
                            showPhoneCode:
                                true, // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              userDataController.country.text =
                                  country.flagEmoji;
                              userDataController.selectedCountry.value =
                                  country;
                            },
                          );
                        },
                        text: 'Pays',
                        controller: userDataController.country,
                        validator: userDataController.countryValidation(),
                      ),
                      SizedBox(height: height * 0.04),
                      myTextFormFiled(
                        text: 'Ville',
                        controller: userDataController.city,
                        validator: userDataController.cityValidation(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * .05),
                arguments[0]
                    ? MyElevatedButton(
                        child: const Text(
                          "mettre à jour",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: MyColors.backgroundColor,
                          ),
                        ),
                        onButtonPressed: () {
                          userDataController.updateUserData();
                        },
                      )
                    : Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.grey[350],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            updateUser(url);
                          },
                          child: userDataController.isLoading.isTrue
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : isLoading
                                  ? const Text(
                                      "wait...",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : const Text(
                                      "Next",
                                      style: TextStyle(color: Colors.black),
                                    ),
                        ),
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget myTextFormFiled({
  required String text,
  TextEditingController? controller,
  String? Function(String?)? validator,
  int? maxlines,
  TextInputType? inputType,
  Function()? ontap,
  Icon? icon,
}) {
  return TextFormField(
    onTap: ontap,
    validator: validator,
    controller: controller,
    maxLines: maxlines,
    keyboardType: inputType,
    style: const TextStyle(
      fontSize: 18,
      color: MyColors.newTextColor,
    ),
    decoration: InputDecoration(
      suffixIcon: icon,
      labelText: text,
      labelStyle: TextStyle(
        color: MyColors.newTextColor.withOpacity(0.7),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: MyColors.newTextColor,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
    ),
  );
}

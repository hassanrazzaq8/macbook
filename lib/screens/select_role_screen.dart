// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:card_app/controllers/role_controller.dart';
import 'package:card_app/controllers/userdata_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../modals/role_model.dart';
import '../widgets/my_widgets.dart';

class SelectRoleScreen extends StatefulWidget {
  SelectRoleScreen({Key? key}) : super(key: key);

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  RoleController roleController = Get.put(RoleController());
  UserDataController userDataController = Get.put(UserDataController());

  var arguments = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (arguments[0]) {
      switch (arguments[1]) {
        case "heart":
          roleController.selectedRoleIndex.value = 0;
          roleController.userSelectedRole.value = true;
          roleController.selectedRole = roleController.rolesList[0];
          break;
        case "spades":
          roleController.selectedRoleIndex.value = 1;
          roleController.userSelectedRole.value = true;
          roleController.selectedRole = roleController.rolesList[1];
          break;
        case "club":
          roleController.selectedRoleIndex.value = 2;
          roleController.userSelectedRole.value = true;
          roleController.selectedRole = roleController.rolesList[2];
          break;
        case "diamond":
          roleController.selectedRoleIndex.value = 3;
          roleController.userSelectedRole.value = true;
          roleController.selectedRole = roleController.rolesList[3];
          break;
      }
      userDataController.initialValue.value = arguments[1];
      userDataController.startValue.value = arguments[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * .1),
            arguments[0]
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: width * .25,
                        color: Colors.black,
                      ),
                      Container(
                        height: 5,
                        width: width * .25,
                        color: Colors.black,
                      ),
                      Container(
                        height: 5,
                        width: width * .25,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
            //title
            // Expanded(
            //     flex: 2,
            // child:
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 60, right: 50),
              child: SizedBox(
                width: Get.width,
                child: Center(
                  child: Text(
                    '''Choisissez votre
            Team''',
                    style: TextStyle(
                        fontSize: 20.r,
                        fontWeight: FontWeight.bold,
                        color: MyColors.newTextColor),
                  ),
                ),
              ),
            ),
            // selec role
            // Expanded(
            //   flex: 7,
            // child:
            Container(
              margin: EdgeInsets.all(15),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: roleController.rolesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return Obx(() => GestureDetector(
                        onTap: () => roleController.selectRole(index),
                        child: _gridItem(
                          role: roleController.rolesList[index],
                          isSelected:
                              roleController.selectedRoleIndex.value == index,
                          userSelectedRole:
                              roleController.userSelectedRole.value,
                        ),
                      ));
                },
              ),
            ),

            // desctiption
            // Expanded(
            //   flex: 4,
            //   child:
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      roleController
                          .rolesList[roleController.selectedRoleIndex.value]
                          .name
                          .split('*')
                          .first,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      roleController
                          .rolesList[roleController.selectedRoleIndex.value]
                          .name
                          .split('*')
                          .last,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    arguments[3]
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                              ),
                              width: double.infinity,
                              height: 50,
                              child: Obx(() {
                                return PopupMenuButton<String>(
                                  icon: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        userDataController.initialValue.value ==
                                                ''
                                            ? 'Niveau'
                                            : userDataController
                                                .initialValue.value,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                    ],
                                  ),
                                  initialValue:
                                      userDataController.initialValue.value,
                                  position: PopupMenuPosition.under,
                                  onSelected: userDataController.choiceAction,
                                  itemBuilder: (BuildContext context) {
                                    return userDataController.choices
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        //enabled: choice == "Recherche joueur pour" ? false : true,
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                );
                              }),
                            ),
                          ),
                    arguments[3]
                        ? const SizedBox.shrink()
                        : SizedBox(height: height * .04),
                    arguments[3]
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(0),
                                border: Border.all(color: Colors.grey.shade500),
                              ),
                              child: Obx(() {
                                return PopupMenuButton<String>(
                                  icon: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        userDataController.startValue.value ==
                                                ''
                                            ? 'Mode'
                                            : userDataController
                                                .startValue.value,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                    ],
                                  ),
                                  initialValue:
                                      userDataController.startValue.value,
                                  position: PopupMenuPosition.under,
                                  onSelected: userDataController.chooseValue,
                                  itemBuilder: (BuildContext context) {
                                    return userDataController.choose
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        //enabled: choice == "Recherche joueur pour" ? false : true,
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                );
                              }),
                            ),
                          ),
                    SizedBox(height: height * 0.03),
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
                              roleController.updateRole();
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
                                roleController.saveToDB(arguments[0]);
                              },
                              child:
                                  //  userDataController.isLoading.isTrue
                                  //     ? const CircularProgressIndicator(
                                  //         color: Colors.white,
                                  //       )
                                  roleController.isLoading.value == true
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
                    SizedBox(height: height * .05)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _gridItem(
    {required Role role,
    required bool isSelected,
    required bool userSelectedRole}) {
  return Padding(
    padding: const EdgeInsets.all(28.0),
    child: Container(
      decoration: userSelectedRole && isSelected
          ? BoxDecoration(
              border: Border.all(width: 3, color: MyColors.newTextColor),
              borderRadius: BorderRadius.circular(100),
            )
          : null,
      child: Center(
        child: SvgPicture.asset(
          role.image,
          color: role.color,
          height: 80,
          width: 80,
        ),
      ),
    ),
  );
}

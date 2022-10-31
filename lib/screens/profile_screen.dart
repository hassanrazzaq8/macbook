import 'dart:io';

import 'package:card_app/constant/colors.dart';
import 'package:card_app/controllers/profile_controller.dart';
import 'package:card_app/controllers/question_controller.dart';
import 'package:card_app/controllers/role_controller.dart';
import 'package:card_app/prects.dart';
import 'package:card_app/resources/firebase_storage.dart';
import 'package:card_app/screens/Situation_part/create_situation.dart';
import 'package:card_app/screens/Situation_part/situation_modify_card.dart';
import 'package:card_app/screens/select_role_screen.dart';
import 'package:card_app/widgets/follow_widget.dart';
import 'package:card_app/widgets/utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/like_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  // final String uid;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RoleController roleController = Get.put(RoleController());
  ProfileController profileController = Get.put(ProfileController());
  QuestionController questionController = Get.put(QuestionController());
  var personData = Get.arguments;
  var userItself = true;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  File? photo;
  String? url;
  File? photo2;
  String? url2;
  bool bannerUploading = false;
  bool profileUploading = false;
  var username;
  var userImage;
  Future getProfileImage() async {
    final pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (pickedFile == null) return;
    setState(() {
      photo = File(pickedFile.path);
    });
    try {
      setState(() {
        profileUploading = true;
      });
      if (photo != null) {
        url = await Storage().uploadImageToStorage("profilephoto", photo!);
      }
      updateProfileImage(url);
      setState(() {
        profileUploading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> updateProfileImage(String? profileImage) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
          "image": profileImage,
        })
        .then((value) => print('Data Added'))
        .catchError((e) => print('Failed to add data'));
  }

  Future<void> updateBannerImage(String? banner) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
          "bannerImage": banner,
        })
        .then((value) => print('Data Added'))
        .catchError((e) => print('Failed to add data'));
  }

  Future getBannerImage() async {
    final pickedFile2 =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (pickedFile2 == null) return;
    setState(() {
      photo2 = File(pickedFile2.path);
    });
    // if (photo != null) {
    //   url = await Storage().uploadImageToStorage("profilephoto", photo!);
    // }
    try {
      setState(() {
        bannerUploading = true;
      });
      if (photo2 != null) {
        url2 = await Storage().uploadImageToStorage("bannerPhoto", photo2!);
      }
      updateBannerImage(url2);
      setState(() {
        bannerUploading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    userItself = personData == null ? true : false;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: userItself
              ? Container()
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
          centerTitle: false,
          title:
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              Text(
            profileController.name.value,
            style: const TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          //     Text(
          //       "${profileController.locationDetails.value},${profileController.country.value}",
          //       style: const TextStyle(fontSize: 16, color: Colors.black),
          //     ),
          //   ],
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Text(
                profileController.flag.value,
                style: TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
        body: bannerUploading || profileUploading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            InkWell(
                              onTap: userItself
                                  ? () {
                                      getBannerImage();
                                    }
                                  : null,
                              child: Container(
                                width: double.infinity,
                                height: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: photo2 == null
                                          ? profileController
                                                      .bannerImage.value ==
                                                  ''
                                              ? const NetworkImage(
                                                  "https://www.heavymart.com/youritem.png")
                                              : NetworkImage(profileController
                                                  .bannerImage
                                                  .value) as ImageProvider
                                          : FileImage(File(photo2!.path)),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            SizedBox(height: Get.height * .08),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                profileController.description.value,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //Role
                                      InkWell(
                                        onTap: () {
                                          userItself
                                              ? Get.toNamed('/settings-screen',
                                                  arguments: [
                                                      true,
                                                      profileController
                                                          .name.value,
                                                      profileController
                                                          .flag.value,
                                                      profileController
                                                          .description.value,
                                                      profileController
                                                          .locationDetails
                                                          .value,
                                                      profileController
                                                          .level.value,
                                                      profileController
                                                          .mod.value,
                                                      profileController
                                                          .intersts,
                                                      profileController
                                                          .age.value,
                                                    ])
                                              : Get.toNamed(
                                                  '/message-screen',
                                                  arguments: [
                                                    personData['uId'],
                                                    personData['userName'],
                                                    personData['image'],
                                                  ],
                                                );
                                        },
                                        child: Column(
                                          children: [
                                            // Container(
                                            // width: 50,
                                            // height: 50,
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(
                                            //       width: 3,
                                            //       color: MyColors.newTextColor),
                                            //   borderRadius:
                                            //       BorderRadius.circular(100),
                                            // ),
                                            // child:
                                            userItself
                                                ? Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3,
                                                          color: MyColors
                                                              .newTextColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: const Icon(
                                                      Icons.settings,
                                                      size: 40,
                                                    ),
                                                  )
                                                : const CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "assets/images/chat.png"),
                                                    // backgroundColor: Colors.blue,
                                                    radius: 25,
                                                  ),

                                            userItself
                                                ? const Text(
                                                    'Paramètre',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  )
                                                : const Text(
                                                    'Message',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      userItself
                                          ? Column(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3,
                                                        color: MyColors
                                                            .newTextColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // if (userItself &&
                                                      //     !profileController
                                                      //         .roleEdited.value) {
                                                      //   // roleController.updateReturnRoute('/home-screen');
                                                      //   Get.toNamed(
                                                      //       '/select-role-screen',
                                                      //       arguments: [true]);
                                                      // }
                                                      Get.to(SelectRoleScreen(),
                                                          arguments: [
                                                            true,
                                                            profileController
                                                                .level.value,
                                                            profileController
                                                                .mod.value,
                                                            true,
                                                          ]);
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/icons/${profileController.role.value}.svg',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ),
                                                const Text(
                                                  'Team',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          : FollowWidget(
                                              userId: personData["uId"],
                                              snap: profileController.docc,
                                              isFollower: false,
                                            ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => Followers(
                                                uid: userItself
                                                    ? userId.toString()
                                                    : personData["uId"]
                                                        .toString(),
                                                snap: profileController.docc,
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color:
                                                        MyColors.newTextColor),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(Icons.group),
                                            ),
                                            const Text(
                                              'abones',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Get.height * .05),
                                const Text(
                                  "Info",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                deviderLine(
                                  Colors.grey.shade500,
                                ),
                                const SizedBox(height: 20),
                                // Text(
                                //   "À propos de ${profileController.name.value}",
                                // ),
                                RichText(
                                  text: TextSpan(
                                    text: 'À propos de ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: profileController.name.value,
                                        // style: const TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        //   color: Colors.black,
                                        // ),
                                      ),
                                      // TextSpan(text: ' world!'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  profileController.mod.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  profileController.level.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    text: 'âge ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: profileController.age.toString(),
                                        // style: const TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        //   color: Colors.black,
                                        // ),
                                      ),
                                      // TextSpan(text: ' world!'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Espère rencontrer",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                    child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: profileController.intersts.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      "${profileController.intersts[index]}, ",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                )),
                                SizedBox(height: Get.height * .05),
                                userItself
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          deviderLine(Colors.black),
                                          const SizedBox(height: 5),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CreateSituation(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              " cree une situation + ",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          deviderLine(Colors.black),
                                        ],
                                      )
                                    : const SizedBox.shrink(),

                                const SizedBox(height: 10),
                                const Text(
                                  "Situation",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                userItself
                                    ? StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .snapshots(),
                                        builder: (context, snapsho) {
                                          final snapp = snapsho.data!;

                                          if (snapsho.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          // return SituationCard(
                                          //   snapp: snapp,
                                          // uid: FirebaseAuth
                                          //     .instance.currentUser!.uid,
                                          //   isDone: userItself,
                                          // );
                                          return SituationModifyCard(
                                            snap: snapp,
                                            isUser: userItself,
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid,
                                          );
                                        })
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                        // Profile image
                        Positioned(
                          top:
                              100.0, // (background container size) - (circle height / 2)
                          child: Container(
                            height: 120.0,
                            width: 120.0,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: photo == null
                                          ? profileController.picture.value ==
                                                  '0'
                                              ? const NetworkImage(
                                                  "https://www.csircmc.res.in/sites/default/files/default_images/default_man_photo.jpg")
                                              : NetworkImage(profileController
                                                  .picture
                                                  .value) as ImageProvider
                                          : FileImage(File(photo!.path)),
                                    ),
                                  ),
                                ),
                                userItself
                                    ? Positioned(
                                        bottom: 6,
                                        left: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            getProfileImage();
                                          },
                                          child: ClipOval(
                                            child: Container(
                                              color: Colors.black,
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .all(8),
                                              child: const Icon(
                                                  Icons.add_a_photo,
                                                  size: 25,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Positioned(child: SizedBox()),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _rowItem(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 70,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            // color: Colors.grey[200],
            color: MyColors.backgroundColor.withOpacity(0.7),
          ),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: MyColors.newTextColor)),
          ),
        ),
        Container(
          height: 50,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.grey[200],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(data,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        )
      ],
    );
  }

  Widget deviderLine(Color c) {
    return Container(
      height: 2,
      width: double.infinity,
      color: c,
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

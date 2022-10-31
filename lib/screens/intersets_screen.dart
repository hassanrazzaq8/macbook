import 'package:card_app/controllers/interset_controller.dart';
import 'package:card_app/controllers/userdata_controller.dart';
import 'package:card_app/screens/Situation_part/widgets/alertdialoge.dart';
import 'package:card_app/screens/get_userdata_screen.dart';
import 'package:card_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widgets/my_widgets.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({Key? key}) : super(key: key);

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  IntersetController intersetController = Get.put(IntersetController());
  var arguments = Get.arguments;
  @override
  void initState() {
    super.initState();
    if (arguments[0]) {
      intersetController.description.text = arguments[1];
      intersetController.selectedItems.value = arguments[2];
    }
  }

  @override
  void dispose() {
    super.dispose();
    intersetController.description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0),
            child: Column(
              children: [
                SizedBox(height: h * .05),
                arguments[0]
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 4,
                            width: w * .25,
                            color: Colors.black,
                          ),
                          Container(
                            height: 4,
                            width: w * .25,
                            color: Colors.black,
                          ),
                          Container(
                            height: 4,
                            width: w * .25,
                            color: Colors.black,
                          ),
                        ],
                      ),
                SizedBox(height: h * .06),
                const Text(
                  "Vos Interets",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: h * .06),
                //
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Complétez votre biographie",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                myTextFormFiled(
                  controller: intersetController.description,
                  text: "description",
                ),
                SizedBox(height: h * .06),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Qu'espérez-vous trouver ?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Sélectionnez 3 options",
                    style: TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: h * .04),
                SizedBox(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;

                            intersetController.selectedItems
                                    .contains(items[index])
                                ? intersetController.selectedItems
                                    .remove(items[index])
                                : intersetController.selectedItems.length < 3
                                    ? intersetController.selectedItems
                                        .add(items[selectedIndex])
                                    : customAlertDialoge(
                                        context,
                                        "Sorry",
                                        "You cant select more than three",
                                        "ok",
                                      );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(),
                            color: intersetController.selectedItems
                                    .contains(items[index])
                                ? Colors.green
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            items[index],
                            style: TextStyle(
                              color: intersetController.selectedItems
                                      .contains(items[index])
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: h * .05),
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
                          intersetController.updateIt();
                          // print(intersetController.selectedItems.value);
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
                            intersetController.selectedItems.length < 3
                                ? customAlertDialoge(
                                    context,
                                    "Sorry",
                                    "Must Select 3 interstes",
                                    "ok",
                                  )
                                : addData();
                          },
                          child: isDone
                              ? const Text(
                                  "wait..",
                                  style: TextStyle(color: Colors.black),
                                )
                              : const Text(
                                  "Next",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                SizedBox(height: h * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  String uId = FirebaseAuth.instance.currentUser!.uid;
  bool isDone = false;
  addData() async {
    setState(() {
      isDone = true;
    });
    ref.doc(uId).update({
      "intersets": intersetController.selectedItems,
      "description": intersetController.description.text,
    }).whenComplete(() {
      Get.to(() => HomeScreen());
    });
    setState(() {
      isDone = false;
    });
  }

  int selectedIndex = 0;
  List<String> items = [
    "Une coloc Poker",
    "Des parties privées",
    "Des groupes de travail",
    "Des soirées poker Barbecue",
    "Des joueurs pour Des reviews de sessions",
    "Des joueurs pour préparer des sessions",
    "Des joueurs pour des voyages poker",
    "Des joueurs ambitieux",
    "Des joueurs pro",
    "Des joueurs régulier",
    "Des fishs",
    "Des joueurs sérieux",
    "Des conseils",
    "Un coach",
    "Des sponsors",
    "Des stackers",
    "Des joueurs a stacker",
    "Des joueurs pour Des reviews poker",
    "Des ranges d'open",
    "Le Jackpot",
    "Son âme soeur du poker",
    "Des copains poker",
  ];
}

import 'package:card_app/controllers/profile_controller.dart';
import 'package:card_app/screens/Situation_part/edit_situation.dart';
import 'package:card_app/screens/Situation_part/widgets/card_texts.dart';
import 'package:card_app/widgets/post_like.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Flop/values.dart';
import 'comment/comment_scren.dart';

class SituationModifyCard extends StatefulWidget {
  SituationModifyCard({
    Key? key,
    this.snap,
    required this.uid,
    required this.isUser,
  }) : super(key: key);
  final snap, uid;
  bool isUser;

  @override
  State<SituationModifyCard> createState() => _SituationModifyCardState();
}

class _SituationModifyCardState extends State<SituationModifyCard> {
  ProfileController profileController = Get.put(ProfileController());
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    return StreamBuilder(
        stream: firestore
            .collection("users")
            .doc(profileController.uid.value)
            .collection("Situations")
            .orderBy(
              "time",
              descending: true,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshottt) {
          if (snapshottt.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshottt.data!.docs.length,
              itemBuilder: (context, index) {
                final snapp = snapshottt.data!.docs[index].data();
                final count = snapshottt.data!.docs.length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    deviderLine(Colors.grey.shade600),
                    SizedBox(height: Get.height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapp["title"].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.isUser
                            ? Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18.0,
                                                      vertical: 18.0),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .20,
                                                // color: Colors.amber,
                                                // decoration: const BoxDecoration(
                                                //     borderRadius: BorderRadius.only(
                                                //   topLeft: Radius.circular(20),
                                                //   topRight: Radius.circular(20),
                                                // )),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.edit),
                                                        const SizedBox(
                                                            width: 5),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Get.to(
                                                                EditSituation(
                                                                    snap:
                                                                        snapp));
                                                          },
                                                          child: const Text(
                                                            "Modifier la situation",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.delete),
                                                        const SizedBox(
                                                            width: 5),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            alert(snapp[
                                                                "postId"]);
                                                          },
                                                          child: const Text(
                                                            "Eliminate",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Image.asset("assets/icons/dots.png"),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: h * .05),
                    RichText(
                      text: TextSpan(
                        text: '${snapp["gameMode"]} ',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Live, ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(text: ' ${snapp["noOfPlayers"]}'),
                          const TextSpan(
                            text: ' joueurs a la table,',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * .02),
                    Wrap(
                      children: [
                        const Text(
                          "j'ai",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapp["SimpleCardValue"].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapp["SimpleCardValue"][index]
                                                    ["title"],
                                                style: TextStyle(
                                                  color: Color(
                                                    snapp["SimpleCardValue"]
                                                        [index]["color"],
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child: Image.asset(
                                                    snapp["SimpleCardValue"]
                                                        [index]["image"],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        detail("Et je suis ", false),
                        detail("${snapp["position"]} ", true),
                        detail("avec un stack de ", false),
                        detail("${snapp["stack"]} ", true),
                        detail("sur des blindes ", false),
                        detail("${snapp["sb"]}-${snapp["bb"]} ", true),
                      ],
                    ),
                    SizedBox(height: h * .02),
                    deviderLine(Colors.grey.shade500),
                    SizedBox(height: h * .01),
                    const Text(
                      "Preflop",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: h * .02),
                    CardTexts(
                      snap: snapp,
                      jourrr: snapp["prejoueur"],
                      actiii: snapp["preaction"],
                      monttt: snapp["premontant"],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    snapp["flopjoueur"].isNotEmpty
                        ? Values(
                            title: "Flop",
                            snap: snapp,
                            cValue: snapp["FlopCardValue"],
                            sValue: snapp["TurnCardValue"],
                            fValue: snapp["FlopCardValue"],
                            flopPot: snapp["flopPot"],
                            turnPot: snapp["turnPot"],
                            riverPot: snapp["riverPot"],
                            jouu: snapp["flopjoueur"],
                            actt: snapp["flopaction"],
                            monn: snapp["flopmontant"],
                            turn: "1",
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    ),
                    snapp["turnjoueur"].isNotEmpty
                        ? Values(
                            snap: snapp,
                            title: "Turn",
                            cValue: snapp["RiverCardValue"],
                            sValue: snapp["TurnCardValue"],
                            fValue: snapp["FlopCardValue"],
                            flopPot: snapp["flopPot"],
                            turnPot: snapp["turnPot"],
                            riverPot: snapp["riverPot"],
                            jouu: snapp["turnjoueur"],
                            actt: snapp["turnaction"],
                            monn: snapp["turnmontant"],
                            turn: "2",
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    ),
                    snapp["riverjoueur"].isNotEmpty
                        ? Values(
                            snap: snapp,
                            title: "River",
                            cValue: snapp["RiverCardValue"],
                            sValue: snapp["TurnCardValue"],
                            fValue: snapp["FlopCardValue"],
                            flopPot: snapp["flopPot"],
                            turnPot: snapp["turnPot"],
                            riverPot: snapp["riverPot"],
                            jouu: snapp["riverjoueur"],
                            actt: snapp["riveraction"],
                            monn: snapp["rivermontant"],
                            turn: "3",
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    ),
                    snapp["Note"] != ""
                        ? Align(
                            child: Column(
                              children: [
                                const Text(
                                  "Note",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 150,
                                  width:
                                      MediaQuery.of(context).size.width * .50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text(
                                    snapp["Note"] ?? "",
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(CommentScren(
                          snap: snapp,
                          userSnap: widget.snap,
                        ));
                      },
                      child: StreamBuilder(
                          stream: firestore
                              .collection("Situations")
                              .doc(snapp["postId"])
                              .collection("Comments")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapsh) {
                            // final snap2 = snapsh.data!.docs[index].data();
                            int count2 = snapsh.data!.docs.length;
                            // int count2 = 0;
                            // if (snapsh.hasData) {
                            //   count2 = snapsh.data!.docs.length;
                            // }
                            if (snapsh.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              height: 100,
                              color: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScren(
                                                userSnap: widget.snap,
                                                snap: snapp,
                                                // count: count2,
                                              ),
                                            ),
                                          );
                                        },
                                        child: count2 != null
                                            ? Text(
                                                "    $count2 Commentaires",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )
                                            : const Text(
                                                "    0 Commentaires",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                      ),
                                      const Spacer(),
                                      PostLike(postId: snapp["postId"]),
                                      const SizedBox(
                                        width: 4,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.network(
                                        widget.snap["image"] ??
                                            "https://www.csircmc.res.in/sites/default/files/default_images/default_man_photo.jpg",
                                        width: 40,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          height: 45,
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                          child: const Text(
                                            'Rédigez une réponse...',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                );
              });
        });
  }

  Widget deviderLine(Color c) {
    return Container(
      height: 2,
      width: double.infinity,
      color: c,
    );
  }

  Widget detail(String data, bool isBold) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        // color: isBold ? Colors.black : Colors.grey.shade600,
        fontSize: isBold ? 18 : 17,
      ),
    );
  }

  alert(String postId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
                "Êtes-vous sûr de vouloir supprimer cette situation"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ANNULER",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    firestore
                        .collection("users")
                        .doc(auth.currentUser!.uid)
                        .collection("Situations")
                        .doc(postId)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "SUPPREMER",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

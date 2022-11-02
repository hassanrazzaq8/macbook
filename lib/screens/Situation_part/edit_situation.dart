import 'dart:async';

import 'package:card_app/screens/Situation_part/Flop/edit_new_section.dart';
import 'package:card_app/screens/Situation_part/Flop/utills.dart';
import 'package:card_app/screens/Situation_part/resources/store_to_firestor.dart';
import 'package:card_app/screens/Situation_part/widgets/alertdialoge.dart';
import 'package:card_app/widgets/utills.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Flop/new_section.dart';

class EditSituation extends StatefulWidget {
  const EditSituation({Key? key, required this.snap}) : super(key: key);
  final snap;
  @override
  State<EditSituation> createState() => _EditSituationState();
}

class _EditSituationState extends State<EditSituation> {
  TextEditingController title = TextEditingController();
  TextEditingController sb = TextEditingController();
  TextEditingController bb = TextEditingController();
  TextEditingController stackController = TextEditingController();
  TextEditingController note = TextEditingController();
  final titlekey = GlobalKey<FormState>();
  final jeukey = GlobalKey<FormState>();
  GvariablesController gv = Get.put(GvariablesController());
  String? game;
  String? no;
  String? mode;
  String? env;
  String? carts;
  String? blinders;
  String? position;
  String? stack;
  String? pot1, pot2, pot3;
  bool cartSelected = false, isLoading = false;
  bool flopSelected = false;
  List list1 = [], list2 = [];
  bool isFinished = false;
  List values = [];
  List type = [];
  List j2 = <String>["BTN", "SB"],
      j3 = ["BTN", "SB", "BB"],
      j4 = ["BTN", "SB", "BB", "UTG"],
      j5 = ["BTN", "SB", "BB", "UTG", "CO"],
      j6 = ["BTN", "SB", "BB", "UTG", "HJ", "CO"],
      j7 = ["BTN", "SB", "BB", "UTG", "MP", "HJ", "CO"],
      j8 = ["BTN", "SB", "BB", "UTG", "UTG1", "MP", "HJ", "CO"],
      j9 = ["BTN", "SB", "BB", "UTG", "UTG1", "UTG2", "MP", "HJ", "CO"],
      j10 = ["BTN", "SB", "BB", "UTG", "UTG1", "UTG2", "MP", "MP1", "HJ", "CO"];
  List test = [];
  List counting = [
    "A",
    "K",
    "Q",
    "J",
    "10",
    "9",
    "8",
    "7",
    "6",
    "5",
    "4",
    "3",
    "2"
  ];
  List fn = [], sn = [], tn = [], frn = [];
  String? prejour1, prejour2, preact1, preact2, premont1, premont2;
  String? fjour1, fjour2, fact1, fact2, fmont1, fmont2;
  String? tjour1, tjour2, tact1, tact2, tmont1, tmont2;
  String? rjour1, rjour2, ract1, ract2, rmont1, rmont2;
  String act = "FOLD";
  List par = [], parf = [], part = [], parv = [];
  List total = [];
  bool showCarts1 = false,
      showCarts2 = false,
      showCarts3 = false,
      showCarts4 = false;
  List sample1 = [], sample2 = [], sample3 = [];
  List comm = [], like = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isUpdating = false;
  update() async {
    final data = widget.snap;
    String tit = title.text.isEmpty ? data["title"] : title.text;
    String gm = game ?? data["gameMode"];
    String nop = no ?? data["noOfPlayers"];
    String ssb = sb.text.isEmpty ? data["sb"] : sb.text;
    String bbb = bb.text.isEmpty ? data["sb"] : bb.text;
    String stack =
        stackController.text.isEmpty ? data["stack"] : stackController.text;
    List preCarts = fn.isEmpty ? data["SimpleCardValue"] : fn;
    List fCarts = fn.isEmpty ? data["FlopCardValue"] : fn;
    List tCarts = fn.isEmpty ? data["TurnCardValue"] : fn;
    List rCarts = fn.isEmpty ? data["RiverCardValue"] : fn;
    String not = note.text.isEmpty ? data["note"] : note.text;
    String p1 = pot1 ?? data["flopPot"];
    String p2 = pot1 ?? data["turnPot"];
    String p3 = pot1 ?? data["riverPot"];
    List prej = List.from(gv.prejuu);
    List prea = List.from(gv.preacc);
    List prem = List.from(gv.premonn);
    List fj = List.from(gv.fjuu);
    List fa = List.from(gv.facc);
    List fm = List.from(gv.fmonn);
    List tj = List.from(gv.tjuu);
    List ta = List.from(gv.tacc);
    List tm = List.from(gv.tmonn);
    List rj = List.from(gv.rjuu);
    List ra = List.from(gv.racc);
    List rm = List.from(gv.rmonn);
    setState(() {
      isUpdating = true;
    });
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("Situations")
        .doc(widget.snap["postId"])
        .update({
      "title": tit,
      "gameMode": gm,
      "noOfPlayers": nop,
      "sb": ssb,
      "bb": bbb,
      "stack": stack,
      "SimpleCardValue": preCarts,
      "FlopCardValue": fCarts,
      "TurnCardValue": tCarts,
      "RiverCardValue": rCarts,
      "Note": note.text,
      "flopPot": p1,
      "turnPot": p2,
      "riverPot": p3,
      "prejoueur": prej,
      "preaction": prea,
      "premontant": prem,
      "flopjoueur": fj,
      "flopaction": fa,
      "flopmontant": fm,
      "turnjoueur": tj,
      "turnaction": ta,
      "turnmontant": tm,
      "riverjoueur": rj,
      "riveraction": ra,
      "rivermonatnt": rm,
    });
    setState(() {
      isUpdating = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    sb.dispose();
    bb.dispose();
    note.dispose();
  }

  @override
  void initState() {
    super.initState();

    no = widget.snap["noOfPlayers"];
    note.text = widget.snap["Note"];
    gv.prejuu.value = widget.snap["prejoueur"];
    gv.preacc.value = widget.snap["preaction"];
    gv.premonn.value = widget.snap["premontant"];
    gv.fjuu.value = widget.snap["flopjoueur"] ?? [];
    gv.facc.value = widget.snap["flopaction"] ?? [];
    gv.fmonn.value = widget.snap["flopmontant"] ?? [];
    gv.tjuu.value = widget.snap["turnjoueur"] ?? [];
    gv.tacc.value = widget.snap["turnaction"] ?? [];
    gv.tmonn.value = widget.snap["turnmontant"] ?? [];
    gv.rjuu.value = widget.snap["riverjoueur"] ?? [];
    gv.racc.value = widget.snap["riveraction"] ?? [];
    gv.rmonn.value = widget.snap["rivermonatnt"] ?? [];
  }

  Timer? searchOnStoppedTyping;
  _onChangeHandler(value, List list, String turn) {
    const duration = Duration(
      milliseconds: 1000,
    );

    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    setState(() =>
        searchOnStoppedTyping = Timer(duration, () => add(value, list, turn)));
  }

  add(value, List h, String turn) {
    print('hello world from search . the value is $value');
    turn == "1f" || turn == "2f" || turn == "3f" || turn == "4f"
        ? h[0] = value
        : turn == "1l" || turn == "2l" || turn == "3l" || turn == "4l"
            ? h[1] = value
            : null;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Situation",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 38,
        ),
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: Align(
                  child: SizedBox(
                    width: 200,
                    child: Form(
                      key: titlekey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: title,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: widget.snap["title"],
                          hintStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Saisir le titre de la situation";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                          ),
                          left: BorderSide(
                            color: Colors.black,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Form(
                        key: jeukey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: SizedBox(
                          height: 50,
                          width: 180,
                          child: DropdownButtonFormField(
                            alignment: Alignment.center,
                            value: game,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["gameMode"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: <String>[
                              "Cash game Holdem",
                              "Tournois Holdem",
                              "Omaha",
                              "Spin"
                            ].map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? games) {
                              setState(() {
                                game = games;
                              });
                            },
                            validator: (value) {
                              if (game == null) {
                                return "Select the category";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: no,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["noOfPlayers"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: <String>[
                              "2",
                              "3",
                              "4",
                              "5",
                              "6",
                              "7",
                              "8",
                              "9",
                              "10",
                            ].map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? noo) {
                              setState(() {
                                no = noo;
                              });
                            }),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              game == "Omaha"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                alignment: Alignment.center,
                                value: mode,
                                icon: const Visibility(
                                    visible: false,
                                    child: Icon(Icons.arrow_downward)),
                                hint: const Text(
                                  "mode de jeu",
                                  textAlign: TextAlign.center,
                                ),
                                items: <String>["Tournoise", "CashGame"]
                                    .map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? games) {
                                  setState(() {
                                    mode = games;
                                  });
                                }),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                alignment: Alignment.center,
                                value: env,
                                icon: const Visibility(
                                    visible: false,
                                    child: Icon(Icons.arrow_downward)),
                                hint: const Text(
                                  "Envoirrnement",
                                  textAlign: TextAlign.center,
                                ),
                                items: <String>["Live", "Online"].map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? noo) {
                                  setState(() {
                                    env = noo;
                                  });
                                }),
                          ),
                        )
                      ],
                    )
                  : game == "Cash game Holdem" || game == "Tournois Holdem"
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                alignment: Alignment.center,
                                value: env,
                                icon: const Visibility(
                                    visible: false,
                                    child: Icon(Icons.arrow_downward)),
                                hint: const Text(
                                  "Envoirnament",
                                  textAlign: TextAlign.center,
                                ),
                                items: <String>["Live", "Online"].map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? noo) {
                                  setState(() {
                                    env = noo;
                                  });
                                }),
                          ),
                        )
                      : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showCarts1 = !showCarts1;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Text(
                            "Select Carts",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      // width: 150,
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.snap["SimpleCardValue"].length,
                        itemBuilder: (context, index) {
                          return printCarts(
                              index, widget.snap["SimpleCardValue"]);
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      // height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Column(children: [
                        SizedBox(
                          width: 70,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: sb,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: widget.snap["sb"],
                              hintStyle: const TextStyle(color: Colors.black),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: bb,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: widget.snap["bb"],
                              hintStyle: const TextStyle(color: Colors.black),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: position,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["position"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: no == "2"
                                ? j2.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : no == "3"
                                    ? j3.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : no == "4"
                                        ? j4.map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : no == "5"
                                            ? j5.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()
                                            : no == "6"
                                                ? j6.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList()
                                                : no == "7"
                                                    ? j7.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList()
                                                    : no == "8"
                                                        ? j8.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList()
                                                        : no == "9"
                                                            ? j9.map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList()
                                                            : j10.map(
                                                                (value) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value),
                                                                  );
                                                                },
                                                              ).toList(),
                            onChanged: (noo) {
                              setState(() {
                                position = noo.toString();
                              });
                            }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: stackController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: widget.snap["stack"],
                          hintStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              showCarts1
                  ? show(widget.snap["SimpleCardValue"], 2, "1")
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Preflop",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: prejour1,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["prejoueur"][0],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: no == "2"
                                ? j2.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : no == "3"
                                    ? j3.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : no == "4"
                                        ? j4.map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : no == "5"
                                            ? j5.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()
                                            : no == "6"
                                                ? j6.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList()
                                                : no == "7"
                                                    ? j7.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList()
                                                    : no == "8"
                                                        ? j8.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList()
                                                        : no == "9"
                                                            ? j9.map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList()
                                                            : <String>[""]
                                                                .map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                prejour1 = noo.toString();
                                par.add(prejour1);
                                print("object${gv.prejuu}");
                                print("object${prejour1}");
                                gv.prejuu[0] = prejour1;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: preact1,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["preaction"][0],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: <String>["Raise", "Call", "All-in"]
                                .map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                preact1 = noo.toString();
                                gv.preacc[0] = preact1;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    gv.preacc[0] == "Bet" ||
                            gv.preacc[0] == "Raise" ||
                            gv.preacc[0] == "Call" ||
                            gv.preacc[0] == "All-in"
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: widget.snap["premontant"][0],
                                hintStyle: const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (value) {
                                _onChangeHandler(value, gv.premonn, "1f");
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Text(
                      " , ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: prejour2,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["prejoueur"][1],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: no == "2"
                                ? j2.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : no == "3"
                                    ? j3.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : no == "4"
                                        ? j4.map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : no == "5"
                                            ? j5.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()
                                            : no == "6"
                                                ? j6.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList()
                                                : no == "7"
                                                    ? j7.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList()
                                                    : no == "8"
                                                        ? j8.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList()
                                                        : no == "9"
                                                            ? j9.map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList()
                                                            : <String>[""]
                                                                .map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                prejour2 = noo.toString();
                                gv.prejuu[1] = prejour2;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: preact2,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["preaction"][1],
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            items: <String>["Check", "Bet", "Raise", "Fold"]
                                .map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                preact2 = noo.toString();
                                gv.preacc[1] = preact2;
                                preact2 == "Fold" ? gv.premonn[1] = "" : null;
                                // preact2 != act ? par.add(prejour2) : null;
                                if (preact2 != act) {
                                  if (prejour1 == prejour2) {
                                    return;
                                  } else {
                                    par.add(prejour2);
                                  }
                                }
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    (gv.preacc[1] == "Bet" ||
                                gv.preacc[1] == "Raise" ||
                                gv.preacc[1] == "Call" ||
                                gv.preacc[1] == "All-in") &&
                            (preact2 != "Fold")
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: widget.snap["premontant"][1],
                                hintStyle: const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (value) {
                                _onChangeHandler(value, gv.premonn, "1l");
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              widget.snap["prejoueur"].length > 2
                  ? EditNewSection(
                      count: no!,
                      turn: "1",
                      jou: const [],
                      index: 1,
                      snap: widget.snap,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: fn.length,
                  itemBuilder: (context, index) {
                    return newOne(fn, no, "1", index);
                  },
                ),
              ),
              const SizedBox(height: 5),
              addButton(fn),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * .75,
                color: Colors.black,
                height: 2,
              ),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Flop",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showCarts2 = !showCarts2;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text(
                                  "Select Carts",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.snap["FlopCardValue"].length,
                              itemBuilder: (context, index) {
                                return printCarts(
                                    index, widget.snap["FlopCardValue"]);
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: widget.snap["flopPot"],
                                hintStyle: const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  pot1 = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
              showCarts2
                  ? show(widget.snap["FlopCardValue"], 3, "2")
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: fjour1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["flopjoueur"][0],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: par.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      fjour1 = noo.toString();
                                      gv.fjuu[0] = fjour1;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: fact1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["flopaction"][0],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: <String>["Check", "Bet", "All-in"]
                                      .map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      fact1 = noo.toString();
                                      gv.facc[0] = fact1;
                                      fact1 == "Check"
                                          ? gv.fmonn[0] = ""
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (widget.snap["flopaction"][0] == "Bet" ||
                                      widget.snap["flopaction"][0] == "Raise" ||
                                      widget.snap["flopaction"][0] == "Call" ||
                                      widget.snap["flopaction"][0] ==
                                          "All-in") &&
                                  (fact1 != "Check")
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["flopmontant"][0],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.fmonn, "2f");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Text(
                            " , ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: fjour2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["flopjoueur"][1],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: par.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      fjour2 = noo.toString();
                                      gv.fjuu[1] = fjour2;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: fact2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["flopaction"][1],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: <String>[
                                    "Check",
                                    "Bet",
                                    "Raise",
                                    "Call",
                                    "Fold",
                                    "All-in"
                                  ].map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      fact2 = noo.toString();
                                      gv.facc[1] = fact2;
                                      parf = List.from(par);
                                      fact2 == act ? parf.remove(fjour2) : null;
                                      fact2 == "Check" || fact2 == "Fold"
                                          ? gv.fmonn[1] = ""
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          widget.snap["flopaction"][1] == "Bet" ||
                                  widget.snap["flopaction"][1] == "Raise" ||
                                  widget.snap["flopaction"][1] == "Call" ||
                                  widget.snap["flopaction"][1] == "All-in"
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["flopmontant"][1],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.fmonn, "2l");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
              const SizedBox(height: 5),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : EditNewSection(
                      count: no!,
                      turn: "2",
                      jou: const [],
                      index: 1,
                      snap: widget.snap,
                    ),
              const SizedBox(height: 5),
              SizedBox(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sn.length,
                  itemBuilder: (context, index) {
                    return newOne(sn, no, "2", index);
                  },
                ),
              ),
              const SizedBox(height: 5),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : addButton(sn),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 10),
              widget.snap["flopjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width * .75,
                      color: Colors.black,
                      height: 2,
                    ),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 10),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Turn",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showCarts3 = !showCarts3;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text(
                                  "Select Carts",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.snap["TurnCardValue"].length,
                              itemBuilder: (context, index) {
                                return printCarts(
                                    index, widget.snap["TurnCardValue"]);
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: widget.snap["turnPot"],
                                hintStyle: const TextStyle(color: Colors.black),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  pot2 = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
              showCarts3
                  ? show(widget.snap["TurnCardValue"], 1, "3")
                  : const SizedBox.shrink(),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: tjour1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["turnjoueur"][0],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: parf.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      tjour1 = noo.toString();
                                      gv.tjuu[0] = tjour1;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: tact1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["turnaction"][0],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: <String>["Check", "Bet", "All-in"]
                                      .map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      tact1 = noo.toString();
                                      gv.tacc[0] = tact1;
                                      tact1 == "Check"
                                          ? gv.tmonn[0] = "Check"
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (widget.snap["turnaction"][0] == "Bet" ||
                                      widget.snap["turnaction"][0] == "Raise" ||
                                      widget.snap["turnaction"][0] == "Call" ||
                                      widget.snap["turnaction"][0] ==
                                          "All-in") &&
                                  (tact1 != "Check")
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["turnmontant"][0],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.tmonn, "3f");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Text(
                            " , ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: tjour2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["turnjoueur"][1],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: parf.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      tjour2 = noo.toString();
                                      gv.tjuu[1] = tjour2;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: tact2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["turnaction"][1],
                                    textAlign: TextAlign.center,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  items: <String>[
                                    "Check",
                                    "Bet",
                                    "Raise",
                                    "Call",
                                    "Fold",
                                    "All-in"
                                  ].map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      tact2 = noo.toString();
                                      gv.tacc[1] = tact2;
                                      part = List.from(parf);
                                      tact2 == act ? part.remove(tjour2) : null;
                                      tact2 == "Check" || tact2 == "Fold"
                                          ? gv.tmonn[1] = ""
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (widget.snap["turnaction"][1] == "Bet" ||
                                      widget.snap["turnaction"][1] == "Raise" ||
                                      widget.snap["turnaction"][1] == "Call" ||
                                      widget.snap["turnaction"][1] ==
                                          "All-in") &&
                                  (tact2 == "Check" || tact2 == "Fold")
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["turnmontant"][1],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.tmonn, "3l");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
              const SizedBox(height: 5),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : EditNewSection(
                      count: no!,
                      turn: "3",
                      jou: const [],
                      index: 1,
                      snap: widget.snap,
                    ),
              const SizedBox(height: 5),
              SizedBox(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tn.length,
                  itemBuilder: (context, index) {
                    return newOne(tn, no, "3", index);
                  },
                ),
              ),
              const SizedBox(height: 5),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : addButton(tn),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 10),
              widget.snap["turnjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width * .75,
                      color: Colors.black,
                      height: 2,
                    ),
              const SizedBox(
                height: 10,
              ),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "River",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  showCarts4 = !showCarts4;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text(
                                  "Select Carts",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.snap["RiverCardValue"].length,
                              itemBuilder: (context, index) {
                                return printCarts(
                                    index, widget.snap["RiverCardValue"]);
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: widget.snap["riverPot"],
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  pot3 = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
              showCarts4
                  ? show(widget.snap["RiverCardValue"], 1, "4")
                  : const SizedBox.shrink(),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: rjour1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["riverjoueur"][0],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  items: part.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      rjour1 = noo.toString();
                                      gv.rjuu[0] = rjour1;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: ract1,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["riveraction"][0],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  items: <String>["Check", "Bet", "All-in"]
                                      .map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      ract1 = noo.toString();
                                      gv.racc[0] = ract1;
                                      ract1 == "Check"
                                          ? gv.rmonn[0] = ract1
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (widget.snap["riveraction"][0] == "Bet" ||
                                      widget.snap["riveraction"][0] ==
                                          "Raise" ||
                                      widget.snap["riveraction"][0] == "Call" ||
                                      widget.snap["riveraction"][0] ==
                                          "All-in") &&
                                  (ract1 == "Check")
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["rivermontant"][0],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.rmonn, "4f");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const Text(
                            " , ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: rjour2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["riverjoueur"][1],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  items: part.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      rjour2 = noo.toString();
                                      gv.rjuu[1] = rjour2;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  alignment: Alignment.center,
                                  value: ract2,
                                  icon: const Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  hint: Text(
                                    widget.snap["riveraction"][1],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  items: <String>[
                                    "Check",
                                    "Bet",
                                    "Raise",
                                    "Call",
                                    "Fold",
                                    "All-in"
                                  ].map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (noo) {
                                    setState(() {
                                      ract2 = noo.toString();
                                      gv.racc[1] = ract2;
                                      parv = List.from(part);
                                      ract2 == act ? parv.remove(rjour2) : null;
                                      ract2 == "Check" || ract2 == "Fold"
                                          ? gv.rmonn[1] = ""
                                          : null;
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(width: 5),
                          (widget.snap["riveraction"][1] == "Bet" ||
                                      widget.snap["riveraction"][1] ==
                                          "Raise" ||
                                      widget.snap["riveraction"][1] == "Call" ||
                                      widget.snap["riveraction"][1] ==
                                          "All-in") &&
                                  (ract2 == "Check" || ract2 == "Fold")
                              ? SizedBox(
                                  width: 100,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["rivermontant"][1],
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                    onChanged: (value) {
                                      _onChangeHandler(value, gv.rmonn, "4l");
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
              const SizedBox(height: 5),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : EditNewSection(
                      count: no!,
                      turn: "4",
                      jou: const [],
                      index: 1,
                      snap: widget.snap,
                    ),
              const SizedBox(height: 5),
              SizedBox(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: frn.length,
                  itemBuilder: (context, index) {
                    return newOne(frn, no, "4", index);
                  },
                ),
              ),
              const SizedBox(height: 5),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : addButton(frn),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 10),
              widget.snap["riverjoueur"].isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width * .75,
                      color: Colors.black,
                      height: 2,
                    ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 20),
              const Text(
                "Plus d'information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Profil des joueurs, Dynamique a la table ect...",
                // style: TextStyle(
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width * .50,
                child: TextField(
                  maxLines: 5,
                  controller: note,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: widget.snap["Note"],
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  update();
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: (isUpdating)
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : const Text(
                          " mettre à jour",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addButton(List l) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          setState(() {
            l.add("value");
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: const Text(
            " Ajouter + ",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  newOne(List list, count, String turn, int i) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                list.removeLast();
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
          NewSection(
            count: count,
            turn: turn,
            jou: par,
            index: i,
          )
        ],
      ),
    );
  }

  editCartsDialogue(List a) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setpState) => AlertDialog(
            title: const Text(
              "Do you want to edit your carts",
              textAlign: TextAlign.center,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.blue),
                    )),
                TextButton(
                  onPressed: () {
                    setState(() {
                      a.removeLast();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  printCarts(
    int index,
    List list,
  ) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              editCartsDialogue(list);
            },
            child: Container(
              height: 45,
              width: 35,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      list[index]["title"],
                      style: TextStyle(
                          color: Color(list[index]["color"]),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 15,
                        width: 22,
                        child: Image.asset(
                          list[index]["image"],
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
  }

  show(List h, int length, String turn) {
    return Container(
      width: 150,
      height: Get.height * 0.8,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: counting.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            final exists = total.where(
                                (value) => value["title"] == counting[index]);
                            final exists2 = total.where((value) =>
                                value["image"] == "assets/pngegg (1).png");
                            setState(() {
                              if (h.length < length) {
                                if (exists.isEmpty || exists2.isEmpty) {
                                  h.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (1).png",
                                    "color": Colors.red.value,
                                  });
                                  total.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (1).png",
                                    "color": Colors.red.value,
                                  });
                                  turn == "1"
                                      ? showCarts1 = false
                                      : turn == "2"
                                          ? showCarts2 = false
                                          : turn == "3"
                                              ? showCarts3 = false
                                              : showCarts4 = false;
                                } else {
                                  customAlertDialoge(context, "Sorry",
                                      "Card is already selected", "ok");
                                }
                              } else {
                                customAlertDialoge(context, "Sorry",
                                    "You can't Select more cards", "ok");
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    counting[index],
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                        height: 15,
                                        width: 22,
                                        child: Image.asset(
                                            "assets/pngegg (1).png")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: counting.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            final exists = total.where(
                                (value) => value["title"] == counting[index]);
                            final exists2 = total.where((value) =>
                                value["image"] == "assets/pngegg (4).png");
                            setState(() {
                              if (h.length < length) {
                                if (exists.isEmpty || exists2.isEmpty) {
                                  h.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (4).png",
                                    "color": Colors.red.value,
                                  });
                                  total.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (4).png",
                                    "color": Colors.red.value,
                                  });
                                  turn == "1"
                                      ? showCarts1 = false
                                      : turn == "2"
                                          ? showCarts2 = false
                                          : turn == "3"
                                              ? showCarts3 = false
                                              : showCarts4 = false;
                                } else {
                                  customAlertDialoge(context, "Sorry",
                                      "Card is already selected", "ok");
                                }
                              } else {
                                customAlertDialoge(context, "Sorry",
                                    "You can't Select more cards", "ok");
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    counting[index],
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        height: 15,
                                        width: 22,
                                        child: Image.asset(
                                            "assets/pngegg (4).png")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: counting.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            final exists = total.where(
                                (value) => value["title"] == counting[index]);
                            final exists2 = total.where((value) =>
                                value["image"] == "assets/pngegg (2).png");
                            setState(() {
                              if (h.length < length) {
                                if (exists.isEmpty || exists2.isEmpty) {
                                  h.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (2).png",
                                    "color": Colors.black.value,
                                  });
                                  total.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (2).png",
                                    "color": Colors.red.value,
                                  });
                                  turn == "1"
                                      ? showCarts1 = false
                                      : turn == "2"
                                          ? showCarts2 = false
                                          : turn == "3"
                                              ? showCarts3 = false
                                              : showCarts4 = false;
                                } else {
                                  customAlertDialoge(context, "Sorry",
                                      "Card is already selected", "ok");
                                }
                              } else {
                                customAlertDialoge(context, "Sorry",
                                    "You can't Select more cards", "ok");
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    counting[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        height: 15,
                                        width: 22,
                                        child: Image.asset(
                                            "assets/pngegg (2).png")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: counting.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            final exists = total.where(
                                (value) => value["title"] == counting[index]);
                            final exists2 = total.where((value) =>
                                value["image"] == "assets/pngegg (3).png");
                            setState(() {
                              if (h.length < length) {
                                if (exists.isEmpty || exists2.isEmpty) {
                                  h.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (3).png",
                                    "color": Colors.black.value,
                                  });
                                  total.add({
                                    "title": counting[index],
                                    "image": "assets/pngegg (3).png",
                                    "color": Colors.red.value,
                                  });
                                  turn == "1"
                                      ? showCarts1 = false
                                      : turn == "2"
                                          ? showCarts2 = false
                                          : turn == "3"
                                              ? showCarts3 = false
                                              : showCarts4 = false;
                                } else {
                                  customAlertDialoge(context, "Sorry",
                                      "Card is already selected", "ok");
                                }
                              } else {
                                customAlertDialoge(context, "Sorry",
                                    "You can't Select more cards", "ok");
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    counting[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        height: 15,
                                        width: 22,
                                        child: Image.asset(
                                            "assets/pngegg (3).png")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:card_app/screens/Situation_part/Flop/utills.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNewSection extends StatefulWidget {
  const EditNewSection({
    Key? key,
    required this.count,
    required this.turn,
    required this.jou,
    required this.index,
    required this.snap,
  }) : super(key: key);
  final String count;
  final String turn;
  final List jou;
  final int index;
  final snap;

  @override
  State<EditNewSection> createState() => _EditNewSectionState();
}

class _EditNewSectionState extends State<EditNewSection> {
  List j2 = <String>["BTN", "SB"],
      j3 = ["BTN", "SB", "BB"],
      j4 = ["BTN", "SB", "BB", "UTG"],
      j5 = ["BTN", "SB", "BB", "UTG", "CO"],
      j6 = ["BTN", "SB", "BB", "UTG", "HJ", "CO"],
      j7 = ["BTN", "SB", "BB", "UTG", "MP", "HJ", "CO"],
      j8 = ["BTN", "SB", "BB", "UTG", "UTG1", "MP", "HJ", "CO"],
      j9 = ["BTN", "SB", "BB", "UTG", "UTG1", "UTG2", "MP", "HJ", "CO"],
      j10 = ["BTN", "SB", "BB", "UTG", "UTG1", "UTG2", "MP", "MP1", "HJ", "CO"];
  String? joueur, action, montain;
  Timer? searchOnStoppedTyping;

  _onChangeHandler(value, List list) {
    const duration = Duration(
      milliseconds: 1000,
    );

    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }

    setState(() =>
        searchOnStoppedTyping = Timer(duration, () => search(value, list)));
  }

  search(value, List h) {
    print('hello world from search . the value is $value');
    int i = widget.index + 2;
    h[i] = value;
  }

  @override
  void initState() {
    super.initState();
    gc.prejuu.value = widget.snap["prejoueur"];
    gc.preacc.value = widget.snap["preaction"];
    gc.premonn.value = widget.snap["premontant"];
    gc.fjuu.value = widget.snap["flopjoueur"] ?? [];
    gc.facc.value = widget.snap["flopaction"] ?? [];
    gc.fmonn.value = widget.snap["flopmontant"] ?? [];
    gc.tjuu.value = widget.snap["turnjoueur"] ?? [];
    gc.tacc.value = widget.snap["turnaction"] ?? [];
    gc.tmonn.value = widget.snap["turnmontant"] ?? [];
    gc.rjuu.value = widget.snap["riverjoueur"] ?? [];
    gc.racc.value = widget.snap["riveraction"] ?? [];
    gc.rmonn.value = widget.snap["rivermonatnt"] ?? [];
  }

  GvariablesController gc = Get.put(GvariablesController());
  @override
  Widget build(BuildContext context) {
    return widget.turn != "1"
        ? GridView.builder(
            itemCount: widget.turn == "2"
                ? widget.snap["flopjoueur"].length - 2
                : widget.turn == "3"
                    ? widget.snap["turnjoueur"].length - 2
                    : widget.snap["riverjoueur"].length - 2,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              int i = index + 2;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // ElevatedButton(
                    //     onPressed: () {
                    //       print(widget.snap["flopjoueur"]);
                    //       print(widget.snap["flopaction"]);
                    //       print(widget.snap["flopmontant"]);
                    //     },
                    //     child: const Text("data")),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            alignment: Alignment.center,
                            value: joueur,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.turn == "2"
                                  ? widget.snap["flopjoueur"][i]
                                  : widget.turn == "3"
                                      ? widget.snap["turnjoueur"][i]
                                      : widget.snap["riverjoueur"][i],
                              textAlign: TextAlign.center,
                            ),
                            items: widget.turn == "2"
                                ? gc.fjuu.toSet().map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : widget.turn == "3"
                                    ? gc.tjuu.toSet().map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : gc.rjuu.toSet().map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                joueur = noo.toString();
                                int i = widget.index + 2;
                                widget.turn == "2"
                                    ? gc.fjuu[i] = joueur
                                    : widget.turn == "3"
                                        ? gc.tjuu[i] = joueur
                                        : gc.rjuu[i] = joueur;
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
                            value: action,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.turn == "2"
                                  ? widget.snap["flopaction"][i]
                                  : widget.turn == "3"
                                      ? widget.snap["turnaction"][i]
                                      : widget.snap["riveraction"][i],
                              textAlign: TextAlign.center,
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
                                int i = widget.index + 2;
                                action = noo.toString();
                                widget.turn == "2"
                                    ? action == "Fold" || action == "Check"
                                        ? gc.fmonn[i] = ""
                                        // : gc.fmonn.removeWhere(
                                        //     (value) => [""].contains(value))
                                        : null
                                    : widget.turn == "3"
                                        ? action == "Fold" || action == "Check"
                                            ? gc.tmonn[i] = ""
                                            : null
                                        // : gc.tmonn.removeWhere(
                                        //     (value) => [""].contains(value))
                                        : action == "Fold" || action == "Check"
                                            ? gc.rmonn[i] = ""
                                            : null;
                                // : gc.rmonn.removeWhere(
                                //     (value) => [""].contains(value));
                                widget.turn == "2"
                                    ? gc.facc[i] = action
                                    : widget.turn == "3"
                                        ? gc.tacc[i] = action
                                        : gc.racc[i] = action;

                                if (action == "Fold") {
                                  if (widget.turn == "2" &&
                                      gc.flopOne.contains(joueur)) {
                                    gc.flopOne.remove(joueur);
                                  }
                                  if (widget.turn == "3" &&
                                      gc.turnOne.contains(joueur)) {
                                    gc.turnOne.remove(joueur);
                                  }
                                }
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),

                    widget.turn == "2"
                        ? widget.snap["flopaction"][i] == "Bet" ||
                                widget.snap["flopaction"][i] == "Raise" ||
                                widget.snap["flopaction"][i] == "Call" ||
                                widget.snap["flopaction"][i] == "All-in"
                            ? SizedBox(
                                width: 100,
                                child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: widget.snap["flopmontant"][i],
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
                                      if (widget.turn == "2") {
                                        _onChangeHandler(
                                          value,
                                          gc.fmonn,
                                        );
                                      } else if (widget.turn == "3") {
                                        _onChangeHandler(
                                          value,
                                          gc.tmonn,
                                        );
                                      } else {
                                        _onChangeHandler(
                                          value,
                                          gc.rmonn,
                                        );
                                      }
                                    }),
                              )
                            : const SizedBox.shrink()
                        : widget.turn == "3"
                            ? widget.snap["turnaction"][i] == "Bet" ||
                                    widget.snap["turnaction"][i] == "Raise" ||
                                    widget.snap["turnaction"][i] == "Call" ||
                                    widget.snap["turnaction"][i] == "All-in"
                                ? SizedBox(
                                    width: 100,
                                    child: TextField(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: widget.snap["turnmontant"]
                                              [i],
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                        ),
                                        onChanged: (value) {
                                          if (widget.turn == "2") {
                                            _onChangeHandler(
                                              value,
                                              gc.fmonn,
                                            );
                                          } else if (widget.turn == "3") {
                                            _onChangeHandler(
                                              value,
                                              gc.tmonn,
                                            );
                                          } else {
                                            _onChangeHandler(
                                              value,
                                              gc.rmonn,
                                            );
                                          }
                                        }),
                                  )
                                : const SizedBox.shrink()
                            : widget.snap["riveraction"][i] == "Bet" ||
                                    widget.snap["riveraction"][i] == "Raise" ||
                                    widget.snap["riveraction"][i] == "Call" ||
                                    widget.snap["riveraction"][i] == "All-in"
                                ? SizedBox(
                                    width: 100,
                                    child: TextField(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: widget.snap["rivermontant"]
                                              [i],
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                        ),
                                        onChanged: (value) {
                                          if (widget.turn == "2") {
                                            _onChangeHandler(
                                              value,
                                              gc.fmonn,
                                            );
                                          } else if (widget.turn == "3") {
                                            _onChangeHandler(
                                              value,
                                              gc.tmonn,
                                            );
                                          } else {
                                            _onChangeHandler(
                                              value,
                                              gc.rmonn,
                                            );
                                          }
                                        }),
                                  )
                                : const SizedBox.shrink(),
                  ],
                ),
              );
            })
        : GridView.builder(
            itemCount: widget.snap["prejoueur"].length - 2,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              int i = index + 2;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
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
                            value: joueur,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["prejoueur"][i],
                              textAlign: TextAlign.center,
                            ),
                            items: widget.count == "2"
                                ? j2.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : widget.count == "3"
                                    ? j3.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : widget.count == "4"
                                        ? j4.map((value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : widget.count == "5"
                                            ? j5.map((value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList()
                                            : widget.count == "6"
                                                ? j6.map((value) {
                                                    return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList()
                                                : widget.count == "7"
                                                    ? j7.map((value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList()
                                                    : widget.count == "8"
                                                        ? j8.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList()
                                                        : widget.count == "9"
                                                            ? j9.map((value) {
                                                                return DropdownMenuItem(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList()
                                                            : widget.count ==
                                                                    "10"
                                                                ? j10.map(
                                                                    (value) {
                                                                    return DropdownMenuItem(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value),
                                                                    );
                                                                  }).toList()
                                                                : <String>[
                                                                    ""
                                                                  ].map(
                                                                    (value) {
                                                                    return DropdownMenuItem(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                joueur = noo.toString();
                                int i = widget.index + 2;
                                gc.prejuu.length <= i
                                    ? gc.prejuu.add(joueur)
                                    : gc.prejuu[i] = joueur;
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
                            value: action,
                            icon: const Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            hint: Text(
                              widget.snap["preaction"][i],
                              textAlign: TextAlign.center,
                            ),
                            items: <String>["Raise", "Call", "All-in", "Fold"]
                                .map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (noo) {
                              setState(() {
                                action = noo.toString();
                                action == "Fold" ? gc.fmonn.add("") : null;
                                // : gc.fmonn
                                //     .removeWhere((value) => [""].contains(value));
                                int i = widget.index + 2;
                                gc.preacc.length <= i
                                    ? gc.preacc.add(action)
                                    : gc.preacc[i] = action;
                                action != "Fold"
                                    ? gc.globalOne.add(joueur)
                                    : null;

                                if (action == "Fold" &&
                                    gc.globalOne.contains(joueur)) {
                                  gc.globalOne.remove(joueur);
                                }
                              });
                            }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    widget.snap["preaction"][i] == "Bet" ||
                            widget.snap["preaction"][i] == "Raise" ||
                            widget.snap["preaction"][i] == "Call" ||
                            widget.snap["preaction"][i] == "All-in"
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: widget.snap["premontant"][i],
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                onChanged: (value) {
                                  _onChangeHandler(
                                    value,
                                    gc.premonn,
                                  );
                                }),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            });
  }
}

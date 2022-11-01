import 'dart:async';
import 'package:card_app/screens/Situation_part/Flop/utills.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewSection extends StatefulWidget {
  const NewSection({
    Key? key,
    required this.count,
    required this.turn,
    required this.jou,
    required this.index,
  }) : super(key: key);
  final String count;
  final String turn;
  final List jou;
  final int index;

  @override
  State<NewSection> createState() => _NewSectionState();
}

class _NewSectionState extends State<NewSection> {
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
    h.length <= i ? h.add(value) : h[i] = value;
  }

  GvariablesController gc = Get.put(GvariablesController());
  @override
  Widget build(BuildContext context) {
    return widget.turn != "1"
        ? Obx(
            () => Row(
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
                            visible: false, child: Icon(Icons.arrow_downward)),
                        hint: const Text(
                          "joueur",
                          textAlign: TextAlign.center,
                        ),
                        items: widget.turn == "2"
                            ? gc.globalOne.toSet().map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : widget.turn == "3"
                                ? gc.flopOne.toSet().map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList()
                                : gc.turnOne.toSet().map((value) {
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
                                ? gc.fjuu.length <= i
                                    ? gc.fjuu.add(joueur)
                                    : gc.fjuu[i] = joueur
                                : widget.turn == "3"
                                    ? gc.tjuu.length <= i
                                        ? gc.tjuu.add(joueur)
                                        : gc.tjuu[i] = joueur
                                    : gc.rjuu.length <= i
                                        ? gc.rjuu.add(joueur)
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
                            visible: false, child: Icon(Icons.arrow_downward)),
                        hint: const Text(
                          "Actions",
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
                            action = noo.toString();
                            int i = widget.index + 2;
                            widget.turn == "2"
                                ? gc.facc.length <= i
                                    ? gc.facc.add(action)
                                    : gc.facc[i] = action
                                : widget.turn == "3"
                                    ? gc.tacc.length <= i
                                        ? gc.tacc.add(action)
                                        : gc.tacc[i] = action
                                    : gc.racc.length <= i
                                        ? gc.racc.add(action)
                                        : gc.racc[i] = action;
                            action != "Fold"
                                ? widget.turn == "2"
                                    ? gc.flopOne.add(joueur)
                                    : widget.turn == "3"
                                        ? gc.turnOne.add(joueur)
                                        : gc.riverOne.add(joueur)
                                : null;
                            widget.turn == "2"
                                ? action == "Fold" || action == "Check"
                                    ? gc.fmonn.length <= i
                                        ? gc.fmonn.add("")
                                        : gc.fmonn[i] = ""
                                    : null
                                : widget.turn == "3"
                                    ? action == "Fold" || action == "Check"
                                        ? gc.tmonn.length <= i
                                            ? gc.tmonn.add("")
                                            : gc.tmonn[i] = ""
                                        : null
                                    : action == "Fold" || action == "Check"
                                        ? gc.rmonn.length <= i
                                            ? gc.rmonn.add("")
                                            : gc.rmonn[i] = ""
                                        : null;

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
                action == "Raise" ||
                        action == "Call" ||
                        action == "All-in" ||
                        action == "Bet"
                    ? SizedBox(
                        width: 100,
                        child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "montant",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
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
          )
        : Row(
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
                          visible: false, child: Icon(Icons.arrow_downward)),
                      hint: const Text(
                        "joueur",
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
                                                        child: Text(value),
                                                      );
                                                    }).toList()
                                                  : widget.count == "9"
                                                      ? j9.map((value) {
                                                          return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList()
                                                      : widget.count == "10"
                                                          ? j10.map((value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList()
                                                          : <String>[""]
                                                              .map((value) {
                                                              return DropdownMenuItem(
                                                                value: value,
                                                                child:
                                                                    Text(value),
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
                          visible: false, child: Icon(Icons.arrow_downward)),
                      hint: const Text(
                        "Actions",
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
                          int i = widget.index + 2;
                          action == "Fold"
                              ? gc.premonn.length <= i
                                  ? gc.premonn.add("")
                                  : gc.premonn[i] = ""
                              : null;
                          // : gc.fmonn
                          //     .removeWhere((value) => [""].contains(value));

                          gc.preacc.length <= i
                              ? gc.preacc.add(action)
                              : gc.preacc[i] = action;
                          action != "Fold" ? gc.globalOne.add(joueur) : null;

                          if (action == "Fold" &&
                              gc.globalOne.contains(joueur)) {
                            gc.globalOne.remove(joueur);
                          }
                        });
                      }),
                ),
              ),
              const SizedBox(width: 5),
              action == "Raise" || action == "Call" || action == "All-in"
                  ? SizedBox(
                      width: 100,
                      child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "montant",
                            focusedBorder: OutlineInputBorder(
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
          );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';

class IntersetController extends GetxController {
  TextEditingController description = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  String uId = FirebaseAuth.instance.currentUser!.uid;
  var selectedItems = [].obs;
  updateIt() {
    ref.doc(uId).update({
      "description": description.text,
      'intersets': selectedItems.value,
    }).whenComplete(() {
      Get.to(() => HomeScreen());
    });
  }
}

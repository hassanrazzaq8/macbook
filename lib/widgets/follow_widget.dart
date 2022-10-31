import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowWidget extends StatefulWidget {
  FollowWidget({
    Key? key,
    required this.userId,
    required this.snap,
    required this.isFollower,
  }) : super(key: key);
  final String userId;
  final snap;
  final bool isFollower;
  bool greenColor = false;
  @override
  State<FollowWidget> createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> {
  String? followerId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  colorCheck() async {
    if (await isFollowed()) {
      widget.greenColor = true;
    } else {
      widget.greenColor = false;
    }
  }

  @override
  void initState() {
    super.initState();
    colorCheck();
  }

  List follow = [];
  var snap;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firestore.collection('users').doc(followerId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
            );
          }
          if (snapshot.hasData) {
            snap = snapshot.data!;

            // snap
            //     ? widget.greenColor = true
            //     : widget.greenColor = false;
          }

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  // print("llllllllllll${widget.snap['role']}");
                  // print("llllllllllll${widget.snap['country']}");
                  // print("llllllllllll${widget.snap['userName']}");
                  // print("llllllllllll${snap['age']}");
                  addToFollow(
                    widget.userId,
                    snap["userName"],
                    snap["role"],
                    snap["image"],
                    snap["country"],
                  );
                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: widget.isFollower
                    ? const Icon(
                        Icons.person,
                        color: Colors.green,
                      )
                    : Icon(
                        widget.greenColor ? Icons.person : Icons.person_add,
                        color: widget.greenColor ? Colors.green : Colors.grey,
                      ),
              ),
            ],
          );
        });
  }

  addToFollow(String uid, String n, String r, String i, String c) async {
    if (await isFollowed()) {
      await firestore
          .collection('users')
          .doc(followerId)
          .collection('following')
          .doc(widget.userId)
          .delete();
      setState(() {
        widget.greenColor = false;
        print("removed");
      });
      await firestore
          .collection('users')
          .doc(widget.userId)
          .collection('followers')
          .doc(widget.userId)
          .delete();
      return;
    } else {
      await firestore
          .collection('users')
          .doc(followerId)
          .collection('following')
          .doc(widget.userId)
          .set({
        'userId': widget.userId,
        'name': widget.snap['userName'],
        'flag': widget.snap['country'],
        'team': widget.snap['role'],
        'profileImage': widget.snap['image'],
      });
      setState(() {
        widget.greenColor = true;
        print("added");
      });
      await firestore
          .collection('users')
          .doc(widget.userId)
          .collection('followers')
          .doc(followerId)
          .set({
        'userId': followerId,
        'name': n,
        'flag': c,
        'team': r,
        'profileImage': i,
      });
    }
  }

  Future<bool> isFollowed() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followerId)
        .collection('following')
        .doc(widget.userId)
        .get()
        .then((doc) {
      if (mounted) {
        setState(() {
          widget.greenColor = doc.exists;
        });
      }
      return doc.exists;
    });
  }
}

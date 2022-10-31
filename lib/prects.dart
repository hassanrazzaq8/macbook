import 'package:card_app/widgets/follow_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Followers extends StatefulWidget {
  const Followers({Key? key, required this.uid, required this.snap})
      : super(key: key);
  final String uid;
  final snap;

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            automaticIndicatorColorAdjustment: false,
            // indicator: BoxDecoration(color: Colors.green),
            indicatorColor: Colors.green.shade800,
            // labelColor: Colors.deepPurpleAccent,
            // unselectedLabelColor: Colors.red,
            tabs: [
              Tab(
                icon: Text(
                  "Abonnement",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                  ),
                ),
              ),
              Tab(
                icon: Text(
                  "Abonnes",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: firestore
                    .collection('users')
                    .doc(widget.uid)
                    .collection('following')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final snap = snapshot.data!.docs[index].data();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 8.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Image.network(
                                  snap["profileImage"].toString() == '0'
                                      ? "https://www.csircmc.res.in/sites/default/files/default_images/default_man_photo.jpg"
                                      : snap["profileImage"].toString(),
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(width: Get.width * .04),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snap["name"]),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(snap['flag'].toString()),
                                        SvgPicture.asset(
                                          'assets/icons/${snap['team']}.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Expanded(
                                    // child: IconButton(
                                    //   onPressed: () {},
                                    //   icon:
                                    child: Text("")
                                    // ),
                                    ),
                                // const Icon(
                                //   Icons.person,
                                //   color: Colors.green,
                                // ),
                                FollowWidget(
                                  userId: snap['userId'],
                                  snap: snap,
                                  isFollower: true,
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }),
            StreamBuilder(
                stream: firestore
                    .collection('users')
                    .doc(widget.uid)
                    .collection('followers')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapsh) {
                  if (snapsh.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapsh.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapsh.data!.docs.length,
                        itemBuilder: (context, index) {
                          final snap = snapsh.data!.docs[index].data();
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Image.network(
                                    snap["profileImage"].toString() == '0'
                                        ? "https://www.csircmc.res.in/sites/default/files/default_images/default_man_photo.jpg"
                                        : snap["profileImage"].toString(),
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: Get.width * .04),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snap["name"].toString()),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(snap['flag'].toString()),
                                          SvgPicture.asset(
                                            'assets/icons/${snap['team']}.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                      // child: IconButton(
                                      //   onPressed: () {},
                                      //   icon:
                                      child: Text("")
                                      // ),
                                      ),
                                  // const Icon(
                                  //   Icons.person,
                                  //   color: Colors.green,
                                  // ),
                                  FollowWidget(
                                    userId: snap['userId'],
                                    snap: snap,
                                    isFollower: false,
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("data"),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

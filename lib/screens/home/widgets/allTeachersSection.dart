import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'teacherCard.dart';

import '../teacherDetails.dart';

class AllTeachersSection extends StatelessWidget {
  const AllTeachersSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(
              10.0,
            ),
            child: Text(
              "All Teachers: ",
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "QuickSand",
                fontSize: 25.0,
              ),
            ),
          ),
        ),
        Container(
          height: 200,
          // margin: EdgeInsets.all(15),
          child: StreamBuilder<QuerySnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection("teachers")
                  .where('name', isNotEqualTo: null)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherDetailsScreen(
                                    uid: snapshot.data.docs[index].id,
                                    phoneNumber: snapshot.data.docs[index]
                                        .data()["phoneNumber"],
                                    name: snapshot.data.docs[index]
                                        .data()["name"],
                                    subject: snapshot.data.docs[index]
                                        .data()["classesTaught"],
                                    imageUrl: snapshot.data.docs[index]
                                        .data()["photoURL"],
                                  ),
                                ),
                              );
                            },
                            child: TeacherCard(
                              subject: snapshot.data.docs[index]
                                  .data()["classesTaught"],
                              imgPath:
                                  snapshot.data.docs[index].data()["photoURL"],
                              name: snapshot.data.docs[index].data()["name"],
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Sorry, no data available in your city.",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: "QuickSand"),
                        ),
                      ),
                    );
                  }
                } else {
                  return Text(
                    "Sorry, no data available for your city.",
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand"),
                  );
                }
              }),
        )
      ],
    );
  }
}

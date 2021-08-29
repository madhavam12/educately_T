import 'package:flutter/material.dart';

import '../teacherDetails.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacherCard.dart';

class TeacherSection extends StatelessWidget {
  final String city;
  TeacherSection({Key key, @required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(
                10.0,
              ),
              child: Text(
                "Teachers in $city: ",
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "QuickSand",
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 220,
            // margin: EdgeInsets.all(15),
            child: StreamBuilder<QuerySnapshot<Map>>(
                stream: FirebaseFirestore.instance
                    .collection("teachers")
                    .where('cityName', isEqualTo: city)
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
                                      // uid: snapshot
                                      //     .data.docs[index]
                                      //     .data()["uid"],

                                      uid: snapshot.data.docs[index].id,
                                      phoneNumber: snapshot.data.docs[index]
                                          .data()["phoneNumber"],
                                      name: snapshot.data.docs[index]
                                          .data()["name"],
                                      subject: snapshot.data.docs[index]
                                          .data()["subjectsTaught"],
                                      imageUrl: snapshot.data.docs[index]
                                          .data()["photoURL"],
                                    ),
                                  ),
                                );
                              },
                              child: TeacherCard(
                                subject: snapshot.data.docs[index]
                                    .data()["subjectsTaught"],
                                imgPath: snapshot.data.docs[index]
                                    .data()["photoURL"],
                                name: snapshot.data.docs[index].data()["name"],
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Sorry, no teachers available in your city.",
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
                      "Sorry, no teachers available in your city.",
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
      ),
    );
  }
}

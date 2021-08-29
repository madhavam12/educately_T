import 'package:educately_t/screens/home/widgets/teacherSection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'studentDetailsScreen.dart';
import 'package:hive/hive.dart';

import 'widgets/studentCard.dart';

class ConnectWithStudents extends StatefulWidget {
  const ConnectWithStudents({Key key}) : super(key: key);

  @override
  _ConnectWithStudentsState createState() => _ConnectWithStudentsState();
}

class _ConnectWithStudentsState extends State<ConnectWithStudents> {
  String city = "";

  getCityName() async {
    var box = Hive.box('city');

    city = box.get('name');
  }

  @override
  void initState() {
    super.initState();
    getCityName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 40,
                          child: Image.asset(
                            'assets/images/discuss.png',
                            height: 220,
                          ),
                        ),
                        Container(
                          height: 350,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [],
                                ),
                                SizedBox(
                                  height: 230,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 25),
                                    child: Text(
                                      "Connect with teachers and students, text them a hi!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "QuickSand",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                        "Students in $city: ",
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
                            .collection("students")
                            .where('cityName', isEqualTo: city)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.isNotEmpty) {
                              return Container(
                                child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      print(snapshot.data.docs[index].data());
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetailsScreen(
                                                uid: snapshot
                                                    .data.docs[index].id,
                                                about: snapshot.data.docs[index]
                                                    .data()["about"],
                                                phoneNumber: snapshot
                                                    .data.docs[index]
                                                    .data()["phoneNumber"],
                                                name: snapshot.data.docs[index]
                                                    .data()["name"],
                                                standard: snapshot
                                                    .data.docs[index]
                                                    .data()["standard"],
                                                imageUrl: snapshot
                                                    .data.docs[index]
                                                    .data()["photoURL"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: StudentCard(
                                          standard: snapshot.data.docs[index]
                                              .data()["standard"],
                                          imgPath: snapshot.data.docs[index]
                                              .data()["photoURL"],
                                          name: snapshot.data.docs[index]
                                              .data()["name"],
                                        ),
                                      );
                                    }),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    "Sorry, no students available in your city.",
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
                              "Sorry, no students available in your city.",
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
            ),
            TeacherSection(city: city),
          ],
        ),
      ),
    );
  }
}

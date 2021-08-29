import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'teacherDetails.dart';

class NearbyTutors extends StatefulWidget {
  NearbyTutors({Key key}) : super(key: key);

  @override
  _NearbyTutorsState createState() => _NearbyTutorsState();
}

class _NearbyTutorsState extends State<NearbyTutors> {
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25),
            Center(
              child: Text(
                "Teachers in $city: ",
                style: TextStyle(
                  letterSpacing: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "QuickSand",
                  fontSize: 25.0,
                ),
              ),
            ),
            Expanded(
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
                        return GridView.builder(
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (BuildContext context, int index) {
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
                                imgPath: snapshot.data.docs[index]
                                    .data()["photoURL"],
                                name: snapshot.data.docs[index].data()["name"],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "No classes available",
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
                        "No classes available",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "QuickSand"),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String imgPath;
  final String subject;
  TeacherCard(
      {Key key,
      @required this.subject,
      @required this.name,
      @required this.imgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 175,
          height: 250,
          padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imgPath,
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontFamily: "QuickSand",
                          fontSize: 13.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

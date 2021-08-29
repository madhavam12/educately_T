import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'widgets/classCard.dart';

class UpcomingClasses extends StatefulWidget {
  UpcomingClasses({Key key}) : super(key: key);

  @override
  _UpcomingClassesState createState() => _UpcomingClassesState();
}

var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Colors.orange.withOpacity(0.9);

List colors = [
  kBlueColor,
  kOrangeColor,
  kYellowColor,
];

class _UpcomingClassesState extends State<UpcomingClasses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(
                  20.0,
                ),
                child: Text(
                  "Your Classes",
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
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map>>(
                  stream: FirebaseFirestore.instance
                      .collection('classes')
                      .where('meetURL', isNotEqualTo: null)
                      .orderBy('dateTime', descending: true)
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
                        colors.shuffle();
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Timestamp time =
                                  snapshot.data.docs[index].data()['dateTime'];
                              DateTime db = time.toDate();

                              final DateFormat formatter1 =
                                  new DateFormat.yMMMMd('en_US');
                              final DateFormat formatter2 =
                                  new DateFormat.jm('en_US');
                              bool isExpired = db.isBefore(DateTime.now());
                              String formatted = formatter1.format(db);

                              String formatted2 = formatter2.format(db);
                              colors.shuffle();
                              return ClassCard(
                                snap: snapshot.data.docs[index],
                                id: snapshot.data.docs[index].id,
                                isExpired: isExpired,
                                teacherName: snapshot.data.docs[index]
                                    .data()['teacherName'],
                                title:
                                    snapshot.data.docs[index].data()['title'],
                                desc: snapshot.data.docs[index].data()['desc'],
                                dateTime: formatted + " at $formatted2",
                                meetURL:
                                    snapshot.data.docs[index].data()['meetURL'],
                                subject:
                                    snapshot.data.docs[index].data()['subject'],
                                colorData: colors[0],
                                subjectIMG: snapshot.data.docs[index]
                                    .data()['subjectIMG'],
                              );
                            });
                      } else {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Text(
                              "Sorry, no classes available.",
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
                        "Sorry, no classes available.",
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

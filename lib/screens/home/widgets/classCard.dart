import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ClassCard extends StatefulWidget {
  final String title;
  final String desc;
  final DocumentSnapshot<Map> snap;
  final bool isExpired;
  final String teacherName;
  final String id;
  final String meetURL;
  final bool isGoing;
  final String dateTime;
  final String subject;
  final String subjectIMG;
  final Color colorData;

  ClassCard(
      {Key key,
      @required this.title,
      @required this.teacherName,
      @required this.snap,
      @required this.dateTime,
      @required this.colorData,
      @required this.isGoing,
      @required this.isExpired,
      @required this.subjectIMG,
      @required this.desc,
      @required this.id,
      @required this.meetURL,
      @required this.subject})
      : super(key: key);

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 250,
        margin: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          // image: DecorationImage(
          //   image: AssetImage('assets/images/covid.png'),
          // ),
          color: widget.colorData,
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              child: Center(
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(
                            bottom: 60, top: 1, right: 5, left: 5),
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.subjectIMG),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "QuickSand",
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              widget.isExpired
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Colors.red),
                                        child: Text(
                                          "Expired",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "QuickSand"),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          Text(
                            widget.desc,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontFamily: "QuickSand",
                              fontSize: 11.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.dateTime,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "QuickSand"),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: colors[0] == kBlueColor
                                        ? Colors.orange
                                        : Colors.blueAccent,
                                  ),
                                  child: Text(
                                    widget.subject,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "QuickSand"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('By: ${widget.teacherName}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: "QuickSand")),
                          SizedBox(height: 10),
                          FlatButton.icon(
                            onPressed: () async {
                              Clipboard.setData(
                                  ClipboardData(text: widget.meetURL));
                              showToast(msg: "Copied to clipboard!");
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                            label: Text('Copy meet link!',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: "QuickSand")),
                            textColor: Colors.white,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Text('I\'m going!',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: "QuickSand")),
                                Switch(
                                  value: widget.isGoing,
                                  activeColor: colors[0] == kBlueColor
                                      ? Colors.green
                                      : Colors.blueAccent,
                                  onChanged: (value) async {
                                    print('s1fa');
                                    if (value) {
                                      print('sfa');
                                      await FirebaseFirestore.instance
                                          .collection("classes")
                                          .doc(widget.id)
                                          .set(
                                        {
                                          'going': FieldValue.arrayUnion([
                                            FirebaseAuth
                                                .instance.currentUser.uid
                                          ]),
                                        },
                                        SetOptions(merge: true),
                                      );

                                      await FirebaseFirestore.instance
                                          .collection("classesN")
                                          .doc()
                                          .set(
                                        {
                                          'deviceToken': [
                                            widget.snap.data()['deviceToken']
                                          ]
                                        },
                                      );
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection("classes")
                                          .doc(widget.id)
                                          .set({
                                        'going': FieldValue.arrayRemove([
                                          FirebaseAuth.instance.currentUser.uid
                                        ])
                                      }, SetOptions(merge: true));
                                    }

                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Colors.orange.withOpacity(0.9);

List colors = [
  kBlueColor,
  kOrangeColor,
  kYellowColor,
];

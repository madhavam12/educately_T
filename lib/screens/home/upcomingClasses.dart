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
            ),
          ],
        ),
      ),
    );
  }
}

class ClassCard extends StatefulWidget {
  final String title;
  final String desc;
  final bool isExpired;
  final String teacherName;
  final String id;
  final String meetURL;
  final DocumentSnapshot<Map> snap;

  final String dateTime;
  final String subject;
  final String subjectIMG;
  final Color colorData;

  ClassCard(
      {Key key,
      @required this.title,
      @required this.teacherName,
      @required this.dateTime,
      @required this.snap,
      @required this.colorData,
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
  bool _switchValue = true;

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
                              Alert(
                                  context: context,
                                  title: "Students Joining",
                                  style: AlertStyle(
                                    titleStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily: "QuickSand"),
                                  ),
                                  content: Column(
                                    children: <Widget>[
                                      widget.snap.data()['goingURL'] == null
                                          ? Container(
                                              child: Text(
                                                "No student yet",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily: "QuickSand"),
                                              ),
                                            )
                                          : Container(
                                              height: 200,
                                              child: ListView.builder(
                                                  itemCount: widget.snap
                                                      .data()['goingURL']
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Card(
                                                      child: ListTile(
                                                        leading: Image.network(
                                                            widget.snap.data()[
                                                                    'goingURL']
                                                                [index]),
                                                        title: Text(widget.snap
                                                                    .data()[
                                                                'goingNames']
                                                            [index]),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "Close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: const Icon(
                              LineAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            label: Text('Students joining',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: "QuickSand")),
                            textColor: Colors.white,
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

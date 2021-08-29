import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/widgets.dart';
import 'widgets/classCard.dart';
import 'package:flutter/services.dart';

var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Colors.orange.withOpacity(0.9);

List colors = [
  kBlueColor,
  kOrangeColor,
  kYellowColor,
];

class TeacherDetailsScreen extends StatelessWidget {
  var kBackgroundColor = Color(0xffF9F9F9);
  var kWhiteColor = Color(0xffffffff);
  var kOrangeColor = Color(0xffEF716B);
  var kBlueColor = Color(0xff4B7FFB);
  var kYellowColor = Color(0xffFFB167);
  var kTitleTextColor = Color(0xff1E1C61);
  var kSearchBackgroundColor = Color(0xffF2F2F2);
  var kSearchTextColor = Color(0xffC0C0C0);
  var kCategoryTextColor = Color(0xff292685);

  String name;
  String subject;
  String imageUrl;

  String phoneNumber;
  String uid;
  TeacherDetailsScreen({
    this.name,
    this.phoneNumber,
    this.subject,
    this.uid,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('assets/images/detail_illustration.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.24,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Image.network(imageUrl,
                              height: 120, fit: BoxFit.cover),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kTitleTextColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  subject,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: kTitleTextColor.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        await canLaunch("tel:$phoneNumber")
                                            ? await launch("tel:$phoneNumber")
                                            : throw 'Could not launch';
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: kBlueColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/phone.svg',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await canLaunch("sms:$phoneNumber")
                                            ? await launch("sms:$phoneNumber")
                                            : throw 'Could not launch';
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: kYellowColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/chat.svg',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Contact $name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kTitleTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton.icon(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    onPressed: () async {
                                      await canLaunch("tel:$phoneNumber")
                                          ? await launch("tel:$phoneNumber")
                                          : throw 'Could not launch';
                                    },
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    icon: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Call Now',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    textColor: Colors.white,
                                  ),
                                  FlatButton.icon(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    onPressed: () async {
                                      await canLaunch("sms:$phoneNumber")
                                          ? await launch("sms:$phoneNumber")
                                          : throw 'Could not launch';
                                    },
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    icon: const Icon(
                                      Icons.chat_bubble,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Send SMS',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$name\'s classes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: "QuickSand",
                              color: kTitleTextColor,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map>>(
                          stream: FirebaseFirestore.instance
                              .collection('classes')
                              .where('uid', isEqualTo: uid)
                              .orderBy('dateTime', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            print(uid);
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text("${snapshot.error}");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.isNotEmpty) {
                                colors.shuffle();
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      Timestamp time = snapshot.data.docs[index]
                                          .data()['dateTime'];
                                      DateTime db = time.toDate();

                                      final DateFormat formatter1 =
                                          new DateFormat.yMMMMd('en_US');
                                      final DateFormat formatter2 =
                                          new DateFormat.jm('en_US');
                                      bool isExpired =
                                          db.isBefore(DateTime.now());
                                      String formatted = formatter1.format(db);

                                      String formatted2 = formatter2.format(db);
                                      colors.shuffle();
                                      return ClassCard(
                                        snap: snapshot.data.docs[index],
                                        id: snapshot.data.docs[index].id,
                                        isExpired: isExpired,
                                        teacherName: snapshot.data.docs[index]
                                            .data()['teacherName'],
                                        title: snapshot.data.docs[index]
                                            .data()['title'],
                                        desc: snapshot.data.docs[index]
                                            .data()['desc'],
                                        dateTime: formatted + " at $formatted2",
                                        meetURL: snapshot.data.docs[index]
                                            .data()['downloadURL'],
                                        subject: snapshot.data.docs[index]
                                            .data()['subject'],
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

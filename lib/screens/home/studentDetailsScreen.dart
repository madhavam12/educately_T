import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/widgets.dart';
import 'package:flutter/services.dart';

var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Colors.orange.withOpacity(0.9);

List colors = [
  kBlueColor,
  kOrangeColor,
  kYellowColor,
];

class StudentDetailsScreen extends StatelessWidget {
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
  String about;
  String imageUrl;
  String standard;
  String phoneNumber;
  String uid;
  StudentDetailsScreen({
    this.name,
    this.phoneNumber,
    this.standard,
    this.about,
    this.uid,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    print(phoneNumber);
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
                  height: 50,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.24,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
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
                                  about,
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
                                'About',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kTitleTextColor,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                about,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: kTitleTextColor,
                                ),
                              ),
                            ),
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
                            'Classes $name\'s attending',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "QuickSand",
                              color: kTitleTextColor,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map>>(
                          stream: FirebaseFirestore.instance
                              .collection('classes')
                              .where('going', arrayContainsAny: [uid])
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

class ClassCard extends StatefulWidget {
  final String title;
  final String desc;
  final bool isExpired;
  final String teacherName;

  final String meetURL;
  final String dateTime;
  final String subject;
  final String subjectIMG;
  final Color colorData;
  final String id;
  ClassCard(
      {Key key,
      @required this.title,
      @required this.teacherName,
      @required this.dateTime,
      @required this.id,
      @required this.colorData,
      @required this.isExpired,
      @required this.subjectIMG,
      @required this.desc,
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
                                Text('I am going!',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: "QuickSand")),
                                Switch(
                                  value: _switchValue,
                                  activeColor: Colors.blueAccent,
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

                                    setState(() {
                                      _switchValue = value;
                                    });
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

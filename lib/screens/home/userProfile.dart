import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:educately_t/services/FirebaseAuthService.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:educately_t/screens/login/loginScreen.dart';

import 'package:educately_t/screens/profileEdit/profileEditScreen.dart';

import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  DocumentSnapshot<Map> doc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDoc();
  }

  initializeDoc() async {
    doc = await FirebaseFirestore.instance
        .collection("students")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    setState(() {});
  }

  String formatted3;

  String getDate() {
    Timestamp time = doc.data()['dateAndTime'];
    DateTime db = time.toDate();

    final DateFormat formatter1 = new DateFormat.yMMMMd('en_US');

    formatted3 = formatter1.format(db);
    setState(() {});
    return formatted3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: doc == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(
                              //     top: 25.0, left: 15, right: 15, bottom: 15),
                              padding: EdgeInsets.all(75.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  image:
                                      NetworkImage("${doc.data()['photoURL']}"),
                                  fit: BoxFit.contain,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Joined on",
                                    maxLines: 5,
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "QuickSand",
                                      fontSize: 25.0,
                                    ),
                                  ),
                                  Text(
                                    "${getDate()}",
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "QuickSand",
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    doc.data()['standard'],
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Colors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "QuickSand",
                                      fontSize: 13.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${doc.data()['name']}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QuickSand",
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      OptionRow(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileCreationView(),
                            ),
                          );
                        },
                        iconColor2: Color(0xFFFEF0E4),
                        text: "Edit Profile",
                        iconData: LineAwesomeIcons.pencil_ruler,
                        iconColor: Color(0xFFFE6D1E),
                      ),
                      OptionRow(
                        onTap: () {
                          final Uri _emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'madhavam.shahi.12@gmail.com',
                              queryParameters: {
                                'subject': 'Suggestions / Bug Report'
                              });

                          launch(_emailLaunchUri.toString());
                        },
                        iconColor2: Color(0xFFE4F7FF),
                        text: "Contact Us",
                        iconData: LineAwesomeIcons.envelope,
                        iconColor: Color(0xFF02A2EE),
                      ),
                      OptionRow(
                        onTap: () async {
                          FirebaseAuthService _authService =
                              FirebaseAuthService();
                          await _authService.signOut();
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        iconColor2: Color(0xFFF989A4),
                        text: "Sign out",
                        iconData: LineAwesomeIcons.alternate_sign_out,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class OptionRow extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData iconData;
  final Color iconColor;
  final Color iconColor2;
  OptionRow(
      {@required this.iconColor,
      @required this.iconColor2,
      @required this.onTap,
      @required this.iconData,
      @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: iconColor2,
              child: Icon(
                iconData,
                color: iconColor,
              ),
            ),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "QuickSand",
                fontSize: 20.0,
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFFF4F4F6),
              child: Icon(
                LineAwesomeIcons.arrow_right,
                color: Color(0xFF3B3C48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

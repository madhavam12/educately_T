import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:educately_t/models/notes.dart';

import 'package:intl/intl.dart';

import 'widgets/modalBottomSheet.dart';

import 'widgets/notesCard.dart';

class NotesScreen extends StatefulWidget {
  final String subject;
  final String subjectIMG;
  final String standard;
  NotesScreen(
      {Key key,
      @required this.subject,
      @required this.subjectIMG,
      @required this.standard})
      : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          bottomSheet(
              context: context,
              subject: widget.subject,
              subjectIMG: widget.subjectIMG,
              standard: widget.standard);
        },
        label: Text('Upload notes'),
        icon: Icon(LineAwesomeIcons.upload),
        backgroundColor: Colors.blueAccent,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(LineAwesomeIcons.arrow_left, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(
                  25.0,
                ),
                child: Text(
                  "Notes for ${widget.subject}(Std ${widget.standard}): ",
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
                      .collection("notes")
                      .where('standard', isEqualTo: "${widget.standard}")
                      .where(
                        'subject',
                        isEqualTo: widget.subject,
                      )
                      .orderBy('dateAndTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        print('here');

                        if (snapshot.data.docs.isEmpty) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/notFound.png',
                                      height: 250),
                                  SizedBox(height: 20),
                                  Text(
                                    "No notes found",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "QuickSand",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              Notes note = Notes.fromJson(
                                  snapshot.data.docs[index].data());

                              Timestamp time = snapshot.data.docs[index]
                                  .data()['dateAndTime'];
                              DateTime db = time.toDate();

                              final DateFormat formatter1 =
                                  new DateFormat.yMMMMd('en_US');

                              String formatted = formatter1.format(db);

                              colors.shuffle();
                              return Container(
                                margin: EdgeInsets.all(15),
                                child: NotesCard(
                                  note.userName,
                                  note.desc,
                                  note.subjectIMG,
                                  note.downloadURL,
                                  colors[0],
                                  formatted,
                                ),
                              );
                            }); // data
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset('assets/images/notFound.png',
                                    height: 250),
                                SizedBox(height: 20),
                                Text(
                                  "No notes found",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "QuickSand",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ); // no data
                      }
                    } else {
                      return Center(
                          child: CircularProgressIndicator()); // loading
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

var kOrangeColor = Color(0xffEF716B);
var kBlueColor = Color(0xff4B7FFB);
var kYellowColor = Color(0xffFFB167);

List colors = [
  kBlueColor,
  kOrangeColor,
  kYellowColor,
];

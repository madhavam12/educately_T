import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../widgets/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:educately_t/models/notes.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:educately_t/services/firebaseStorageService.dart';
import 'package:educately_t/models/notes.dart';

import 'package:educately_t/services/firestoreDatabaseService.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';

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
  File file;
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                focusNode: focusNode,
                                controller: controller,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                onSubmitted: (String name) {
                                  // _titleFocus.unfocus();
                                  // FocusScope.of(context).requestFocus(_descFocus);
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                  prefixIcon: Icon(LineAwesomeIcons.text_height,
                                      color: Colors.black),
                                  filled: true,
                                  labelText: "Description",
                                  hintText:
                                      "Example, notes for colid state chapter.",
                                  fillColor: Color(0xFFeae9e0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 30,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: EdgeInsets.all(
                                            25.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Add notes",
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "QuickSand",
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                              file != null
                                                  ? Text(
                                                      "Added ${basename(file.path)}",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "QuickSand",
                                                        fontSize: 8.0,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles();

                                          if (result != null) {
                                            setState(() {
                                              file = File(
                                                  result.files.single.path);
                                            });
                                          } else {
                                            showToast(
                                                msg: "Operation Cancelled",
                                                isLong: false);
                                            // User canceled the picker
                                          }
                                        },
                                        child: Icon(
                                            LineAwesomeIcons.plus_circle,
                                            color: Colors.blue,
                                            size: 35),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            child: Text('Post Notes'),
                            onPressed: () async {
                              loadingBar(context);
                              if (controller.text == "") {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showToast(
                                    msg: "Please enter a short description",
                                    isLong: false);

                                return 0;
                              }
                              if (file == null) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showToast(
                                    msg: "Please add a file to continue",
                                    isLong: false);

                                return 0;
                              }

                              FirebaseStorageService storage =
                                  FirebaseStorageService();

                              var url =
                                  await storage.uploadFileAndGetDownloadUrl(
                                      file: file,
                                      uid: FirebaseAuth
                                          .instance.currentUser.uid);

                              Firestore _db = Firestore();
                              Notes note = Notes(
                                  desc: controller.text,
                                  userName: FirebaseAuth
                                      .instance.currentUser.displayName,
                                  subject: widget.subject,
                                  standard: widget.standard,
                                  downloadURL: url,
                                  subjectIMG: widget.subjectIMG);
                              await _db.uploadNotes(notes: note);
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pop(context);
                              showToast(
                                  msg: "Posted Successfully!", isLong: false);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          );
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

class NotesCard extends StatelessWidget {
  String _name;
  String _description;
  String _imageUrl;
  String _downloadURL;
  Color _bgColor;
  String _date;
  NotesCard(
    this._name,
    this._description,
    this._imageUrl,
    this._downloadURL,
    this._bgColor,
    this._date,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Image.network(_imageUrl),
          trailing: GestureDetector(
            onTap: () async {
              String path = await ExtStorage.getExternalStoragePublicDirectory(
                  ExtStorage.DIRECTORY_DOWNLOADS);
              //String fullPath = tempDir.path + "/boo2.pdf'";
              String fullPath = "$path/${_description}.pdf";

              var dio = Dio();

              await download2(dio, _downloadURL, fullPath, context);

              showToast(msg: "Sucessfully downloaded the file!");
            },
            child: Icon(LineAwesomeIcons.file_download,
                size: 30, color: Colors.black),
          ),
          title: Text(
            _description,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Posted By:" + _name,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Text(
                "Posted On: $_date",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future download2(Dio dio, String url, String savePath, context) async {
  try {
    Response response = await dio.get(
      url,

      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}

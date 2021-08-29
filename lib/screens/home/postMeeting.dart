import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:educately_t/services/firebaseStorageService.dart';
import 'package:connection_verify/connection_verify.dart';

import 'package:educately_t/models/classModel.dart';
import 'package:educately_t/services/firestoreDatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educately_t/services/firebaseMessagingService.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostMeeting extends StatefulWidget {
  PostMeeting({Key key}) : super(key: key);

  @override
  _PostMeetingState createState() => _PostMeetingState();
}

class _PostMeetingState extends State<PostMeeting> {
  TextEditingController titleController = TextEditingController();

  FocusNode titleNode = FocusNode();

  TextEditingController desc = TextEditingController();

  FocusNode descNode = FocusNode();

  TextEditingController meetURLController = TextEditingController();

  FocusNode meetNode = FocusNode();

  TextEditingController subjectController = TextEditingController();

  FocusNode subjectNode = FocusNode();
  TextEditingController standardController = TextEditingController();

  FocusNode standardNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/images/online.png',
                      height: 250, fit: BoxFit.cover),
                ),
                Container(
                  child: Text(
                    "Conduct an online class.",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "QuickSand",
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GetTextField(
                    controller: titleController,
                    focusNode: titleNode,
                    iconData: LineAwesomeIcons.text_height,
                    labelText: "Title",
                    hintText: "Example, Solid State Revision for class 12th"),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Description",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand",
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GetTextField(
                    controller: desc,
                    focusNode: descNode,
                    iconData: LineAwesomeIcons.text_height,
                    labelText: "Description",
                    hintText:
                        "Example, join the session to learn solid state chapter"),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Subject",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand",
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Standard(),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Class",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand",
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SubjectsTaught(),
                SizedBox(height: 15),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Select the Date & Time',
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    dateTime = Timestamp.fromDate(value);
                  },
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Meeting Link",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand",
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                GetTextField(
                    controller: meetURLController,
                    focusNode: meetNode,
                    iconData: LineAwesomeIcons.text_height,
                    labelText: "Meeting URL",
                    hintText:
                        "Create a meet on Zoom or Google meet and paste link here"),
                GestureDetector(
                  onTap: () async {
                    if (titleController.text == "" ||
                        desc.text == "" ||
                        dateTime == null ||
                        meetURLController.text == "" ||
                        subjects == "" ||
                        standard == "") {
                      showInSnackBar(
                          context: context,
                          value: "Please fill all the fields",
                          color: Colors.red);
                      return 0;
                    }

                    openLoadingDialog(context, "Posting");

                    if (await ConnectionVerify.connectionStatus()) {
                      Firestore _firestoreService = Firestore();
                      DocumentSnapshot<Map> snap = await FirebaseFirestore
                          .instance
                          .collection('subjects')
                          .doc(subjects)
                          .get();
                      String token = await FireMessage().deviceToken;
                      await _firestoreService.uploadClass(
                        classModel: ClassModel(
                          deviceToken: [token],
                          dateAndTime: dateTime,
                          uid: FirebaseAuth.instance.currentUser.uid,
                          standard: standard,
                          desc: desc.text,
                          subjectIMG: snap.data()['img'],
                          teacherName:
                              FirebaseAuth.instance.currentUser.displayName,
                          subject: subjects,
                          meetURL: meetURLController.text,
                          title: titleController.text,
                        ),
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                      showInSnackBar(
                          context: context,
                          value: "Posted Successfully!",
                          color: Colors.green);
                      return 0;
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                      showInSnackBar(
                          context: context,
                          value:
                              "No Internet connection. Please connect to the internet and then try again.",
                          color: Colors.red);
                      return 0;
                    }
                  },
                  child: Container(
                    height: 45,
                    // padding: EdgeInsets.all(20.0),
                    width: double.infinity,
                    margin: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                          letterSpacing: .95,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "QuickSand",
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Timestamp dateTime;
void showInSnackBar(
    {String value, Color color, int sec = 3, @required BuildContext context}) {
  FocusScope.of(context).requestFocus(new FocusNode());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansSemiBold"),
    ),
    backgroundColor: color,
    duration: Duration(seconds: sec),
  ));
}

class GetTextField extends StatelessWidget {
  final FocusNode focusNode;

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData iconData;
  const GetTextField(
      {Key key,
      @required this.iconData,
      @required this.controller,
      @required this.hintText,
      @required this.labelText,
      @required this.focusNode})
      : super(key: key);

  getkeyboardType() {
    if (labelText == "Phone Number") {
      return TextInputType.number;
    } else if (labelText == "Email") {
      return TextInputType.emailAddress;
    } else {
      return TextInputType.name;
    }
  }

  getMaxLength() {
    if (labelText == "Phone Number") {
      return 10;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 15.0,
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: getkeyboardType(),
        onSubmitted: (String name) {
          // _titleFocus.unfocus();
          // FocusScope.of(context).requestFocus(_descFocus);
        },
        maxLength: getMaxLength(),
        cursorColor: Colors.black,
        style: TextStyle(
            fontSize: 17.5, fontWeight: FontWeight.normal, color: Colors.black),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          hintStyle: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
          prefixIcon: Icon(iconData, color: Colors.black),
          filled: true,
          labelText: labelText,
          hintText: hintText,
          fillColor: Color(0xFFeae9e0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

openLoadingDialog(BuildContext context, String text) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            content: Row(children: <Widget>[
              CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.black)),
              Expanded(
                child: Text(text),
              ),
            ]),
          ));
}

class Standard extends StatefulWidget {
  Standard({Key key}) : super(key: key);

  @override
  _StandardState createState() => _StandardState();
}

class _StandardState extends State<Standard> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      dropdownSearchDecoration: InputDecoration(
        filled: true,
        // contentPadding: EdgeInsets.all(7.0),
        fillColor: Colors.white,
        // border: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: Colors.black, width: 5.0),
        // ),

        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.black),
      ),
      items: [
        "8th",
        "8th-9th",
        "9th",
        "9th & 10th",
        "10th",
        "11th",
        "11th & 12th",
        "12th",
        "10th-12th",
        "9th,10th,11th,12th",
      ],
      label: "Classes Taught",
      onChanged: (sp) {
        standard = sp;
      },
      hint: "Classes",
      selectedItem: "10th",
      validator: (String item) {},
      mode: Mode.BOTTOM_SHEET,
    );
  }
}

String standard = "10th";

String subjects = "English";

class SubjectsTaught extends StatefulWidget {
  SubjectsTaught({Key key}) : super(key: key);

  @override
  _SubjectsTaughtState createState() => _SubjectsTaughtState();
}

class _SubjectsTaughtState extends State<SubjectsTaught> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      dropdownSearchDecoration: InputDecoration(
        filled: true,
        // contentPadding: EdgeInsets.all(7.0),
        fillColor: Colors.white,
        // border: OutlineInputBorder(
        //   borderSide:
        //       BorderSide(color: Colors.black, width: 5.0),
        // ),

        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.black),
      ),
      items: [
        "English",
        "Physics",
        "Chemistry",
        "History",
        "Geography",
        "Biology",
        "Maths",
        "Computers",
      ],
      label: "Subjects Taught",
      onChanged: (sp) {
        subjects = sp;
      },
      hint: "Subjects",
      selectedItem: "English",
      validator: (String item) {},
      mode: Mode.BOTTOM_SHEET,
    );
  }
}

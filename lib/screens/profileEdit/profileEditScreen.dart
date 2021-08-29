import 'package:educately_t/services/firestoreDatabaseService.dart';
import 'package:flutter/material.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:hive/hive.dart';

import 'package:hive/hive.dart';
import 'package:educately_t/services/firebaseStorageService.dart';
import 'package:educately_t/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:educately_t/services/geolocationService.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:educately_t/models/user.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educately_t/screens/home/homeScreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:connection_verify/connection_verify.dart';
import 'package:educately_t/services/FirebaseAuthService.dart';

import 'package:educately_t/services/firestoreDatabaseService.dart';

class ProfileCreationView extends StatefulWidget {
  @override
  _ProfileCreationViewState createState() => _ProfileCreationViewState();
}

class _ProfileCreationViewState extends State<ProfileCreationView> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _aboutFocus = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(
      {String value,
      Color color,
      int sec = 3,
      @required BuildContext context}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: color,
      duration: Duration(seconds: sec),
    ));
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameController.text = FirebaseAuth.instance.currentUser.displayName;
  }

  File _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        showInSnackBar(
            value: "No image selected",
            sec: 4,
            color: Colors.red,
            context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Let's setup your profile.",
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(
                      "Please enter some basic details to continue.",
                      style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "QuickSand",
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(
                        //     top: 25.0, left: 15, right: 15, bottom: 15),
                        padding: EdgeInsets.all(75.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: _image == null
                                ? NetworkImage(
                                    '${FirebaseAuth.instance.currentUser.photoURL}')
                                : FileImage(_image),
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
                      Positioned(
                        bottom: 10,
                        right: 75,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              getImage();
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GetTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    iconData: LineAwesomeIcons.user,
                    labelText: "Name",
                    hintText: "Write your name"),
                GetTextField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    iconData: LineAwesomeIcons.user,
                    labelText: "Phone Number",
                    hintText: "Please write your number"),
                GetTextField(
                    controller: _aboutController,
                    focusNode: _aboutFocus,
                    iconData: LineAwesomeIcons.text_height,
                    labelText: "About",
                    hintText: "Write something about yourself."),
                SizedBox(
                  height: 20,
                ),
                Standard(),
                SizedBox(
                  height: 20,
                ),
                SubjectsTaught(),
                GestureDetector(
                  onTap: () async {
                    if (_nameController.text == "" ||
                        _phoneController.text == "" ||
                        _aboutController.text == "" ||
                        standard == "") {
                      showInSnackBar(
                          context: context,
                          value: "Please fill all the fields",
                          color: Colors.red);
                      return 0;
                    }

                    openLoadingDialog(context, "Creating");

                    FirebaseStorageService _firebaseStorageService =
                        FirebaseStorageService();
                    var imgUpload;
                    if (_image != null) {
                      imgUpload = await _firebaseStorageService
                          .uploadImageAndGetDownloadUrl(
                        image: _image,
                        uid: FirebaseAuth.instance.currentUser.uid,
                      );
                      await FirebaseAuth.instance.currentUser
                          .updatePhotoURL(imgUpload[0]);
                    }

                    if (imgUpload is String) {
                      Navigator.of(context, rootNavigator: true).pop();
                      showInSnackBar(
                          context: context,
                          value: imgUpload,
                          color: Colors.red);
                      return 0;
                    }

                    if (await ConnectionVerify.connectionStatus()) {
                      Firestore _firestoreService = Firestore();

                      GeolocationService loc = GeolocationService();
                      List cityName = await loc.determinePosition();

                      if (cityName[0] == false) {
                        Navigator.of(context, rootNavigator: true).pop();
                        showInSnackBar(
                            context: context,
                            value: cityName[1],
                            color: Colors.red);
                        return 0;
                      }
                      TeacherModel user = TeacherModel(
                        about: _aboutController.text,
                        email: FirebaseAuth.instance.currentUser.email,
                        number: _phoneController.text,
                        uid: FirebaseAuth.instance.currentUser.uid,
                        photoURL: imgUpload != null
                            ? imgUpload[0]
                            : FirebaseAuth.instance.currentUser.photoURL,
                        subjectsTaught: subjects,
                        classesTaught: standard,
                        cityName: cityName[1],
                        name: _nameController.text,
                      );
                      var create = await _firestoreService.createStudentProfile(
                          student: user);

                      if (create is String) {
                        Navigator.of(context, rootNavigator: true).pop();
                        showInSnackBar(
                            context: context, value: create, color: Colors.red);
                        return 0;
                      } else {
                        saveStateToHive('0');
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }
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

void saveStateToHive(String state) {
  // state- 0=created just now using the creation page. 1= had created before, loggin in this time. null=no created
  var box = Hive.box('hasFilled');

  box.put('state', state);
}

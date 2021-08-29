import 'package:flutter/material.dart';

import 'package:educately_t/services/firebaseStorageService.dart';

import 'package:educately_t/services/firestoreDatabaseService.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:educately_t/models/notes.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import '../../widgets/widgets.dart';

void bottomSheet(
    {@required BuildContext context,
    @required String subject,
    @required String subjectIMG,
    @required String standard}) async {
  File file;
  print('dd');
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
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
                          bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          hintText: "Example, notes for colid state chapter.",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                letterSpacing: 1.5,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.bold,
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
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    setState(() {
                                      file = File(result.files.single.path);
                                    });
                                  } else {
                                    showToast(
                                        msg: "Operation Cancelled",
                                        isLong: false);
                                    // User canceled the picker
                                  }
                                },
                                child: Icon(LineAwesomeIcons.plus_circle,
                                    color: Colors.blue, size: 35),
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
                        Navigator.of(context, rootNavigator: true).pop();
                        showToast(
                            msg: "Please enter a short description",
                            isLong: false);

                        return 0;
                      }
                      if (file == null) {
                        Navigator.of(context, rootNavigator: true).pop();
                        showToast(
                            msg: "Please add a file to continue",
                            isLong: false);

                        return 0;
                      }

                      FirebaseStorageService storage = FirebaseStorageService();

                      var url = await storage.uploadFileAndGetDownloadUrl(
                          file: file,
                          uid: FirebaseAuth.instance.currentUser.uid);

                      Firestore _db = Firestore();
                      Notes note = Notes(
                          desc: controller.text,
                          userName:
                              FirebaseAuth.instance.currentUser.displayName,
                          subject: subject,
                          standard: standard,
                          downloadURL: url,
                          subjectIMG: subjectIMG);
                      await _db.uploadNotes(notes: note);
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context);
                      showToast(msg: "Posted Successfully!", isLong: false);
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
}

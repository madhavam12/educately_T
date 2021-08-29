import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:educately_t/models/notes.dart';
import 'dart:async';
import 'package:educately_t/models/user.dart';
import 'package:educately_t/models/classModel.dart';

class Firestore {
  final _firestore = FirebaseFirestore.instance;

  Future<void> uploadNotes({@required Notes notes}) async {
    await _firestore.collection('notes').doc().set(notes.toJson());
  }

  Future<void> uploadClass({@required ClassModel classModel}) async {
    await _firestore.collection('classes').doc().set(classModel.toJson());
  }

  Future createStudentProfile({@required TeacherModel student}) async {
    await _firestore
        .collection('teachers')
        .doc(student.uid)
        .set(student.toJson())
        .catchError((e) => e);
  }

  Future<bool> hasFilledData({@required String uid}) async {
    DocumentSnapshot<Map> doc =
        await _firestore.collection('teachers').doc(uid).get();

    if (!doc.exists) {
      return false;
    }
    if (doc.data()['dateAndTime'] == null) {
      return false;
    }
    return true;
  }
}

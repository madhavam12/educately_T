import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:educately/models/notes.dart';
import 'dart:async';
import 'package:educately/models/user.dart';

class Firestore {
  final _firestore = FirebaseFirestore.instance;

  Future<void> uploadNotes({@required Notes notes}) async {
    await _firestore.collection('notes').doc().set(notes.toJson());
  }

  Future createStudentProfile({@required UserModel student}) async {
    await _firestore
        .collection('students')
        .doc(student.uid)
        .set(student.toJson())
        .catchError((e) => e);
  }

  Future<bool> hasFilledData({@required String uid}) async {
    DocumentSnapshot<Map> doc =
        await _firestore.collection('students').doc(uid).get();

    if (!doc.exists) {
      return false;
    }
    if (doc.data()['dateAndTime'] == null) {
      return false;
    }
    return true;
  }
}

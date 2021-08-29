import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherModel {
  final String name;

  final String uid;

  final String classesTaught;
  final String photoURL;
  final String about;
  final String email;
  final String number;
  final String cityName;

  final String subjectsTaught;
  Timestamp dateAndTime;

  TeacherModel({
    @required this.name,
    @required this.classesTaught,
    @required this.photoURL,
    @required this.about,
    @required this.uid,
    @required this.email,
    @required this.number,
    @required this.subjectsTaught,
    @required this.cityName,
  });

  TeacherModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        cityName = json['cityName'],
        email = json['email'],
        about = json['about'],
        subjectsTaught = json['subjectsTaught'],
        photoURL = json['photoURL'],
        number = json['number'],
        classesTaught = json['classesTaught'],
        uid = json['uid'],
        dateAndTime = json['dateAndTime'];

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'uid': uid,
        'number': number,
        'photoURL': photoURL,
        'subjectsTaught': subjectsTaught,
        'about': about,
        'classesTaught': classesTaught,
        'name': name,
        'dateAndTime': Timestamp.now(),
        'email': email,
      };
}

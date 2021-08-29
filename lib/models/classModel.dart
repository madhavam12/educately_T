import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassModel {
  final String teacherName;

  final String desc;
  final List deviceToken;
  final String title;
  final String standard;
  final String subject;

  final String subjectIMG;

  final String meetURL;
  final String uid;
  final Timestamp dateAndTime;

  ClassModel(
      {@required this.desc,
      @required this.meetURL,
      @required this.standard,
      @required this.deviceToken,
      @required this.dateAndTime,
      @required this.uid,
      @required this.title,
      @required this.subjectIMG,
      @required this.teacherName,
      @required this.subject});

  ClassModel.fromJson(Map<String, dynamic> json)
      : teacherName = json['teacherName'],
        subject = json['subject'],
        uid = json['uid'],
        desc = json['desc'],
        dateAndTime = json['dateTime'],
        title = json['title'],
        deviceToken = json['deviceToken'],
        meetURL = json['downloadURL'],
        standard = json['standard'],
        subjectIMG = json['subjectIMG'];

  Map<String, dynamic> toJson() => {
        'teacherName': teacherName,
        "downloadURL": meetURL,
        'uid': uid,
        'deviceToken': deviceToken,
        "dateTime": dateAndTime,
        "title": title,
        "standard": standard,
        "subjectIMG": subjectIMG,
        "desc": desc,
        "subject": subject,
        'dateAndTime': Timestamp.now(),
      };
}

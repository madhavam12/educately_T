import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notes {
  final String userName;

  final String desc;

  final String standard;
  final String subject;

  final String subjectIMG;

  final String downloadURL;

  Timestamp dateAndTime;

  Notes(
      {@required this.desc,
      @required this.downloadURL,
      @required this.standard,
      @required this.subjectIMG,
      @required this.userName,
      @required this.subject});

  Notes.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        subject = json['subject'],
        desc = json['desc'],
        downloadURL = json['downloadURL'],
        standard = json['standard'],
        subjectIMG = json['subjectIMG'],
        dateAndTime = json['dateAndTime'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        "downloadURL": downloadURL,
        "standard": standard,
        "subjectIMG": subjectIMG,
        "desc": desc,
        "subject": subject,
        'dateAndTime': Timestamp.now(),
      };
}

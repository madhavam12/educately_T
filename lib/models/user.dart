import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String name;

  final String uid;

  final String standard;
  final String photoURL;
  final String about;
  final String email;
  final String number;
  final String cityName;

  Timestamp dateAndTime;

  UserModel({
    @required this.name,
    @required this.standard,
    @required this.photoURL,
    @required this.about,
    @required this.uid,
    @required this.email,
    @required this.number,
    @required this.cityName,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        cityName = json['cityName'],
        email = json['email'],
        about = json['about'],
        photoURL = json['photoURL'],
        number = json['number'],
        standard = json['standard'],
        uid = json['uid'],
        dateAndTime = json['dateAndTime'];

  Map<String, dynamic> toJson() => {
        'cityName': cityName,
        'uid': uid,
        'number': number,
        'photoURL': photoURL,
        'about': about,
        'standard': standard,
        'name': name,
        'dateAndTime': Timestamp.now(),
        'email': email,
      };
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login/loginScreen.dart';
import 'screens/profileEdit/profileEditScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:educately_t/screens/home/homeScreen.dart';
import 'package:hive/hive.dart';

import 'screens/profileEdit/profileEditScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

void main() async {
  SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('google.com');

  _simpleConnectionChecker.onConnectionChange.listen((connected) {
    if (!connected) {
      Fluttertoast.showToast(
          msg: "No internet connection, please connect to the internet",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  await Hive.openBox('hasFilled');
  await Hive.openBox('city');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(
    child: LiquidApp(materialApp: MaterialApp(home: getRoute())),
  ));
}

Widget getRoute() {
  var box = Hive.box('hasFilled');

  if (FirebaseAuth.instance.currentUser == null) {
    return LoginScreen();
  }

  if (box.get("state") == "0" || box.get("state") == "1") {
    print('here 1');
    return HomeScreen();
  }
  return ProfileCreationView();
}

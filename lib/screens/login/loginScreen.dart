import 'package:flutter/material.dart';
import 'package:educately_t/services/firebaseAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/homeScreen.dart';
import 'package:educately_t/screens/profileEdit/profileEditScreen.dart';
import 'package:flutter/services.dart';
import '../widgets/widgets.dart';
import 'package:educately_t/services/firestoreDatabaseService.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                Image.asset("assets/images/login.png", height: 250),
                Text(
                  "Tap below to login",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "QuickSand",
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                        top: 3.0, bottom: 3.0, left: 15.0, right: 15),
                    color: const Color(0xFF4285F4),
                    onPressed: () async {
                      if (!(await ConnectionVerify.connectionStatus())) {
                        showInSnackBar(
                            context: context,
                            value:
                                "No Internet connection. Please connect to the internet and then try again.",
                            color: Colors.red);
                        return 0;
                      }

                      try {
                        var authService = FirebaseAuthService();

                        var check = await authService.signInWithGoogle();
                        if (check is String) {
                          showInSnackBar(
                              context: context,
                              value: check,
                              color: Colors.red,
                              sec: 8);
                          return 0;
                        }

                        Firestore _db = Firestore();
                        bool hasFilled = await _db.hasFilledData(
                            uid: FirebaseAuth.instance.currentUser.uid);
                        if (hasFilled) {
                          saveStateToHive("1");
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                          return 0;
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileCreationView()));
                          return 0;
                        }
                      } catch (e) {
                        if (e is PlatformException) {
                          String errorMessage =
                              getErrorMessage1(errorCode: e.code);
                          if (errorMessage != null) {
                            showInSnackBar(
                                context: context,
                                value: "${e.message}",
                                color: Colors.red,
                                sec: 8);
                            return 0;
                          }
                        }

                        if (e is FirebaseAuthException) {
                          String errorMessage =
                              getErrorMessage1(errorCode: e.code);
                          showInSnackBar(
                              context: context,
                              value: "$errorMessage.",
                              color: Colors.red,
                              sec: 8);
                          return 0;
                        }
                        print(e);
                        showInSnackBar(
                            context: context,
                            value: "Unknown error occured.",
                            color: Colors.red,
                            sec: 8);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/google_logo.png',
                          height: 48.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Text(
                            "Sign in with Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void saveStateToHive(String state) {
  // state- 0=created just now using the creation page. 1= had created before, loggin in this time. null=no created
  var box = Hive.box('hasFilled');

  box.put('state', state);
}

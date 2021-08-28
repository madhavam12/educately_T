import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'upcomingClasses.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:educately_t/services/randomFactService.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/sidebaritems.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'userProfile.dart';
import 'package:provider/provider.dart';

import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:liquid_ui/liquid_ui.dart';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
// QrService _qrService = locator<QrService>();

import 'nearbyTutors.dart';

final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  void changeIndex({@required int index}) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    String formatter = DateFormat.yMMMMd('en_US').format(now);

    Size size = MediaQuery.of(context).size;
    return SideMenu(
      closeIcon: Icon(LineAwesomeIcons.times, color: Colors.black, size: 35),
      key: _endSideMenuKey,
      background: Color(0xFFedeeef),
      type: SideMenuType.slide,
      menu: buildMenu(
        context,
        _endSideMenuKey,
      ),
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color(0xFFFFFFFF),
          child: DotNavigationBar(
            // itemPadding: EdgeInsets.all(5),
            currentIndex: currentIndex,
            onTap: (index) {
              changeIndex(index: index);

              pageController.jumpToPage(index);
            },
            dotIndicatorColor: Colors.orange,
            items: [
              DotNavigationBarItem(
                icon: Icon(
                  LineAwesomeIcons.home,
                ),
                selectedColor: Colors.orange,
              ),

              /// Likes
              DotNavigationBarItem(
                icon: Icon(LineAwesomeIcons.newspaper),
                selectedColor: Colors.orange,
              ),

              /// Search
              DotNavigationBarItem(
                icon: Icon((LineAwesomeIcons.list)),
                selectedColor: Colors.orange,
              ),

              /// Profile
              DotNavigationBarItem(
                icon: Icon(LineAwesomeIcons.user_astronaut),
                selectedColor: Colors.orange,
              ),
            ],
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // final _state = _endSideMenuKey.currentState;

                                // if (_state.isOpened)
                                //   _state.closeSideMenu();
                                // else
                                //   _state.openSideMenu();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15.0, top: 25),
                                child: GestureDetector(
                                  onTap: () {
                                    final _state = _endSideMenuKey.currentState;

                                    if (_state.isOpened)
                                      _state.closeSideMenu();
                                    else
                                      _state.openSideMenu();
                                  },
                                  child: Icon(LineAwesomeIcons.bars,
                                      color: Colors.black, size: 40),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 15.0, top: 25),
                              child: Text(
                                "${DateFormat('EEEE').format(DateTime.now())}, $formatter",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "QuickSand",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height / 9),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.all(
                                  10.0,
                                ),
                                child: Text(
                                  "Find Notes: ",
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
                            Container(
                              height: 180,
                              // margin: EdgeInsets.all(15),
                              child: StreamBuilder<QuerySnapshot<Map>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('subjects')
                                      .where('img', isNotEqualTo: null)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot<Map>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      if (snapshot.hasData) {
                                        print(
                                          snapshot.data.docs.length,
                                        );
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data.docs.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  DocumentSnapshot<Map> user =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'students')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .get();
                                                  print(user.data());
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         NotesScreen(
                                                  //       standard: user
                                                  //           .data()['standard'],
                                                  //       subjectIMG: snapshot
                                                  //           .data.docs[index]
                                                  //           .data()['img'],
                                                  //       subject: snapshot
                                                  //           .data.docs[index]
                                                  //           .data()['name'],
                                                  //     ),
                                                  //   ),
                                                  // );
                                                },
                                                child: SubjectsCard(
                                                  imgPath: snapshot
                                                      .data.docs[index]
                                                      .data()['img'],
                                                  name: snapshot
                                                      .data.docs[index]
                                                      .data()['name'],
                                                ),
                                              );
                                            }); // data
                                      } else if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      } else {
                                        return Text('No data'); // no data
                                      }
                                    } else {
                                      return Center(
                                          child:
                                              CircularProgressIndicator()); // loading
                                    }
                                  }),
                            )
                          ],
                        ),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 25.0,
                              ),
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/teacher.png'),
                            ),
                            color: Colors.blue,
                          ),
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.black.withOpacity(0.8),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: [0.1, 1.0],
                                      tileMode: TileMode.clamp)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50),
                                      Text(
                                        "Find a tutor nearby",
                                        style: TextStyle(
                                          letterSpacing: 1.5,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "QuickSand",
                                          fontSize: 25.0,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FlatButton.icon(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NearbyTutors()));
                                        },
                                        color: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        icon: const Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Find Now',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "QuickSand"),
                                        ),
                                        textColor: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.all(
                                  10.0,
                                ),
                                child: Text(
                                  "All Teachers: ",
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
                            Container(
                              height: 200,
                              // margin: EdgeInsets.all(15),
                              child: StreamBuilder<QuerySnapshot<Map>>(
                                  stream: FirebaseFirestore.instance
                                      .collection("teachers")
                                      .where('name', isNotEqualTo: null)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasData) {
                                      if (snapshot.data.docs.isNotEmpty) {
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data.docs.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         TeacherDetailsScreen(
                                                  //       // uid: snapshot
                                                  //       //     .data.docs[index]
                                                  //       //     .data()["uid"],

                                                  //       uid: "uid",
                                                  //       phoneNumber: snapshot
                                                  //               .data
                                                  //               .docs[index]
                                                  //               .data()[
                                                  //           "phoneNumber"],
                                                  //       name: snapshot
                                                  //           .data.docs[index]
                                                  //           .data()["name"],
                                                  //       subject: snapshot
                                                  //           .data.docs[index]
                                                  //           .data()["subject"],
                                                  //       imageUrl: snapshot
                                                  //           .data.docs[index]
                                                  //           .data()["img"],
                                                  //     ),
                                                  //   ),
                                                  // );
                                                },
                                                child: TeacherCard(
                                                  subject: snapshot
                                                      .data.docs[index]
                                                      .data()["subject"],
                                                  imgPath: snapshot
                                                      .data.docs[index]
                                                      .data()["img"],
                                                  name: snapshot
                                                      .data.docs[index]
                                                      .data()["name"],
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Text(
                                              "Sorry, no data available in your city.",
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "QuickSand"),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return Text(
                                        "Sorry, no data available for your city.",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "QuickSand"),
                                      );
                                    }
                                  }),
                            )
                          ],
                        ),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.7),
                                  blurRadius: 25.0,
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              // image: DecorationImage(
                              //   image: AssetImage('assets/images/covid.png'),
                              // ),
                              color: Colors.orange.withOpacity(0.89),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: 100,
                                            margin: EdgeInsets.only(
                                                bottom: 60,
                                                top: 1,
                                                right: 5,
                                                left: 5),
                                            width: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/brain.png"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Bored?",
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "QuickSand",
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                "Tap below to get a random number\nfacts",
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "QuickSand",
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              FlatButton.icon(
                                                onPressed: () async {
                                                  RandomFact fact =
                                                      RandomFact();

                                                  String hh =
                                                      await fact.fetchFact();

                                                  Alert(
                                                    context: context,
                                                    type: AlertType.info,
                                                    title: "Random Fact",
                                                    desc: hh,
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "Close",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        width: 120,
                                                      )
                                                    ],
                                                  ).show();
                                                },
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                icon: const Icon(
                                                  Icons.search,
                                                  color: Colors.black,
                                                ),
                                                label: Text('Find Now!',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "QuickSand")),
                                                textColor: Colors.white,
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            UpcomingClasses(),
            ConnectWithStudents(),
            UserProfileView()
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String imgPath;
  final String subject;
  TeacherCard(
      {Key key,
      @required this.subject,
      @required this.name,
      @required this.imgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 175,
          height: 185,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imgPath,
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontFamily: "QuickSand",
                          fontSize: 13.5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectsCard extends StatelessWidget {
  final String name;
  final String imgPath;
  SubjectsCard({Key key, @required this.name, @required this.imgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 180,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 110,
              height: 157,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      imgPath,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "QuickSand",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherIndividualCard extends StatelessWidget {
  String _name;
  String _description;
  String _imageUrl;
  Color _bgColor;

  TeacherIndividualCard(
      this._name, this._description, this._imageUrl, this._bgColor);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailScreen(_name, _description, _imageUrl),
        //   ),
        // );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _bgColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Image.asset(_imageUrl),
            title: Text(
              _name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _description,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

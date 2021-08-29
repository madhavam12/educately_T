import 'package:educately_t/screens/home/widgets/allTeachersSection.dart';
import 'package:educately_t/screens/home/widgets/notesSection.dart';
import 'package:educately_t/screens/home/widgets/randomFactCard.dart';
import 'package:educately_t/screens/home/widgets/tutorButton.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'upcomingClasses.dart';

import 'connectStudents.dart';
import '../widgets/sidebaritems.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'userProfile.dart';

import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'postMeeting.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
// QrService _qrService = locator<QrService>();

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
                              onTap: () {},
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
                        NotesSection(),
                        TutorNearbyCard(),
                        SizedBox(height: 50),
                        AllTeachersSection(),
                        SizedBox(height: 50),
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
                                                    "assets/images/detail_illustration.png"),
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
                                                "Want to teach\nonline?",
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "QuickSand",
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                "Tap below to post your online class.",
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
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostMeeting(),
                                                    ),
                                                  );
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
                                                label: Text('Post Now!',
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

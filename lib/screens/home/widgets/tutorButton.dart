import 'package:flutter/material.dart';

import '../nearbyTutors.dart';

class TutorNearbyCard extends StatelessWidget {
  const TutorNearbyCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              builder: (context) => NearbyTutors()));
                    },
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
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
    );
  }
}

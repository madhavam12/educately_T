import 'package:flutter/material.dart';

import 'package:educately_t/services/randomFactService.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RandomFactCard extends StatelessWidget {
  const RandomFactCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                            bottom: 60, top: 1, right: 5, left: 5),
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/brain.png"),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontFamily: "QuickSand",
                              fontSize: 11.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          FlatButton.icon(
                            onPressed: () async {
                              RandomFact fact = RandomFact();

                              String hh = await fact.fetchFact();

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
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            label: Text('Find Now!',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: "QuickSand")),
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
    );
  }
}

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notesScreen.dart';
import 'subjectCard.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    print(
                      snapshot.data.docs.length,
                    );
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              DocumentSnapshot<Map> user =
                                  await FirebaseFirestore.instance
                                      .collection('students')
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .get();
                              print(user.data());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotesScreen(
                                    standard: user.data()['standard'],
                                    subjectIMG:
                                        snapshot.data.docs[index].data()['img'],
                                    subject: snapshot.data.docs[index]
                                        .data()['name'],
                                  ),
                                ),
                              );
                            },
                            child: SubjectsCard(
                              imgPath: snapshot.data.docs[index].data()['img'],
                              name: snapshot.data.docs[index].data()['name'],
                            ),
                          );
                        }); // data
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return Text('No data'); // no data
                  }
                } else {
                  return Center(child: CircularProgressIndicator()); // loading
                }
              }),
        )
      ],
    );
  }
}

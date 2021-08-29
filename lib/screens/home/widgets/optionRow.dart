import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class OptionRow extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData iconData;
  final Color iconColor;
  final Color iconColor2;
  OptionRow(
      {@required this.iconColor,
      @required this.iconColor2,
      @required this.onTap,
      @required this.iconData,
      @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: iconColor2,
              child: Icon(
                iconData,
                color: iconColor,
              ),
            ),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "QuickSand",
                fontSize: 20.0,
              ),
            ),
            CircleAvatar(
              backgroundColor: Color(0xFFF4F4F6),
              child: Icon(
                LineAwesomeIcons.arrow_right,
                color: Color(0xFF3B3C48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

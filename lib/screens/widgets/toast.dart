import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

void showToast({@required String msg, bool isLong = true}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

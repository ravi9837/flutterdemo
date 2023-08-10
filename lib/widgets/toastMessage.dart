import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///SHOWS A TOAST MESSAGE
showToast(String message, ToastGravity gravity) {
  return Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.green,
    gravity: gravity,
    textColor: Colors.black,
    fontSize: 15,
    toastLength: Toast.LENGTH_SHORT,
  );
}
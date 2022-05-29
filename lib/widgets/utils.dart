import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../constants.dart';

class Utils {
  static void displayToast(String message, String type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 2,
        backgroundColor: type.contains("warning")?BasePalette.danger:BasePalette.success,
        textColor: type.contains("warning")?Colors.white:BasePalette.accent,
        fontSize: 14.0);
  }

  static SnackBar displaySnackBar(String message,
      {required String actionMessage, required VoidCallback onClick}) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: BasePalette.primary, fontSize: 14.0),
      ),
      action: (actionMessage != null)
          ? SnackBarAction(
        textColor: Colors.white,
        label: actionMessage,
        onPressed: () {
          return onClick();
        },
      )
          : null,
      duration: Duration(seconds: 2),
      backgroundColor: BasePalette.accent,
    );
  }
}

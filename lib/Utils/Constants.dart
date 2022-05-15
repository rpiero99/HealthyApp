import 'package:flutter/material.dart';

class Constants {
  static const Color backgroundColor = Color.fromRGBO(58, 66, 86, 1.0);
  static const Color backgroundButtonColor = Colors.white;
  static const Color textButtonColor = Colors.black;
  static const Color text = Colors.white;
  static const Color backgroundColorLoginButton = Colors.white54;
  static const Color errorSnackBar = Colors.redAccent;
  static const Color successSnackBar = Colors.lightGreen;


  static SnackBar createSnackBar(String label, Color color) {
    return SnackBar(
      content: Text(label),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }

  static void redirectTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}

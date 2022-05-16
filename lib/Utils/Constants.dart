import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Controller/HealthyAppController.dart';

class Constants {
  static HealthyAppController controller = HealthyAppController.instance;
  static const Color backgroundColor = Color.fromRGBO(58, 66, 86, 1.0);
  static const Color backgroundButtonColor = Colors.white;
  static const Color textButtonColor = Colors.black;
  static const Color text = Colors.white;
  static const Color backgroundColorLoginButton = Colors.white54;
  static const Color errorSnackBar = Colors.redAccent;
  static const Color successSnackBar = Colors.lightGreen;
  static const List<String> daysWeek = [
    'Giorno..',
    'Lunedi',
    'Martedi',
    'Mercoledi',
    'Giovedi',
    'Venerdi',
    'Sabato',
    'Domenica',
  ];

  static int convertDayWeekInInt(String el) {
    if (el.toLowerCase() == "Lunedi".toLowerCase()) {
      return 1;
    } else if (el.toLowerCase() == "Martedi".toLowerCase()) {
      return 2;
    } else if (el.toLowerCase() == "Mercoledi".toLowerCase()) {
      return 3;
    } else if (el.toLowerCase() == "Giovedi".toLowerCase()) {
      return 4;
    } else if (el.toLowerCase() == "Venerdi".toLowerCase()) {
      return 5;
    } else if (el.toLowerCase() == "Sabato".toLowerCase()) {
      return 6;
    } else if (el.toLowerCase() == "Domenica".toLowerCase()) {
      return 7;
    }
    return -1;
  }

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

  static String? getCurrentIdUser() {
    return controller.gestoreAuth.firebaseAuth.currentUser?.uid;
  }

}

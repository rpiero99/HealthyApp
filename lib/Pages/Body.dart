import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Utils/Constants.dart';

import 'Background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      key:  GlobalKey(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Bentornato in Healthy App!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Constants.text),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Constants.redirectTo(context, LoginPage());
              }, key: GlobalKey(),
            ),
            RoundedButton(
              text: "REGISTRATI",
              press: () {
                Constants.redirectTo(context, RegistrationPage());
              }, key: GlobalKey(),
            ),
          ],
        ),
      ),
    );
  }
}
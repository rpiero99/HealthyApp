import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Utils/Constants.dart';

import 'Background.dart';

class Body extends StatelessWidget {
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      key:  Key(random.nextInt(9999999).toString()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              }, key: Key(random.nextInt(9999999).toString()),
            ),
            RoundedButton(
              text: "REGISTRATI",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegistrationPage();
                    },
                  ),
                );
              }, key: Key(random.nextInt(9999999).toString()),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/AddAnagraficaPage.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/MainPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Utils/Constants.dart';

import '../Background.dart';


class AnagraficaScreen extends StatelessWidget {
  const AnagraficaScreen({Key? key}) : super(key: key);

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
              "Hey! Non hai ancora associata nessuna scheda anagrafica, vuoi crearne una?",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Constants.text),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "Crea Scheda Anagrafica",
              press: () {
                Constants.redirectTo(context, AddAnagraficaPage());
              }, key: GlobalKey(),
            ),
            RoundedButton(
              text: "Vai alla home page",
              press: () {
                Constants.redirectTo(context, MainPage());
              }, key: GlobalKey(),
            ),
          ],
        ),
      ),
    );
  }
}
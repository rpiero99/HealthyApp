import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Utils/Constants.dart';

import 'Background.dart';
import 'Widgets/TopAppBar.dart';
//todo
class AddAllenamentoPage extends StatefulWidget {
  const AddAllenamentoPage({Key? key}) : super(key: key);

  @override
  _AddAllenamentoPage createState() => _AddAllenamentoPage();
}

class _AddAllenamentoPage extends State<AddAllenamentoPage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.backgroundColor,
        appBar: makeTopAppBar(context, "Allenamento", Constants.controller),
    body: SingleChildScrollView(
      child: SizedBox(
        child: Stack(
          children: [
            SizedBox(
              height: size.height/3,
              width: size.width,
              child: Card(
                color: Colors.white70,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: const <Widget>[
                    Text(
                      "Steps Today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )
    );
  }
}

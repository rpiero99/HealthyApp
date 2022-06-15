import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Controller/HealthyAppController.dart';
import 'package:healthy_app/Pages/HomePage.dart';
import 'package:healthy_app/Pages/MainPage.dart';
import 'package:healthy_app/Pages/WelcomeScreen.dart';

import '../../Utils/Constants.dart';

PreferredSizeWidget makeTopAppBar(BuildContext context, String label, HealthyAppController controller) {
  return AppBar(
    elevation: 0,
    backgroundColor: Constants.backgroundColor,
    centerTitle: true,
    title: Text(label, textAlign: TextAlign.center,),
    leading: IconButton(
        onPressed: () {
          if(context.widget.toString() != 'MainPage'){
            Navigator.pop(context);
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Constants.text,
        )),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          controller.signOut();
          Constants.redirectTo(context, WelcomeScreen());
        },
      ),
    ],
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
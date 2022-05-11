import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Controller/HealthyAppController.dart';
import 'package:healthy_app/Model/Pasto.dart';
import 'package:healthy_app/Pages/HomePage.dart';
import 'package:healthy_app/Pages/Widgets/BottomAppBar.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';
import 'package:healthy_app/Utils/Constants.dart';
import 'package:healthy_app/Utils/IdGenerator.dart';
import 'dart:math';

import '../Model/Allenamento.dart';

// class DashBoard extends StatefulWidget {
//   const DashBoard({Key? key}) : super(key: key);
//
//   @override
//   _DashBoardState createState() => _DashBoardState();
// }

class DashBoard extends StatelessWidget {
  HealthyAppController c = HealthyAppController.instance;
  final List<Widget> _tabItems = [HomePage()];
  int _activePage = 0;

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: makeTopAppBar(context, "DashBoard", c),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Constants.backgroundColor,
          items: const <Widget>[
            Icon(
              Icons.home_outlined,
              size: 30,
              color: Constants.backgroundColor,
            ),
            Icon(Icons.run_circle_outlined,
                size: 30, color: Constants.backgroundColor),
            Icon(Icons.add_circle_outline_outlined,
                size: 30, color: Constants.backgroundColor),
            Icon(Icons.list_alt_outlined,
                size: 30, color: Constants.backgroundColor),
            Icon(Icons.account_circle_outlined,
                size: 30, color: Constants.backgroundColor),
          ],
          onTap: (index) {
          },
        ),
        body: _tabItems[_activePage],
      )

    );
  }
}

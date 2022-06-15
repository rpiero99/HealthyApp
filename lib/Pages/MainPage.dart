import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/AddAllenamentoPage.dart';
import 'package:healthy_app/Pages/HomePage.dart';

import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int index = 1;
  final items = <Widget>[
    const Icon(
      Icons.home_outlined,
      size: 30,
      color: Constants.backgroundColor,
    ),
    const Icon(Icons.run_circle_outlined,
        size: 30, color: Constants.backgroundColor),
    const Icon(Icons.add_circle_outline_outlined,
        size: 30, color: Constants.backgroundColor),
    const Icon(Icons.list_alt_outlined,
        size: 30, color: Constants.backgroundColor),
    const Icon(Icons.account_circle_outlined,
        size: 30, color: Constants.backgroundColor),
  ];

  final screens = [
    HomePage(),
    const AddAllenamentoPage(),
  ];

  String getNamePage() {
    if (index == 0) {
      return "Home Page";
    }
    if (index == 1) {
      return "Allenamento";
    }
    if (index == 2) {
      return "Home Page";
    }
    if (index == 3) {
      return "Home Page";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, getNamePage(), Constants.controller),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.backgroundColor,
        index: index,
        items: items,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
          //Handle button tap
        },
      ),
    );
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/AddAllenamentoPage.dart';
import 'package:healthy_app/Pages/EditAnagraficaPage.dart';
import 'package:healthy_app/Pages/GetEserciziPage.dart';
import 'package:healthy_app/Pages/HomePage.dart';
import 'package:healthy_app/Pages/Screens/GetEntityScreen.dart';
import 'package:healthy_app/Pages/Screens/NewEntityScreen.dart';

import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class MainPage extends StatefulWidget {


  MainPage({Key? key}) : super(key: key);


  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  Utente? utente;
  int index = 0;

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
    AddAllenamentoPage(),
    const NewEntityScreen(),
    const GetEntityScreen(),
    EditAnagraficaPage()
  ];

  String getNamePage() {
    if (index == 0) {
      return "Home Page";
    }
    if (index == 1) {
      return "Allenamento";
    }
    if (index == 2) {
      return "Nuovo";
    }
    if (index == 3) {
      return "Lista";
    }
    if (index == 4){
      return "Anagrafica";
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
        onTap: (ind) {
          setState(() {
            index = ind;
          });
          //Handle button tap
        },
      ),
    );
  }
}

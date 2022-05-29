

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/AddAllenamentoPage.dart';
import 'package:healthy_app/Pages/AddAnagraficaPage.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';
import 'package:healthy_app/Pages/DashBoard.dart';
import 'package:healthy_app/Pages/GetAllenamentiPage.dart';
import 'package:healthy_app/Pages/GetPastiGiornalieriPage.dart';
import 'package:healthy_app/Pages/GetSchedePalestraPage.dart';
import 'package:healthy_app/Pages/AddPianoAlimentarePage.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/Allenamento.dart';
import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HealthyAppController c = HealthyAppController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Home Page", c),
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
          //Handle button tap
        },
      ),
      body: Column(
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, AddAnagraficaPage());},
            child: Text('add anagrafica'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, GetPastiGiornalieriPage());},
            child: Text('view pasti del giorno'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, const GetSchedePalestraPage());},
            child: Text('view schede palestra'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, const AddSchedaPalestraPage());},
            child: Text('add schede palestra'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, AddPianoAlimentarePage());},
            child: Text('add piano alimentare'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, GetAllenamentiPage());},
            child: Text('view allenamenti'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, AddAllenamentoPage());},
            child: Text('add allenamento'),
          ),
        ],
      )

    );
  }
}

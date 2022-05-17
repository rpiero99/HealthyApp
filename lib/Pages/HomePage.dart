

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/AddAnagraficaPage.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';
import 'package:healthy_app/Pages/Background.dart';
import 'package:healthy_app/Pages/DashBoard.dart';
import 'package:healthy_app/Pages/NuovoPianoAlimentarePage.dart';
import 'package:healthy_app/Pages/ViewAnagraficaPage.dart';

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
      body: Container(
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () { Constants.redirectTo(context, ViewAnagraficaPage());},
          child: Text('TextButton'),
        ),
      )

    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: c.getAllenamenti(),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Allenamento>).toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: d.length,
            itemBuilder: (context, index) {
              return _buildItem(d[index]);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildItem(Object obj) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.blueGrey,
      elevation: 10,
      child: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album, size: 70),
              title:
                  Text('Heart Shaker', style: TextStyle(color: Colors.white)),
              subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
            ),
            ButtonTheme(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Edit',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

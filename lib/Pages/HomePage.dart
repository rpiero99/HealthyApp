


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Handlers/GestoreAuth.dart';
import 'package:healthy_app/Pages/AddAllenamentoPage.dart';
import 'package:healthy_app/Pages/AddAnagraficaPage.dart';
import 'package:healthy_app/Pages/AddPastoGiornaliero.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';
import 'package:healthy_app/Pages/DashBoard.dart';
import 'package:healthy_app/Pages/EditAnagraficaPage.dart';
import 'package:healthy_app/Pages/EditPianoAlimentarePage.dart';
import 'package:healthy_app/Pages/GetAllenamentiPage.dart';
import 'package:healthy_app/Pages/GetPastiGiornalieriPage.dart';
import 'package:healthy_app/Pages/GetSchedePalestraPage.dart';
import 'package:healthy_app/Pages/AddPianoAlimentarePage.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/Allenamento.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HealthyAppController c = Constants.controller;
  Future<Utente?> utenteFut = Constants.controller.getUtenteByEmail((FirebaseAuth.instance.currentUser?.email)!);
  Utente? utente;
  Future<void> getUtenteSelected(Future<Utente?> utenteFuture) async{
    utente = await utenteFuture;
  }
  Map<String, Widget> mapWidgets = <String, Widget>{};

  @override
  Widget build(BuildContext context) {
    initializeMap();
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
        child: showChildren(),
      )
 /*     Column(
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, );},
            child: Text(''),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, );},
            child: Text(''),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, GetSchedePalestraPage());},
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
            onPressed: () { Constants.redirectTo(context, EditPianoAlimentarePage());},
            child: Text('edit piano'),
          ),

          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, AddAllenamentoPage());},
            child: Text('add allenamento'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () { Constants.redirectTo(context, AddPastoGiornaliero());},
            child: Text('add pasto giornaliero'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              Constants.redirectTo(context, EditAnagraficaPage(utente: utente!,));},
            child: Text('edit anagrafica'),
          ),
        ],
      )*/

    );
  }

  Widget showChildren() {
    return FutureBuilder(
      future: getUtenteSelected(utenteFut),
      builder: (context, snapshot){
        if ((snapshot.connectionState == ConnectionState.done)) {
            mapWidgets["edit anagrafica"] = EditAnagraficaPage(utente: utente!);
            return ListView.builder(
                itemCount: mapWidgets.length,
                itemBuilder: (context, index) {
                  return _buildItem(context, index);
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
      },
    );
  }
  Widget _buildItem(BuildContext context, int index) {
    String key = mapWidgets.keys.elementAt(index);
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () { Constants.redirectTo(context, mapWidgets[key]! );},
      child: Text(key),
    );
  }
  void initializeMap() {
    mapWidgets = {
      'add anagrafica': AddAnagraficaPage(),
      'view pasti del giorno': GetPastiGiornalieriPage(),
      'get schede': GetSchedePalestraPage(),
      'add scheda': AddSchedaPalestraPage(),
      'get allenamenti':GetAllenamentiPage(),
      'edit piano alimentare':EditPianoAlimentarePage(),
      'add allenamento':AddAllenamentoPage(),
      'add pasto giornaliero': AddPastoGiornaliero(),
//      'edit anagrafica': EditAnagraficaPage(utente: utente!)
    };
  }
}



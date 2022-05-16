import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';
import 'package:healthy_app/Model/CronometroProgrammabile.dart';
import 'package:healthy_app/Model/PianoAlimentare.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/DashBoard.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/WelcomeScreen.dart';

import 'Controller/HealthyAppController.dart';
import 'Model/Allenamento.dart';
import 'Model/AnagraficaUtente.dart';
import 'Model/Esercizio.dart';
import 'Model/Pasto.dart';
import 'Model/Utente.dart';
import 'Pages/CountdownPage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

//  c.test();
//  c.notificator?.init();
//  c.notificator?.initDetails();
//  Allenamento allenamento = await c.startAllenamento("namoo", "allenamento 1 - plaza");


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static HealthyAppController c = HealthyAppController.instance;
  CronometroProgrammabile cron = c.createCronometroProgrammabile(20, 60, 180, 600);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthyApp'),
      ),
      body: const Center(),
      floatingActionButton: SpeedDial(
          icon: Icons.share,
          backgroundColor: Colors.amber,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.apartment),
              label: 'Social Network',
              backgroundColor: Colors.amberAccent,
              onTap: () {buildCronometro(context);},
            ),
            SpeedDialChild(
              child: const Icon(Icons.email),
              label: 'Email',
              backgroundColor: Colors.amberAccent,
              onTap: () {cron.stopTimer();},
            ),
            SpeedDialChild(
              child: const Icon(Icons.chat),
              label: 'Message',
              backgroundColor: Colors.amberAccent,
              onTap: () {/* Do something */},
            ),
          ]),
    );
  }

  Widget buildCronometro(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              cron.startTimer();
            },
            child: Text("start"),
          ),
        ],
      ),
    );
  }
}*/




// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class GestoreDatabase {
  GestoreDatabase._privateConstructor();
  static final instance = GestoreDatabase._privateConstructor();
  final allenamentoRef = FirebaseFirestore.instance.collection('Allenamento');
  final anagraficaUtenteRef =
      FirebaseFirestore.instance.collection('AnagraficaUtente');
  final cronometroProgRef =
      FirebaseFirestore.instance.collection('CronomentroProgrammabile');
  final esercizioRef = FirebaseFirestore.instance.collection('Esercizio');
  final pastoRef = FirebaseFirestore.instance.collection('Pasto');
  final pianoAlimentareRef =
      FirebaseFirestore.instance.collection('PianoAlimentare');
  final schedaPalestraRef =
      FirebaseFirestore.instance.collection('SchedaPalestra');
  final utenteRef = FirebaseFirestore.instance.collection('Utente');
}

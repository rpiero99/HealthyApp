// ignore_for_file: file_names

import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Model/Allenamento.dart';
import 'package:healthy_app/Model/Handlers/GestoreAllenamento.dart';
import 'package:healthy_app/Model/Handlers/GestoreAuth.dart';
import 'package:healthy_app/Model/Handlers/GestoreDatabase.dart';
import 'package:healthy_app/Model/Handlers/GestoreSchedaPalestra.dart';
import 'package:healthy_app/Model/Handlers/GestoreUtente.dart';

import '../Model/AnagraficaUtente.dart';
import '../Model/CronometroProgrammabile.dart';
import '../Model/SchedaPalestra.dart';
import '../Model/Utente.dart';

class HealthyAppController {
  GestoreAllenamento gestoreAllenamento = GestoreAllenamento.instance;
  GestoreDatabase gestoreDatabase = GestoreDatabase.instance;
  GestoreAuth gestoreAuth = GestoreAuth.instance;
  GestoreSchedaPalestra gestoreSchedaPalestra = GestoreSchedaPalestra.instance;
  GestoreUtente gestoreUtente = GestoreUtente.instance;

  HealthyAppController._privateConstructor();
  static final instance = HealthyAppController._privateConstructor();

  Allenamento createAllenamento(
      int calorieConsumate,
      String descrizione,
      Float distanza,
      String image,
      String nome,
      DateTime oraInizio,
      DateTime oraFine,
      DateTime tempoPerKm,
      DateTime tempoTotale,
      Float velocitaMedia) {
    return gestoreAllenamento.createAllenamento(
        calorieConsumate,
        descrizione,
        distanza,
        image,
        nome,
        oraInizio,
        oraFine,
        tempoPerKm,
        tempoTotale,
        velocitaMedia);
  }

  Future<List<Allenamento>> getAllenamenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.allenamentoRef.get();
    final allAllenamentiInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<Allenamento>;
    for (var item in allAllenamentiInDB) {
      addAllenamento(item);
    }
    return gestoreAllenamento.allenamenti;
  }

  login(Utente utente) => gestoreAuth.login(utente);

  registrazione(Utente utente) => gestoreAuth.registrazione(utente);

  SchedaPalestra createSchedaPalestra(String descrizione, String nome) =>
      gestoreSchedaPalestra.createSchedaPalestra(descrizione, nome);

  Future<List<SchedaPalestra>> getSchedePalestra() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.schedaPalestraRef.get();
    final allSchedePalestraInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<SchedaPalestra>;
    for (var item in allSchedePalestraInDB) {
      addSchedaPalestra(item);
    }
    return gestoreSchedaPalestra.schede;
  }

  addSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.addSchedaPalestra(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.removeSchedaPalestra(scheda);

  CronometroProgrammabile createCronometroProgrammabile(
          Timer timer,
          Timer tempoPreparazione,
          Timer tempoRiposo,
          Timer tempoLavoro,
          int tempoTotale) =>
      gestoreSchedaPalestra.createCronometroProgrammabile(
          timer, tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);

  Utente createUtente(
          AnagraficaUtente anagrafica, String email, String password) =>
      gestoreUtente.createUtente(anagrafica, email, password);

  Future<List<Utente>> getUtenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.utenteRef.get();
    final allUsersInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<Utente>;
    for (var item in allUsersInDB) {
      addUtente(item);
    }
    return gestoreUtente.utenti;
  }

  void addAllenamento(Allenamento item) {
    gestoreAllenamento.addAllenamento(item);
  }

  void addUtente(Utente item) {
    gestoreUtente.addUtente(item);
  }
}

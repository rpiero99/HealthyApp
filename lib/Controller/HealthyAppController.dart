// ignore_for_file: file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Utils/GeoLocService.dart';
import 'package:healthy_app/Utils/MapEserciziDay.dart';
import '../Model/Allenamento.dart';
import '../Model/Esercizio.dart';
import '../Model/Handlers/GestoreAllenamento.dart';
import '../Model/Handlers/GestoreAuth.dart';
import '../Model/Handlers/GestoreDatabase.dart';
import '../Model/Handlers/GestoreSchedaPalestra.dart';
import '../Model/Handlers/GestoreUtente.dart';

import '../Model/AnagraficaUtente.dart';
import '../Model/CronometroProgrammabile.dart';
import '../Model/Pasto.dart';
import '../Model/PianoAlimentare.dart';
import '../Model/SchedaPalestra.dart';
import '../Model/Utente.dart';

class HealthyAppController {
  GestoreAllenamento gestoreAllenamento = GestoreAllenamento.instance;
  GestoreDatabase gestoreDatabase = GestoreDatabase.instance;
  GestoreAuth gestoreAuth = GestoreAuth.instance;
  GestoreSchedaPalestra gestoreSchedaPalestra = GestoreSchedaPalestra.instance;
  GestoreUtente gestoreUtente = GestoreUtente.instance;
  GeoLocService? geoLocService;

  HealthyAppController._privateConstructor();

  static final instance = HealthyAppController._privateConstructor();

  ///Metodi per login e registrazione

  login(String email, String password) => gestoreAuth.login(email,password);

  registrazione(String email, String password) => gestoreAuth.registrazione(email, password);

  ///Metodi per allenamento

  Allenamento createAllenamento(String descrizione, String nome) {
    Allenamento allenamento =
        gestoreAllenamento.createAllenamento(descrizione, nome);
    gestoreDatabase.allenamentoRef.add(allenamento.toJson());
    return allenamento;
  }

  Future<List<Allenamento>> getAllenamenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.allenamentoRef.get();
    final allAllenamentiInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var value in allAllenamentiInDB) {
      await gestoreDatabase.allenamentoRef
          .doc(value)
          .get()
          .then((element) async {
        addAllenamento(Allenamento.fromJson(element.data()!));
      });
    }
    return gestoreAllenamento.allenamenti;
  }

  updateAllenamento(Allenamento allenamento) =>
      gestoreDatabase.allenamentoRef.doc().set(allenamento.toJson());

  void addAllenamento(Allenamento item) {
    gestoreAllenamento.addAllenamento(item);
  }

  void startAllenamento(String descrizione, String nome) async {
    geoLocService = GeoLocService();
    DateTime timeStamp = DateTime.now();
    geoLocService?.initPlatformState();
    Allenamento newAllenamento = createAllenamento(descrizione, nome);
    geoLocService?.startPosition = await geoLocService?.getCurrentPosition();
    newAllenamento.oraInizio = timeStamp;
    addAllenamento(newAllenamento);
  }

  void stopAllenamento(Allenamento allenamento) async {
    allenamento.oraFine = DateTime.now();
    geoLocService?.endPosition = await geoLocService?.getCurrentPosition();
    allenamento.distanza = geoLocService?.calculateDistance(
        geoLocService?.startPosition?.latitude,
        geoLocService?.startPosition?.longitude,
        geoLocService?.endPosition?.latitude,
        geoLocService?.endPosition?.longitude);
    //todo da testare
    geoLocService?.cancelListener();
  }

  ///Metodi scheda palestra

  SchedaPalestra createSchedaPalestra(
      String descrizione, String nome, DateTime dataInizio, DateTime dataFine) {
    SchedaPalestra scheda = gestoreSchedaPalestra.createSchedaPalestra(
        descrizione, nome, dataInizio, dataFine);
    gestoreDatabase.schedaPalestraRef.add(scheda.toJson());
    List<MapEserciziDay> mapList = List.empty(growable: true);
    for(int i=1; i<8; i++){
      List<Esercizio>? esercizi = scheda.getEserciziFromDay(i);
      MapEserciziDay map = MapEserciziDay(i);
      for(Esercizio esercizio in esercizi!) {
        map.addEsercizio(esercizio);
      }
      mapList.add(map);
    }
    for(MapEserciziDay map in mapList) {
      gestoreDatabase.eserciziOfDayRef.add(map.toJson());
    }
    return scheda;
  }

  Future<List<SchedaPalestra>> getSchedePalestra() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.schedaPalestraRef.get();
    final allSchedePalestraInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var value in allSchedePalestraInDB) {
      await gestoreDatabase.schedaPalestraRef
          .doc(value)
          .get()
          .then((element) async {
        addSchedaPalestra(SchedaPalestra.fromJson(element.data()!));
      });
    }
    return gestoreSchedaPalestra.schedePalestra;
  }

  updateSchedaPalestra(SchedaPalestra scheda) =>
      gestoreDatabase.schedaPalestraRef.doc().set(scheda.toJson());

  addSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.addSchedaPalestra(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.removeSchedaPalestra(scheda);

  ///Metodi cronometro programmabile

  CronometroProgrammabile createCronometroProgrammabile(
      int tempoPreparazione,
      int tempoRiposo,
      int tempoLavoro,
      int tempoTotale) {
    CronometroProgrammabile cronometroProgrammabile =
        gestoreSchedaPalestra.createCronometroProgrammabile(
             tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);
    gestoreDatabase.cronometroProgRef.add(cronometroProgrammabile.toJson());
    return cronometroProgrammabile;
  }

  Future<List<CronometroProgrammabile>> getCronometriProgrammabili() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.cronometroProgRef.get();
    final allCroInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var value in allCroInDB) {
      await gestoreDatabase.cronometroProgRef
          .doc(value)
          .get()
          .then((element) async {
        addCronometroProgrammabile(CronometroProgrammabile.fromJson(element.data()!));
      });
    }
    return gestoreSchedaPalestra.cronometriProg;
  }

  void addCronometroProgrammabile(CronometroProgrammabile cronometroProgrammabile) {
    gestoreSchedaPalestra.addCronProg(cronometroProgrammabile);
  }

  updateCrometroProgrammabile(
          CronometroProgrammabile cronometroProgrammabile) =>
      gestoreDatabase.cronometroProgRef
          .doc()
          .set(cronometroProgrammabile.toJson());

  void startTimer(CronometroProgrammabile cronometroProgrammabile) {
    cronometroProgrammabile.startTimer();
  }

  void stopTimer(CronometroProgrammabile cronometroProgrammabile){
    cronometroProgrammabile.stopTimer();
  }

  ///Metodi utente

  Utente createUtente(
      AnagraficaUtente anagrafica, String email) {
    Utente user = gestoreUtente.createUtente(anagrafica, email);
    gestoreDatabase.utenteRef.add(user.toJson());
    return user;
  }

  Future<List<Utente>> getUtenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.utenteRef.get();
    final allUsersInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allUsersInDB) {
      await gestoreDatabase.utenteRef
          .doc(item)
          .get()
          .then((element) async {
        addUtente(Utente.fromJson(element.data()!));
      });
    }
    return gestoreUtente.utenti;
  }

  updateUtente(Utente user) =>
      gestoreDatabase.utenteRef.doc().set(user.toJson());

  void addUtente(Utente item) {
    gestoreUtente.addUtente(item);
  }

  ///Metodi anagrafica utente

  AnagraficaUtente createAnagraficaUtente(int altezza,
      DateTime dataNascita, String nome, double peso, String sesso) {
    AnagraficaUtente anagrafica = gestoreUtente.createAnagraficaUtente(
        altezza, dataNascita, nome, peso, sesso);
    gestoreDatabase.anagraficaUtenteRef.add(anagrafica.toJson());
    return anagrafica;
  }

  setAnagraficaUtente(Utente user, AnagraficaUtente anagrafica) {
    gestoreDatabase.anagraficaUtenteRef.doc().set(anagrafica.toJson());
    user.anagraficaUtente = anagrafica;
    updateUtente(user);
  }

  ///Metodi esercizio

  Esercizio createEsercizio(
      SchedaPalestra schedaPalestra,
      CronometroProgrammabile cronometro,
      String descrizione,
      String image,
      String nome,
      int numeroSerie,
      int numeroRipetizioni,
      int tempoRiposo,
      int day) {
    Esercizio esercizio = schedaPalestra.createEsercizio(cronometro,
        descrizione, image, nome, numeroSerie, numeroRipetizioni, tempoRiposo);
    schedaPalestra.addEsercizio(esercizio, day);
    gestoreDatabase.esercizioRef.add(esercizio.toJson());
    updateSchedaPalestra(schedaPalestra);
    return esercizio;
  }

  updateEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio, int day) {
    gestoreDatabase.esercizioRef.doc().set(esercizio.toJson());
    schedaPalestra.updateEsercizio(esercizio, day);
    updateSchedaPalestra(schedaPalestra);
  }

  addEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio, int day) {
    schedaPalestra.addEsercizio(esercizio, day);
    updateSchedaPalestra(schedaPalestra);
  }

  removeEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio, int day) {
    schedaPalestra.removeEsercizio(esercizio, day);
    updateSchedaPalestra(schedaPalestra);
  }

  ///Metodi piano alimentare

  PianoAlimentare createPianoAlimentare(DateTime dataFine, DateTime dataInizio,
      String descrizione, Utente utente) {
    PianoAlimentare piano = gestoreUtente.createPianoAlimentare(
        dataFine, dataInizio, descrizione, utente);
    gestoreUtente.addPianoAlimentare(piano);
    gestoreDatabase.pianoAlimentareRef.add(piano.toJson());
    return piano;
  }

  updatePianoAlimentare(PianoAlimentare pianoAlimentare) =>
      gestoreDatabase.pianoAlimentareRef.doc().set(pianoAlimentare.toJson());

  addPianoAlimentare(PianoAlimentare pianoAlimentare) =>
      gestoreUtente.addPianoAlimentare(pianoAlimentare);

  removePianoAlimentare(PianoAlimentare pianoAlimentare) =>
      gestoreUtente.removePianoAlimentare(pianoAlimentare);

  ///Metodi pasto

  Pasto createPasto(
      PianoAlimentare piano,
      Enum categoria,
      int calorie,
      String descrizione,
      String nome,
      DateTime ora,
      int quantita,
      String type) {
    Pasto pasto = piano.createPasto(
        categoria, calorie, descrizione, nome, ora, quantita, type);
    piano.addPasto(pasto);
    gestoreDatabase.pastoRef.add(pasto.toJson());
    updatePianoAlimentare(piano);
    return pasto;
  }

  addPasto(PianoAlimentare piano, Pasto pasto) {
    piano.addPasto(pasto);
    updatePianoAlimentare(piano);
  }

  removePasto(PianoAlimentare piano, Pasto pasto) {
    piano.removePasto(pasto);
    updatePianoAlimentare(piano);
  }

  PianoAlimentare getCurrentPianoAlimentareOf(Utente utente) {
    return gestoreUtente.piani
        .where((element) =>
            element.utente == utente &&
            element.dataFine!.isAfter(DateTime.now()))
        .first;
  }
}

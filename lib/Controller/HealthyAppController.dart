// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  HealthyAppController._privateConstructor();
  static final instance = HealthyAppController._privateConstructor();

  //Metodi per login e registrazione
  login(Utente utente) => gestoreAuth.login(utente);

  registrazione(Utente utente) => gestoreAuth.registrazione(utente);

  //Metodi per allenamento
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
    Allenamento allenamento =  gestoreAllenamento.createAllenamento(
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
    gestoreDatabase.allenamentoRef.add(allenamento.toJson());
    return allenamento;
  }

  Future<List<Allenamento>> getAllenamenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.allenamentoRef.get();
    final allAllenamentiInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<Allenamento>;
    for (var item in allAllenamentiInDB) {
      Allenamento.fromJson(item.toJson());
      addAllenamento(item);
    }
    return gestoreAllenamento.allenamenti;
  }

  updateAllenamento(Allenamento allenamento) => gestoreDatabase.allenamentoRef.doc().set(allenamento.toJson());

  void addAllenamento(Allenamento item) {
    gestoreAllenamento.addAllenamento(item);
  }

  //Metodi scheda palestra

  SchedaPalestra createSchedaPalestra(String descrizione, String nome){
    SchedaPalestra scheda = gestoreSchedaPalestra.createSchedaPalestra(descrizione, nome);
    gestoreDatabase.schedaPalestraRef.add(scheda.toJson());
    return scheda;
  }

  Future<List<SchedaPalestra>> getSchedePalestra() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.schedaPalestraRef.get();
    final allSchedePalestraInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<SchedaPalestra>;
    for (var item in allSchedePalestraInDB) {
      SchedaPalestra.fromJson(item.toJson());
      addSchedaPalestra(item);
    }
    return gestoreSchedaPalestra.schedePalestra;
  }

  updateSchedaPalestra(SchedaPalestra scheda) =>  gestoreDatabase.schedaPalestraRef.doc().set(scheda.toJson());

  addSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.addSchedaPalestra(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.removeSchedaPalestra(scheda);

  //Metodi cronometro programmabile
  CronometroProgrammabile createCronometroProgrammabile(
          Timer timer,
          int tempoPreparazione,
          int tempoRiposo,
          int tempoLavoro,
          int tempoTotale) {
    CronometroProgrammabile cronometroProgrammabile = gestoreSchedaPalestra.createCronometroProgrammabile(
        timer, tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);
    gestoreDatabase.schedaPalestraRef.add(cronometroProgrammabile.toJson());
    return cronometroProgrammabile;
  }

  updateCrometroProgrammabile(CronometroProgrammabile cronometroProgrammabile) =>
      gestoreDatabase.schedaPalestraRef.doc().set(cronometroProgrammabile.toJson());


 //Metodi utente

  Utente createUtente(
          AnagraficaUtente anagrafica, String email, String password) {
    Utente user = gestoreUtente.createUtente(anagrafica, email, password);
    gestoreDatabase.utenteRef.add(user.toJson());
    return user;
  }

  Future<List<Utente>> getUtenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.utenteRef.get();
    final allUsersInDB =
        querySnapshot.docs.map((doc) => doc.data()) as List<Utente>;
    for (var item in allUsersInDB) {
      Utente.fromJson(item.toJson());
      addUtente(item);
    }
    return gestoreUtente.utenti;
  }

  updateUtente(Utente user) => gestoreDatabase.utenteRef.doc().set(user.toJson());

  void addUtente(Utente item) {
    gestoreUtente.addUtente(item);
  }

  //Metodi anagrafica utente

  AnagraficaUtente createAnagraficaUtente(Utente user,int altezza, DateTime dataNascita, String nome,  double peso, String sesso ){
    AnagraficaUtente anagrafica = gestoreUtente.createAnagraficaUtente(altezza, dataNascita, nome, peso, sesso);
    gestoreDatabase.anagraficaUtenteRef.add(anagrafica.toJson());
    user.anagraficaUtente = anagrafica;
    updateUtente(user);
    return anagrafica;
  }

  setAnagraficaUtente(Utente user, AnagraficaUtente anagrafica) {
    gestoreDatabase.anagraficaUtenteRef.doc().set(anagrafica.toJson());
    user.anagraficaUtente = anagrafica;
    updateUtente(user);
  }

  //Metodi esercizio
  Esercizio createEsercizio(SchedaPalestra schedaPalestra, CronometroProgrammabile cronometro, String descrizione, String image, String nome, int numeroSerie, int numeroRipetizioni, int tempoRiposo){
    Esercizio esercizio = schedaPalestra.createEsercizio(cronometro, descrizione, image, nome, numeroSerie, numeroRipetizioni, tempoRiposo);
    schedaPalestra.addEsercizio(esercizio);
    gestoreDatabase.esercizioRef.add(esercizio.toJson());
    updateSchedaPalestra(schedaPalestra);
    return esercizio;
  }

  updateEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio){
    gestoreDatabase.esercizioRef.doc().set(esercizio.toJson());
    schedaPalestra.updateEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  addEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio){
    schedaPalestra.addEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  removeEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio){
    schedaPalestra.removeEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  //Metodi piano alimentare
  PianoAlimentare createPianoAlimentare(DateTime dataFine, DateTime dataInizio, String descrizione, Utente utente){
    PianoAlimentare piano = gestoreUtente.createPianoAlimentare(dataFine, dataInizio, descrizione, utente);
    gestoreUtente.addPianoAlimentare(piano);
    gestoreDatabase.pianoAlimentareRef.add(piano.toJson());
    return piano;
  }

  updatePianoAlimentare(PianoAlimentare pianoAlimentare) => gestoreDatabase.pianoAlimentareRef.doc().set(pianoAlimentare.toJson());

  addPianoAlimentare(PianoAlimentare pianoAlimentare) => gestoreUtente.addPianoAlimentare(pianoAlimentare);

  removePianoAlimentare(PianoAlimentare pianoAlimentare) => gestoreUtente.removePianoAlimentare(pianoAlimentare);

  //Metodi pasto

  Pasto createPasto(PianoAlimentare piano, Enum categoria, int calorie, String descrizione,
      String nome, DateTime ora, int quantita, String type){
    Pasto pasto = piano.createPasto(categoria, calorie, descrizione, nome, ora, quantita, type);
    piano.addPasto(pasto);
    gestoreDatabase.pastoRef.add(pasto.toJson());
    updatePianoAlimentare(piano);
    return pasto;
  }

  addPasto(PianoAlimentare piano, Pasto pasto){
    piano.addPasto(pasto);
    updatePianoAlimentare(piano);
  }

  removePasto(PianoAlimentare piano, Pasto pasto){
    piano.removePasto(pasto);
    updatePianoAlimentare(piano);
  }


}

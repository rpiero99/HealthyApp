// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';
import 'package:healthy_app/Utils/GeoLocService.dart';
import 'package:healthy_app/Utils/IdGenerator.dart';
import 'package:healthy_app/Utils/NotificationService.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
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
  final NotificationService? _notificationService =
      NotificationService.instance;
  StopWatchTimer? stopwatch;

  HealthyAppController(){
    notificator?.init();
    notificator?.initDetails();
  }

  ///Metodi per login e registrazione

  Future<String?> login(String email, String password) {
    return gestoreAuth.login(email, password);
  }

  registrazione(String email, String password) =>
      gestoreAuth.registrazione(email, password);

  signOut() => gestoreAuth.signOut();

  ///Metodi per allenamento

  Allenamento createAllenamento(String descrizione, String nome) {
    Allenamento allenamento =
        gestoreAllenamento.createAllenamento(descrizione, nome);
    gestoreDatabase.allenamentoRef
        .doc(allenamento.id)
        .set(allenamento.toJson());
    return allenamento;
  }

  Future<List<Allenamento>> getAllenamenti(String idUtente) async {
    gestoreAllenamento.allenamenti.clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.allenamentoRef.get();
    final allAllenamentiInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var value in allAllenamentiInDB) {
      await gestoreDatabase.allenamentoRef.doc(value).get().then((element) {
        var allenamento = Allenamento.fromJson(element.data()!);
        if(allenamento.idUtente == idUtente) {
          addAllenamento(allenamento);
        }
      });
    }
    return gestoreAllenamento.allenamenti;
  }

  updateAllenamento(Allenamento allenamento) {
    gestoreDatabase.allenamentoRef
        .doc(allenamento.id)
        .set(allenamento.toJson());
  }

  void addAllenamento(Allenamento item) {
    if (gestoreAllenamento.allenamenti
            .where((element) => element.id == item.id)
            .isEmpty &&
        item.nome! != "") {
      gestoreAllenamento.addAllenamento(item);
    }
  }

  removeAllenamento(Allenamento item) {
    gestoreAllenamento.removeAllenamento(item);
    DocumentReference a = gestoreDatabase.allenamentoRef.doc(item.id);
    a.delete();
  }

  Future<Allenamento> startAllenamento(
      Allenamento allenamento, Utente utente) async {
    geoLocService = GeoLocService();
    DateTime timeStamp = DateTime.now();
    geoLocService?.initPlatformState();
 /*     stopwatch = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChangeRawSecond: getStatisticheAllenamentoSecondo(allenamento, utente),
      onChangeRawMinute: getStatisticheAllenamentoMinuto(allenamento),
    );*/

    geoLocService?.startPosition = await geoLocService?.getCurrentPosition();
    allenamento.oraInizio = timeStamp;
    addAllenamento(allenamento);
    return allenamento;
  }

  void resetAllenamento(Allenamento allenamento) {
    allenamento.oraInizio = null;
    allenamento.oraFine = null;
    allenamento.distanza = 0;
    allenamento.calorieConsumate = 0;
  }

  void endAllenamento(Allenamento allenamento) async {
    allenamento.oraFine = DateTime.now();
    geoLocService?.endPosition = await geoLocService?.getCurrentPosition();
    allenamento.distanza = calculateDistance(geoLocService!.endPosition!);
    allenamento.calcoloTempoTotale();
    geoLocService?.cancelListener();
  }

  num? calculateDistance(Position position) {
    return geoLocService?.calculateDistance(
        geoLocService?.startPosition?.latitude,
        geoLocService?.startPosition?.longitude,
        geoLocService?.endPosition?.latitude,
        geoLocService?.endPosition?.longitude);
  }

  getStatisticheAllenamentoSecondo(
      Allenamento allenamento, Utente utente) async {
    Position? current = await geoLocService?.getCurrentPosition();
    allenamento.distanza = calculateDistance(current!);
    allenamento.calcoloCalorie(utente);
  }

  Future<num?> getStatisticheAllenamentoDistanza( Allenamento allenamento, Utente utente) async {
    Position? current = await geoLocService?.getCurrentPosition();
    allenamento.distanza = calculateDistance(current!);
    return allenamento.distanza;
  }


  getStatisticheAllenamentoMinuto(Allenamento allenamento) {
    allenamento.oraFine = DateTime.now();
    allenamento.tempoPerKm;
    allenamento.velocitaMedia;
  }

  ///Metodi scheda palestra

  Future<SchedaPalestra?> getCurrentSchedaPalestra(String idutente, DateTime date) async {
    var schede = await getSchedePalestra(idutente);
    for (var scheda in schede) {
      if (scheda.dataFine!.compareTo(date) >= 0 &&
          scheda.dataInizio!.compareTo(date) <= 0) {
        return scheda;
      }
    }
    return null;
  }

  SchedaPalestra? createSchedaPalestra(String descrizione, String nome,
      DateTime dataInizio, DateTime dataFine, idUtente) {
    SchedaPalestra scheda = gestoreSchedaPalestra.createSchedaPalestra(
        descrizione, nome, dataInizio, dataFine, idUtente);
    gestoreDatabase.schedaPalestraRef.doc(scheda.id).set(scheda.toJson());
    return scheda;
  }

  Future<List<SchedaPalestra>> getSchedePalestra(String idUtente) async {
    gestoreSchedaPalestra.schedePalestra.clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.schedaPalestraRef.get();
    final allSchedePalestraInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var value in allSchedePalestraInDB) {
      await gestoreDatabase.schedaPalestraRef
          .doc(value)
          .get()
          .then((element) async {
        SchedaPalestra scheda = SchedaPalestra.fromJson(element.data()!);
        scheda.id = value;
        if(scheda.idUtente == idUtente) {
          addSchedaPalestra(scheda);
        }
      });
    }
    return gestoreSchedaPalestra.schedePalestra;
  }

  updateSchedaPalestra(SchedaPalestra scheda) async {
    DocumentReference a = gestoreDatabase.schedaPalestraRef.doc(scheda.id);
    a.update(scheda.toJson());
    for (Esercizio es in scheda.getAllEsercizi()) {
      a.update({
        "esercizi": FieldValue.arrayUnion([es.toJson()])
      });
    }
  }

  addSchedaPalestra(SchedaPalestra scheda) {
    if (gestoreSchedaPalestra.schedePalestra
            .where((element) => element.id == scheda.id)
            .isEmpty &&
        scheda.nome != "" && gestoreSchedaPalestra.schedePalestra.where((element) => element.nome == scheda.nome).isEmpty) {
      gestoreSchedaPalestra.addSchedaPalestra(scheda);
    }
  }

  removeSchedaPalestra(SchedaPalestra scheda) {
    gestoreSchedaPalestra.removeSchedaPalestra(scheda);
    DocumentReference a = gestoreDatabase.schedaPalestraRef.doc(scheda.id);
    for (Esercizio esercizio in scheda.getAllEsercizi()) {
      removeEsercizio(scheda, esercizio);
    }
    a.delete();
  }

  ///Metodi cronometro programmabile

  CronometroProgrammabile createCronometroProgrammabile(int tempoPreparazione,
      int tempoRiposo, int tempoLavoro, int tempoTotale) {
    CronometroProgrammabile cronometroProgrammabile =
        gestoreSchedaPalestra.createCronometroProgrammabile(
            tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);
    gestoreDatabase.cronometroProgRef
        .doc(cronometroProgrammabile.id)
        .set(cronometroProgrammabile.toJson());
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
        addCronometroProgrammabile(
            CronometroProgrammabile.fromJson(element.data()!));
      });
    }
    return gestoreSchedaPalestra.cronometriProg;
  }

  void addCronometroProgrammabile(
      CronometroProgrammabile cronometroProgrammabile) {
    if (gestoreSchedaPalestra.cronometriProg
            .where((element) => element.id == cronometroProgrammabile.id)
            .isEmpty &&
        cronometroProgrammabile.id != "") {
      gestoreSchedaPalestra.addCronProg(cronometroProgrammabile);
    }
  }

  updateCrometroProgrammabile(
          CronometroProgrammabile cronometroProgrammabile) =>
      gestoreDatabase.cronometroProgRef
          .doc(cronometroProgrammabile.id)
          .update(cronometroProgrammabile.toJson());

  void startTimer(CronometroProgrammabile cronometroProgrammabile) {
    cronometroProgrammabile.startTimer();
  }

  void stopTimer(CronometroProgrammabile cronometroProgrammabile) {
    cronometroProgrammabile.stopTimer();
  }

  ///Metodi utente

  Utente? createUtente(String id, AnagraficaUtente anagrafica, String email) {
    Utente user = gestoreUtente.createUtente(id, anagrafica, email);
    gestoreDatabase.utenteRef.doc(user.id).set(user.toJson());
    return user;
  }

  Future<List<Utente>> getUtenti() async {
    QuerySnapshot querySnapshot = await gestoreDatabase.utenteRef.get();
    final allUsersInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allUsersInDB) {
      await gestoreDatabase.utenteRef.doc(item).get().then((element) async {
        addUtente(Utente.fromJson(element.data()!));
      });
    }
    return gestoreUtente.utenti;
  }

  updateUtente(Utente user) =>
      gestoreDatabase.utenteRef.doc(user.id).update(user.toJson());

  void addUtente(Utente item) {
    if (gestoreUtente.utenti
            .where((element) => element.id == item.id)
            .isEmpty &&
        item.email != "" &&
        gestoreUtente.utenti
            .where((element) => element.email == item.email)
            .isEmpty) {
      gestoreUtente.addUtente(item);
    }
  }

  // Future<String> getCalorieOfDay(DateTime date) async {
  //   num sum = 0;
  //   var pastiDelGiorno = await getPastiOfDay(date);
  //   for (var pasto in pastiDelGiorno) {
  //     sum += pasto.calorie!;
  //   }
  //   return sum.toString();
  // }

  ///Metodi anagrafica utente

  AnagraficaUtente createAnagraficaUtente(int altezza, DateTime dataNascita,
      String nome, double peso, String sesso) {
    AnagraficaUtente anagrafica = gestoreUtente.createAnagraficaUtente(
        altezza, dataNascita, nome, peso, sesso);
    gestoreDatabase.anagraficaUtenteRef
        .doc(anagrafica.id)
        .set(anagrafica.toJson());
    return anagrafica;
  }

  setAnagraficaUtente(Utente user, AnagraficaUtente anagrafica) {
    gestoreDatabase.anagraficaUtenteRef
        .doc(anagrafica.id)
        .set(anagrafica.toJson());
    user.anagraficaUtente = anagrafica;
    updateUtente(user);
  }

  updateAnagraficaUtente(AnagraficaUtente anagrafica) =>
      gestoreDatabase.anagraficaUtenteRef
          .doc(anagrafica.id)
          .update(anagrafica.toJson());

  ///Metodi esercizio

  Esercizio createEsercizio(
      SchedaPalestra schedaPalestra,
      String descrizione,
      String nome,
      int numeroSerie,
      int numeroRipetizioni,
      int tempoRiposo,
      int day) {
    Esercizio esercizio = schedaPalestra.createEsercizio(
        descrizione, nome, numeroSerie, numeroRipetizioni, tempoRiposo, day);
    _addEsercizio(schedaPalestra, esercizio);
    return esercizio;
  }

  updateEsercizio(
      SchedaPalestra schedaPalestra, Esercizio esercizio, String oldName) {
    gestoreDatabase.esercizioRef.doc(esercizio.id).update(esercizio.toJson());
    schedaPalestra.updateEsercizio(esercizio, oldName);
    updateSchedaPalestra(schedaPalestra);
  }

  _addEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio) {
    if (schedaPalestra
        .getAllEsercizi()
        .where((element) => element.id == esercizio.id && element.nome == esercizio.nome)
        .isEmpty) {
      schedaPalestra.addEsercizio(esercizio);
      gestoreDatabase.esercizioRef.doc(esercizio.id).set(esercizio.toJson());
      updateSchedaPalestra(schedaPalestra);
    }
  }

  removeEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio) {
    schedaPalestra.removeEsercizio(esercizio);
    gestoreDatabase.esercizioRef.doc(esercizio.id).delete();
    updateSchedaPalestra(schedaPalestra);
  }

  Future<List<Esercizio>?> getAllEserciziOfDayOf(
      SchedaPalestra? scheda, int day) async {
    scheda?.getEserciziFromDay(day)?.clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.esercizioRef.get();
    final schedaPalestra = await getSchedaPalestraById(scheda!.id!);
    final allEserciziInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var idEs in allEserciziInDB) {
      var es = await getEsercizioById(idEs);
      if (es.idSchedaPalestra == schedaPalestra.id && es.nome != "") {
        schedaPalestra.getAllEsercizi().add(es);
      }
    }
    return schedaPalestra.getEserciziFromDay(day);
  }

  Future<List<Esercizio>?> getAllEserciziOf(
      SchedaPalestra? scheda) async {
    scheda?.getAllEsercizi().clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.esercizioRef.get();
    final allEserciziInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var idEs in allEserciziInDB) {
      var es = await getEsercizioById(idEs);
      if (es.idSchedaPalestra == scheda!.id! && es.nome != "") {
        _addEsercizio(scheda, es);
      }
    }
    return scheda!.getAllEsercizi();
  }

  ///Metodi piano alimentare

  Future<List<PianoAlimentare>> getPianiAlimentari(String idUtente) async {
    gestoreUtente.piani.clear();
    QuerySnapshot querySnapshot =
        await gestoreDatabase.pianoAlimentareRef.get();
    final allUsersInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allUsersInDB) {
      await gestoreDatabase.pianoAlimentareRef
          .doc(item)
          .get()
          .then((element) async {
            var pianoAl = PianoAlimentare.fromJson(element.data()!);
            if(pianoAl.idUtente == idUtente) {
              addPianoAlimentare(PianoAlimentare.fromJson(element.data()!));
            }
      });
    }
    return gestoreUtente.piani;
  }

  PianoAlimentare createPianoAlimentare(String nome, DateTime dataFine, DateTime dataInizio,
      String descrizione, String idUtente) {
    PianoAlimentare piano = gestoreUtente.createPianoAlimentare(nome,
        dataFine, dataInizio, descrizione, idUtente);
    gestoreUtente.addPianoAlimentare(piano);
    gestoreDatabase.pianoAlimentareRef.doc(piano.id).set(piano.toJson());
    return piano;
  }

  updatePianoAlimentare(PianoAlimentare pianoAlimentare) {
    DocumentReference a =
        gestoreDatabase.pianoAlimentareRef.doc(pianoAlimentare.id);
    a.update(pianoAlimentare.toJson());
    for (Pasto? pasto in pianoAlimentare.pasti) {
      a.update({
        "pasti": FieldValue.arrayUnion([pasto?.toJson()])
      });
    }
  }

  addPianoAlimentare(PianoAlimentare pianoAlimentare) {
    if (gestoreUtente.piani
            .where((element) => element.id == pianoAlimentare.id)
            .isEmpty &&
        pianoAlimentare.nome != "") {
      gestoreUtente.addPianoAlimentare(pianoAlimentare);
    }
  }

  removePianoAlimentare(PianoAlimentare pianoAlimentare) {
    gestoreUtente.removePianoAlimentare(pianoAlimentare);
    for (Pasto? pasto in pianoAlimentare.pasti) {
      removePastoPianoAlimentare(pianoAlimentare, pasto!);
    }
    gestoreDatabase.pianoAlimentareRef.doc(pianoAlimentare.id).delete();
  }

  ///Metodi pasto

  Pasto createPastoPianoAlimentare(
      PianoAlimentare piano,
      CategoriaPasto categoria,
      int calorie,
      String descrizione,
      String nome,
      String oraPasto,
      int giornoPasto,
      int quantita,
      String type) {
    Pasto pasto = piano.createPasto(categoria, calorie, descrizione, nome,
        oraPasto, giornoPasto, quantita, type);
    piano.addPasto(pasto);
    gestoreDatabase.pastoRef.doc(pasto.id).set(pasto.toJson());
    updatePianoAlimentare(piano);
    return pasto;
  }

  Pasto createPastoOfDay(CategoriaPasto categoria, int calorie,
      String descrizione, String nome, int quantita, String type,
      String idUtente,
      [DateTime? datePasto]) {
    Pasto pasto;
    if (datePasto != null) {
      pasto = Pasto(
          categoria, calorie, descrizione, nome, quantita, type, idUtente, datePasto);
    } else {
      pasto = Pasto(categoria, calorie, descrizione, nome, quantita, type,idUtente);
    }
    gestoreUtente.addPastoOfDay(pasto);
    gestoreDatabase.pastoRef.doc(pasto.id).set(pasto.toJson());
    return pasto;
  }

  Future<List<Pasto>> getPastiOfDay(String idUtente, DateTime day) async {
    gestoreUtente.pastiOfDay.clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.pastoRef.get();
    final allPastiInDb = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allPastiInDb) {
      await gestoreDatabase.pastoRef.doc(item).get().then((element) async {
        Pasto pasto = Pasto.fromJson(element.data()!);
        int? year = pasto.oraDelGiorno?.year;
        int? month = pasto.oraDelGiorno?.month;
        int? giorno = pasto.oraDelGiorno?.day;
        if (giorno == day.day && month == day.month && year == day.year && pasto.idUtente == idUtente) {
          gestoreUtente.addPastoOfDay(pasto);
        }
      });
    }
    return gestoreUtente.pastiOfDay;
  }

  Future<List<Pasto?>> getPastiOfPianoAlimentare(
      PianoAlimentare pianoAlimentare) async {
    pianoAlimentare.pasti.clear();
    QuerySnapshot querySnapshot = await gestoreDatabase.pastoRef.get();
    final allPastiInDb = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allPastiInDb) {
      await gestoreDatabase.pastoRef.doc(item).get().then((element) async {
        Pasto pasto = Pasto.fromJson(element.data()!);
        if (pasto.pianoAlimentare == pianoAlimentare.id) {
          pasto.idUtente = pianoAlimentare.idUtente;
          pianoAlimentare.addPasto(pasto);
        }
      });
    }
    return pianoAlimentare.pasti;
  }

  addPasto(PianoAlimentare piano, Pasto pasto) {
    if (piano.pasti.where((element) => element?.id == pasto.id).isEmpty) {
      piano.addPasto(pasto);
      updatePianoAlimentare(piano);
    }
  }

  removePastoGiornaliero(Pasto pasto) =>
      gestoreDatabase.pastoRef.doc(pasto.id).delete();

  removePastoPianoAlimentare(PianoAlimentare piano, Pasto pasto) {
    piano.removePasto(pasto);
    gestoreDatabase.pastoRef.doc(pasto.id).delete();
    updatePianoAlimentare(piano);
  }

  updatePasto(Pasto pasto) {
    gestoreDatabase.pastoRef.doc(pasto.id).update(pasto.toJson());
  }

  ///metodi per gestire notifiche

  NotificationService? get notificator => _notificationService;

  void sendNotificationWhen(String titolo, String body, DateTime data) {
    Random random = Random();
    var id = random.nextInt(1000000);
    notificator?.scheduleNotifications(id, titolo, body, data);
  }

  void sendNotification(String titolo, String body, String payload) {
    Random random = Random();
    var id = random.nextInt(1000000);
    notificator?.showNotifications(id, titolo, body, payload);
  }

  ///metodi get by id

  Future<SchedaPalestra> getSchedaPalestraById(String id) async {
    DocumentSnapshot doc =
        await gestoreDatabase.schedaPalestraRef.doc(id).get();
    return SchedaPalestra.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Allenamento?> getAllenamentoById(String id) async {
    DocumentSnapshot doc = await gestoreDatabase.allenamentoRef.doc(id).get();
    return Allenamento.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<AnagraficaUtente?> getAnagraficaById(String id) async {
    DocumentSnapshot doc =
        await gestoreDatabase.anagraficaUtenteRef.doc(id).get();
    return AnagraficaUtente.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<CronometroProgrammabile?> getCronometroProgrammabileById(
      String id) async {
    DocumentSnapshot doc =
        await gestoreDatabase.cronometroProgRef.doc(id).get();
    return CronometroProgrammabile.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Esercizio> getEsercizioById(String id) async {
    DocumentSnapshot doc = await gestoreDatabase.esercizioRef.doc(id).get();
    return Esercizio.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Pasto?> getPastoById(String id) async {
    DocumentSnapshot doc = await gestoreDatabase.pastoRef.doc(id).get();
    return Pasto.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<PianoAlimentare?> getPianoAlimentareById(String id) async {
    DocumentSnapshot doc =
        await gestoreDatabase.pianoAlimentareRef.doc(id).get();
    return PianoAlimentare.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Utente?> getUtenteById(String id) async {
    DocumentSnapshot doc = await gestoreDatabase.utenteRef.doc(id).get();
    return Utente.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Utente?> getUtenteByEmail(String email) async {
    QuerySnapshot querySnapshot = await gestoreDatabase.utenteRef.get();
    final allUsersInDB = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allUsersInDB) {
      await gestoreDatabase.utenteRef.doc(item).get().then((element) async {
        var user = Utente.fromJson(element.data()!);
        if (user.email == email) {
          return user;
        }
      });
    }
  }
}

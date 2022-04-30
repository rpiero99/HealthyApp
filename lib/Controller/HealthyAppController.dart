// ignore_for_file: file_names

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Utils/GeoLocService.dart';
import 'package:healthy_app/Utils/MapEserciziDay.dart';
import 'package:healthy_app/Utils/NotificationService.dart';
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
  final NotificationService? _notificationService = NotificationService.instance;

  HealthyAppController._privateConstructor();

  static final instance = HealthyAppController._privateConstructor();

  ///Metodi per login e registrazione

  login(String email, String password) => gestoreAuth.login(email,password);

  registrazione(String email, String password) => gestoreAuth.registrazione(email, password);

  ///Metodi per allenamento

  Allenamento createAllenamento(String descrizione, String nome) {
    Allenamento allenamento =
        gestoreAllenamento.createAllenamento(descrizione, nome);
    gestoreDatabase.allenamentoRef.doc(allenamento.id).set(allenamento.toJson());
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

  updateAllenamento(Allenamento allenamento) {
    gestoreDatabase.allenamentoRef.doc(allenamento.id).set(allenamento.toJson());
  }


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
    gestoreDatabase.schedaPalestraRef.doc(scheda.id).set(scheda.toJson());
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
            SchedaPalestra scheda = SchedaPalestra.fromJson(element.data()!);
            scheda.id = value;
        addSchedaPalestra(scheda);
      });
    }
    return gestoreSchedaPalestra.schedePalestra;
  }

  updateSchedaPalestra(SchedaPalestra scheda) async{
    DocumentReference a = gestoreDatabase.schedaPalestraRef.doc(scheda.id);
    a.update(scheda.toJson());
    for(Esercizio es in scheda.getAllEsercizi()){
      a.update({"esercizi": FieldValue.arrayUnion([es.toJson()])});
    }
  }

  addSchedaPalestra(SchedaPalestra scheda) =>
      gestoreSchedaPalestra.addSchedaPalestra(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) {
    gestoreSchedaPalestra.removeSchedaPalestra(scheda);
    DocumentReference a = gestoreDatabase.schedaPalestraRef.doc(scheda.id);
    //todo rimuovere gli esercizi al suo interno
    a.delete();
  }


  ///Metodi cronometro programmabile

  CronometroProgrammabile createCronometroProgrammabile(
      int tempoPreparazione,
      int tempoRiposo,
      int tempoLavoro,
      int tempoTotale) {
    CronometroProgrammabile cronometroProgrammabile =
        gestoreSchedaPalestra.createCronometroProgrammabile(
             tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);
    gestoreDatabase.cronometroProgRef.doc(cronometroProgrammabile.id).set(cronometroProgrammabile.toJson());
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
          .doc(cronometroProgrammabile.id)
          .update(cronometroProgrammabile.toJson());

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
    gestoreDatabase.utenteRef.doc(user.id).set(user.toJson());
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
      gestoreDatabase.utenteRef.doc(user.id).update(user.toJson());

  void addUtente(Utente item) {
    gestoreUtente.addUtente(item);
  }

  ///Metodi anagrafica utente

  AnagraficaUtente createAnagraficaUtente(int altezza,
      DateTime dataNascita, String nome, double peso, String sesso) {
    AnagraficaUtente anagrafica = gestoreUtente.createAnagraficaUtente(
        altezza, dataNascita, nome, peso, sesso);
    gestoreDatabase.anagraficaUtenteRef.doc(anagrafica.id).set(anagrafica.toJson());
    return anagrafica;
  }

  setAnagraficaUtente(Utente user, AnagraficaUtente anagrafica) {
    gestoreDatabase.anagraficaUtenteRef.doc(anagrafica.id).set(anagrafica.toJson());
    user.anagraficaUtente = anagrafica;
    updateUtente(user);
  }

  updateAnagraficaUtente(AnagraficaUtente anagrafica) =>
    gestoreDatabase.anagraficaUtenteRef.doc(anagrafica.id).update(anagrafica.toJson());

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
    schedaPalestra.addEsercizio(esercizio);
    gestoreDatabase.esercizioRef.doc(esercizio.id).set(esercizio.toJson());
    updateSchedaPalestra(schedaPalestra);
    return esercizio;
  }

  updateEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio) {
    gestoreDatabase.esercizioRef.doc(esercizio.id).update(esercizio.toJson());
    schedaPalestra.updateEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  addEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio) {
    schedaPalestra.addEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  removeEsercizio(SchedaPalestra schedaPalestra, Esercizio esercizio) {
    schedaPalestra.removeEsercizio(esercizio);
    updateSchedaPalestra(schedaPalestra);
  }

  ///Metodi piano alimentare

  PianoAlimentare createPianoAlimentare(DateTime dataFine, DateTime dataInizio,
      String descrizione, Utente utente) {
    PianoAlimentare piano = gestoreUtente.createPianoAlimentare(
        dataFine, dataInizio, descrizione, utente);
    gestoreUtente.addPianoAlimentare(piano);
    gestoreDatabase.pianoAlimentareRef.doc(piano.id).set(piano.toJson());
    return piano;
  }

  updatePianoAlimentare(PianoAlimentare pianoAlimentare){
    DocumentReference a = gestoreDatabase.pianoAlimentareRef.doc(pianoAlimentare.id);
    a.update(pianoAlimentare.toJson());
    for(Pasto? pasto in pianoAlimentare.pasti){
      a.update({"pasti": FieldValue.arrayUnion([pasto?.toJson()])});
    }
  }


  addPianoAlimentare(PianoAlimentare pianoAlimentare) =>
      gestoreUtente.addPianoAlimentare(pianoAlimentare);

  removePianoAlimentare(PianoAlimentare pianoAlimentare) =>
      gestoreUtente.removePianoAlimentare(pianoAlimentare);

  ///Metodi pasto

  Pasto createPastoPianoAlimentare(
      PianoAlimentare piano,
      Enum categoria,
      int calorie,
      String descrizione,
      String nome,
      int oraPasto,
      int giornoPasto,
      int quantita,
      String type) {
    Pasto pasto = piano.createPasto(
        categoria, calorie, descrizione, nome, oraPasto, giornoPasto, quantita, type);
    piano.addPasto(pasto);
    gestoreDatabase.pastoRef.doc(pasto.id).set(pasto.toJson());
    updatePianoAlimentare(piano);
    return pasto;
  }

  Pasto createPastoOfDay(
      Enum categoria,
      int calorie,
      String descrizione,
      String nome,
      int quantita,
      String type
      ){
    Pasto pasto = Pasto(categoria, calorie, descrizione, nome, quantita, type);
    gestoreUtente.addPastoOfDay(pasto);
    gestoreDatabase.pastoRef.doc(pasto.id).set(pasto.toJson());
    return pasto;
  }

  Future<List<Pasto>> getPastOfDay(DateTime day) async{
    QuerySnapshot querySnapshot = await gestoreDatabase.pastoRef.get();
    final allPastiInDb = querySnapshot.docs.map((doc) => doc.id);
    for (var item in allPastiInDb) {
      await gestoreDatabase.pastoRef
          .doc(item)
          .get()
          .then((element) async {
            Pasto pasto = Pasto.fromJson(element.data()!);
            int? year = pasto.oraDelGiorno?.year;
            int? month = pasto.oraDelGiorno?.month;
            int? giorno = pasto.oraDelGiorno?.day;
            if(giorno == day.day && month == day.month && year == day.year) {
              gestoreUtente.addPastoOfDay(pasto);
            }
      });
    }
    return gestoreUtente.pastiOfDay;
  }

  addPasto(PianoAlimentare piano, Pasto pasto) {
    piano.addPasto(pasto);
    updatePianoAlimentare(piano);
  }

  removePasto(PianoAlimentare piano, Pasto pasto) {
    piano.removePasto(pasto);
    updatePianoAlimentare(piano);
  }

  updatePasto(Pasto pasto) {
    gestoreDatabase.pastoRef.doc(pasto.id).update(pasto.toJson());
  }


  PianoAlimentare getCurrentPianoAlimentareOf(Utente utente) {
    return gestoreUtente.piani
        .where((element) =>
            element.utente == utente &&
            element.dataFine!.isAfter(DateTime.now()))
        .first;
  }

  ///metodi per gestire notifiche

  NotificationService? get notificator => _notificationService;

  void sendNotificationWhen(String titolo, String body, DateTime data){
    Random random = Random();
    var id = 0 + random.nextInt(1000000 - 0);
    notificator?.scheduleNotifications(0, titolo, body, data);
  }

  void sendNotification(String titolo, String body, String payload){
    Random random = Random();
    var id = 0 + random.nextInt(1000000 - 0);
    notificator?.showNotifications(0, titolo, body, payload);
  }

  ///metodi get by id

  Future<SchedaPalestra> getSchedaPalestraById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.schedaPalestraRef.doc(id).get();
    return SchedaPalestra.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Allenamento?> getAllenamentoById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.allenamentoRef.doc(id).get();
    return Allenamento.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<AnagraficaUtente?> getAnagraficaById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.anagraficaUtenteRef.doc(id).get();
    return AnagraficaUtente.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<CronometroProgrammabile?> getCronometroProgrammabileById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.cronometroProgRef.doc(id).get();
    return CronometroProgrammabile.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Esercizio> getEsercizioById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.esercizioRef.doc(id).get();
    return Esercizio.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Pasto?> getPastoById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.pastoRef.doc(id).get();
    return Pasto.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<PianoAlimentare?> getPianoAlimentareById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.pianoAlimentareRef.doc(id).get();
    return PianoAlimentare.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<Utente?> getUtenteById(String id) async{
    DocumentSnapshot doc = await gestoreDatabase.utenteRef.doc(id).get();
    return Utente.fromJson(doc.data() as Map<String, dynamic>);
  }
}

import 'dart:async';
import 'dart:ffi';

import 'package:healthy_app/Model/Allenamento.dart';
import 'package:healthy_app/Model/Handlers/GestoreAllenamento.dart';
import 'package:healthy_app/Model/Handlers/GestoreDatabase.dart';
import 'package:healthy_app/Model/Handlers/GestoreLogin.dart';
import 'package:healthy_app/Model/Handlers/GestoreRegistrazione.dart';
import 'package:healthy_app/Model/Handlers/GestoreSchedaPalestra.dart';
import 'package:healthy_app/Model/Handlers/GestoreUtente.dart';

import '../Model/AnagraficaUtente.dart';
import '../Model/CronometroProgrammabile.dart';
import '../Model/SchedaPalestra.dart';
import '../Model/Utente.dart';

class HealthyAppController{
  GestoreAllenamento gestoreAllenamento = GestoreAllenamento();
  GestoreDatabase gestoreDatabase = GestoreDatabase();
  GestoreLogin gestoreLogin = GestoreLogin();
  GestoreRegistrazione gestoreRegistrazione = GestoreRegistrazione();
  GestoreSchedaPalestra gestoreSchedaPalestra = GestoreSchedaPalestra();
  GestoreUtente gestoreUtente = GestoreUtente();

  HealthyAppController();

  Allenamento createAllenamento(int calorieConsumate,
      String descrizione,
      Float distanza,
      String image,
      String nome,
      DateTime oraInizio,
      DateTime oraFine,
      DateTime tempoPerKm,
      DateTime tempoTotale,
      Float velocitaMedia) {
    return gestoreAllenamento.createAllenamento(calorieConsumate, descrizione, distanza, image, nome, oraInizio, oraFine, tempoPerKm, tempoTotale, velocitaMedia);
  }

  List<Allenamento> get allenamenti => gestoreAllenamento.allenamenti;

  login(String email, String password) => gestoreLogin.login(email, password);

  registrazione(Utente utente) => gestoreRegistrazione.registrazione(utente);

  SchedaPalestra createSchedaPalestra(String descrizione, String nome) => gestoreSchedaPalestra.createSchedaPalestra(descrizione, nome);

  List<SchedaPalestra> get schedePalestra => gestoreSchedaPalestra.schede;

  addSchedaPalestra(SchedaPalestra scheda) => gestoreSchedaPalestra.addSchedaPalestra(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) => gestoreSchedaPalestra.removeSchedaPalestra(scheda);

  CronometroProgrammabile createCronometroProgrammabile(
      Timer timer,
      Timer tempoPreparazione,
      Timer tempoRiposo,
      Timer tempoLavoro,
      int tempoTotale) => gestoreSchedaPalestra.createCronometroProgrammabile(timer, tempoPreparazione, tempoRiposo, tempoLavoro, tempoTotale);

  Utente createUtente(
      AnagraficaUtente anagrafica, String email, String password) => gestoreUtente.createUtente(anagrafica, email, password);

  List<Utente> get utenti => gestoreUtente.utenti;


}
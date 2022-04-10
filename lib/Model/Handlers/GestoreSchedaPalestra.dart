// ignore_for_file: file_names

import '../CronometroProgrammabile.dart';
import '../SchedaPalestra.dart';
import 'dart:async';

class GestoreSchedaPalestra {
  List<SchedaPalestra> schede = List.empty(growable: true);

  GestoreSchedaPalestra._privateConstructor();
  static final instance = GestoreSchedaPalestra._privateConstructor();

  SchedaPalestra createSchedaPalestra(String descrizione, String nome) =>
      SchedaPalestra(descrizione, nome);

  CronometroProgrammabile createCronometroProgrammabile(
          Timer timer,
          Timer tempoPreparazione,
          Timer tempoRiposo,
          Timer tempoLavoro,
          int tempoTotale) =>
      CronometroProgrammabile(
          tempoLavoro, tempoPreparazione, tempoRiposo, tempoTotale, timer);

  List<SchedaPalestra> get schedePalestra => schede;

  addSchedaPalestra(SchedaPalestra scheda) => schede.add(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) => schede.remove(scheda);
}

// ignore_for_file: file_names

import '../CronometroProgrammabile.dart';
import '../SchedaPalestra.dart';
import 'dart:async';

class GestoreSchedaPalestra {
  final List<SchedaPalestra> _schede = List.empty(growable: true);
  final List<CronometroProgrammabile> _cronometriProg = List.empty(growable: true);

  GestoreSchedaPalestra._privateConstructor();
  static final instance = GestoreSchedaPalestra._privateConstructor();

  SchedaPalestra createSchedaPalestra(String descrizione, String nome) =>
      SchedaPalestra(descrizione, nome);

  CronometroProgrammabile createCronometroProgrammabile(
          Timer timer,
          int tempoPreparazione,
          int tempoRiposo,
          int tempoLavoro,
          int tempoTotale) =>
      CronometroProgrammabile(
          tempoLavoro, tempoPreparazione, tempoRiposo, tempoTotale, timer);

  List<SchedaPalestra> get schedePalestra => _schede;

  addSchedaPalestra(SchedaPalestra scheda) => _schede.add(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) => _schede.remove(scheda);

  List<CronometroProgrammabile> get cronometriProg => _cronometriProg;

  addCronProg(CronometroProgrammabile cronProg) => _cronometriProg.add(cronProg);

  removeCronProg(CronometroProgrammabile cronProg) => _cronometriProg.remove(cronProg);


}

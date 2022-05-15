// ignore_for_file: file_names

import '../CronometroProgrammabile.dart';
import '../SchedaPalestra.dart';
import 'dart:async';

class GestoreSchedaPalestra {
  final List<SchedaPalestra> _schede = List.empty(growable: true);
  final List<CronometroProgrammabile> _cronometriProg = List.empty(growable: true);

  GestoreSchedaPalestra._privateConstructor();
  static final instance = GestoreSchedaPalestra._privateConstructor();

  SchedaPalestra createSchedaPalestra(String descrizione, String nome, DateTime? dataInizio, DateTime? dataFine, String idUtente) =>
      SchedaPalestra(descrizione, nome, dataInizio, dataFine, idUtente);

  CronometroProgrammabile createCronometroProgrammabile(
          int tempoPreparazione,
          int tempoRiposo,
          int tempoLavoro,
          int tempoTotale) =>
      CronometroProgrammabile(
          tempoLavoro, tempoPreparazione, tempoRiposo, tempoTotale);

  List<SchedaPalestra> get schedePalestra => _schede;

  addSchedaPalestra(SchedaPalestra scheda) => _schede.add(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) => _schede.remove(scheda);

  List<CronometroProgrammabile> get cronometriProg => _cronometriProg;

  addCronProg(CronometroProgrammabile cronProg) => _cronometriProg.add(cronProg);

  removeCronProg(CronometroProgrammabile cronProg) => _cronometriProg.remove(cronProg);


}

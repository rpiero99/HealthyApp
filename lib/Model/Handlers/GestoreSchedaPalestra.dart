import '../CronometroProgrammabile.dart';
import '../SchedaPalestra.dart';
import 'dart:async';

class GestoreSchedaPalestra {
  List<SchedaPalestra> schede = List.empty(growable: true);

  GestoreSchedaPalestra();

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

  List<SchedaPalestra> get schedePalestra => this.schede;

  addSchedaPalestra(SchedaPalestra scheda) => this.schede.add(scheda);

  removeSchedaPalestra(SchedaPalestra scheda) => this.schede.remove(scheda);
}

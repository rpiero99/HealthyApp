import 'dart:async';

class CronometroProgrammabile {
  Timer _timer;
  Timer _tempoPreparazione;
  Timer _tempoRiposo;
  Timer _tempoLavoro;
  int _tempoTotale;

  CronometroProgrammabile(this._tempoLavoro, this._tempoPreparazione,
      this._tempoRiposo, this._tempoTotale, this._timer);
}

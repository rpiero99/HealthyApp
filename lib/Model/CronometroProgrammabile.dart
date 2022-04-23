// ignore_for_file: file_names, unnecessary_getters_setters

import 'dart:async';

class CronometroProgrammabile {
  num? _tempoPreparazione;
  num? _tempoRiposo;
  num? _tempoLavoro;
  num? _tempoTotale;
  Timer? _timer;


  CronometroProgrammabile(this._tempoLavoro, this._tempoPreparazione,
      this._tempoRiposo, this._tempoTotale);

  CronometroProgrammabile.fromJson(Map<String, dynamic> json) {
    _tempoPreparazione = json['tempoPreparazione'];
    _tempoTotale = json['tempoTotale'];
    _tempoLavoro = json['tempoWork'];
    _tempoRiposo = json['tempoRiposo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tempoRiposo'] = _tempoRiposo?.toInt();
    data['tempoPreparazione'] = _tempoPreparazione?.toInt();
    data['tempoTotale'] = _tempoTotale?.toInt();
    data['tempoWork'] = _tempoLavoro?.toInt();
    return data;
  }

  Timer? get timer => _timer;

  set timer(Timer? timer) => _timer = timer;

  num? get tempoLavoro => _tempoLavoro;

  set tempoLavoro(num? tempoLavoro) => _tempoLavoro = tempoLavoro;

  num? get tempoPreparazione => _tempoPreparazione;

  set tempoPreparazione(num? tempoPreparazione) =>
      _tempoPreparazione = tempoPreparazione;

  num? get tempoRiposo => _tempoRiposo;

  set tempoRiposo(num? tempoRiposo) => _tempoRiposo = tempoRiposo;

  num? get tempoTotale => _tempoTotale! + _tempoPreparazione!;

  set tempoTotale(num? tempoTotale) => _tempoTotale = tempoTotale;

  void startTimer() {
    timer = Timer(Duration(minutes: tempoTotale!.toInt()), stopTimer);
  }

  void stopTimer() {
    timer?.cancel();
  }
}

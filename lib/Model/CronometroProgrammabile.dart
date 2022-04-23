// ignore_for_file: file_names, unnecessary_getters_setters

import 'dart:async';

class CronometroProgrammabile {
  Timer? _timer;
  num? _tempoPreparazione;
  num? _tempoRiposo;
  num? _tempoLavoro;
  num? _tempoTotale;

  CronometroProgrammabile(this._tempoLavoro, this._tempoPreparazione,
      this._tempoRiposo, this._tempoTotale, this._timer);

  CronometroProgrammabile.fromJson(Map<String, dynamic> json) {
    _tempoPreparazione = num.tryParse(json['tempoPreparazione']);
    _tempoTotale = num.tryParse(json['tempoTotale']);
    _tempoLavoro = num.tryParse(json['tempoWork']);
    _timer = json['timer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tempoPreparazione'] = _tempoPreparazione?.toInt();
    data['tempoTotale'] = _tempoTotale?.toInt();
    data['tempoWork'] = _tempoLavoro?.toInt();
    data['timer'] = _timer;
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

  num? get tempoTotale => _tempoTotale;

  set tempoTotale(num? tempoTotale) => _tempoTotale = tempoTotale;

  void startTimer() {}

  void stopTimer() {}

  void resetTimer() {}
}

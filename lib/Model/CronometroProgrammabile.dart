import 'dart:async';

class CronometroProgrammabile {
  Timer? _timer;
  Timer? _tempoPreparazione;
  Timer? _tempoRiposo;
  Timer? _tempoLavoro;
  int? _tempoTotale;
  int? _id;

  CronometroProgrammabile(this._tempoLavoro, this._tempoPreparazione,
      this._tempoRiposo, this._tempoTotale, this._timer);

  CronometroProgrammabile.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _tempoPreparazione = json['tempoPreparazione'];
    _tempoTotale = json['tempoTotale'];
    _tempoLavoro = json['tempoWork'];
    _timer = json['timer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tempoPreparazione'] = _tempoPreparazione;
    data['tempoTotale'] = _tempoTotale;
    data['tempoWork'] = _tempoLavoro;
    data['timer'] = _timer;
    return data;
  }

  Timer? get timer => this._timer;

  set timer(Timer? timer) => this._timer = timer;

  Timer? get tempoLavoro => this._tempoLavoro;

  set tempoLavoro(Timer? tempoLavoro) => this._tempoLavoro = tempoLavoro;

  Timer? get tempoPreparazione => this._tempoPreparazione;

  set tempoPreparazione(Timer? tempoPreparazione) =>
      this._tempoPreparazione = tempoPreparazione;

  Timer? get tempoRiposo => this._tempoRiposo;

  set tempoRiposo(Timer? tempoRiposo) => this._tempoRiposo = tempoRiposo;

  int? get tempoTotale => this._tempoTotale;

  set tempoTotale(int? tempoTotale) => this._tempoTotale = tempoTotale;

  void startTimer() {}

  void stopTimer() {}
}

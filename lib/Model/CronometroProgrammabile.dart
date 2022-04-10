import 'dart:async';

class CronometroProgrammabile {
  int? _id;
  Timer? _timer;
  Timer? _tempoPreparazione;
  Timer? _tempoRiposo;
  Timer? _tempoLavoro;
  int? _tempoTotale;

  CronometroProgrammabile(this._tempoLavoro, this._tempoPreparazione,
      this._tempoRiposo, this._tempoTotale, this._timer);

  CronometroProgrammabile.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _timer = json['timer'];
    _tempoLavoro = json['tempoWork'];
    _tempoPreparazione = json['tempoPreparazione'];
    _tempoRiposo = json['tempoRiposo'];
    _tempoTotale = json['tempoTotale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['timer'] = _timer;
    data['tempoWork'] = _tempoLavoro;
    data['tempoPreparazione'] = _tempoPreparazione;
    data['tempoTotale'] = _tempoTotale;
    data['tempoRiposo'] = _tempoRiposo;
    return data;
  }

  int? get id => _id;

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
}

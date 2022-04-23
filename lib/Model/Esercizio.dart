// ignore_for_file: file_names, unnecessary_getters_setters

import 'CronometroProgrammabile.dart';

class Esercizio {
  String? _nome;
  String? _descrizione;
  num? _nRep;
  num? _nSerie;
  num? _tempoRiposo;
  CronometroProgrammabile? _cronometro;

  Esercizio(this._cronometro, this._descrizione, this._nome,
      this._nSerie, this._nRep, this._tempoRiposo);

  Esercizio.fromJson(Map<String, dynamic> json) {
    _cronometro = json['cronometroProg'] != null
        ? CronometroProgrammabile.fromJson(json['cronometroProg'])
        : null;
    _nRep = num.tryParse(json['numRep']);
    _nSerie = num.tryParse(json['numSerie']);
    _tempoRiposo = num.tryParse(json['tempoRiposo']);
    _descrizione = json['descrizione'];
    _nome = json['nome'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tempoRiposo'] = _tempoRiposo?.toInt();
    data['numSerie'] = _nSerie?.toInt();
    data['numRep'] = _nRep?.toInt();
    if (_cronometro != null) {
      data['cronometroProg'] = _cronometro?.toJson();
    }
    data['descrizione'] = _descrizione;
    data['nome'] = _nome;
    return data;
  }

  String? get nome => _nome;

  set nome(String? nome) => nome = nome;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  num? get nRep => _nRep;

  set nRep(num? rep) => _nRep = rep;

  num? get nSerie => _nSerie;

  set nSerie(num? nSerie) => _nSerie = nSerie;

  num? get tempoRiposo => _tempoRiposo;

  set tempoRiposo(num? tempoRiposo) => _tempoRiposo = tempoRiposo;

  CronometroProgrammabile? get cronometroProg => _cronometro;

  set cronometroProg(CronometroProgrammabile? cronProg) =>
      _cronometro = cronProg;
}

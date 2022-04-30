// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:healthy_app/Utils/IdGenerator.dart';

import 'CronometroProgrammabile.dart';

class Esercizio {
  String? _id;
  String? _nome;
  String? _descrizione;
  String? _idSchedaPalestra;
  num? _nRep;
  num? _nSerie;
  num? _tempoRiposo;
  CronometroProgrammabile? _cronometro;
  num? _day;

  Esercizio(this._descrizione, this._nome,
      this._nSerie, this._nRep, this._tempoRiposo, this._day, this._idSchedaPalestra) {
    id = IdGenerator.generate();
  }


  Esercizio.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    _cronometro = json['cronometroProg'] != null
        ? CronometroProgrammabile.fromJson(json['cronometroProg'])
        : null;
    _idSchedaPalestra = json['idSchedaPalestra'] ?? "";
    _nRep = json['numRep'];
    _nSerie = json['numSerie'];
    _day = json['day'];
    _tempoRiposo = json['tempoRiposo'];
    _descrizione = json['descrizione'] ?? "";
    _nome = json['nome'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id ?? "";
    data['tempoRiposo'] = _tempoRiposo?.toInt();
    data['numSerie'] = _nSerie?.toInt();
    data['numRep'] = _nRep?.toInt();
    data['day'] = _day?.toInt();
    if (_cronometro != null) {
      data['cronometroProg'] = _cronometro?.toJson();
    }
    data['descrizione'] = _descrizione ?? "";
    data['nome'] = _nome ?? "";
    data['idSchedaPalestra'] = _idSchedaPalestra ?? "";
    return data;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

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

  num? get day => _day;

  set day(num? day) => _day = day;

  String? get idSchedaPalestra => _idSchedaPalestra;

  set idSchedaPalestra(String? value) {
    _idSchedaPalestra = value;
  }

  CronometroProgrammabile? get cronometroProg => _cronometro;

  set cronometroProg(CronometroProgrammabile? cronProg) =>
      _cronometro = cronProg;
}

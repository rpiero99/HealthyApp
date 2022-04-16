// ignore_for_file: file_names, unnecessary_getters_setters

import 'CronometroProgrammabile.dart';

class Esercizio {
  int? _id = 0;
  String? _nome;
  String? _descrizione;
  String? _image;
  int? _nRep;
  int? _nSerie;
  int? _tempoRiposo;
  CronometroProgrammabile? _cronometro;

  Esercizio(this._cronometro, this._descrizione, this._image, this._nome,
      this._nSerie, this._nRep, this._tempoRiposo);

  Esercizio.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _cronometro = json['cronometroProg'] != null
        ? CronometroProgrammabile.fromJson(json['cronometroProg'])
        : null;
    _nRep = json['numRep'];
    _nSerie = json['numSerie'];
    _tempoRiposo = json['tempoRiposo'];
    _descrizione = json['descrizione'];
    _image = json['image'];
    _nome = json['nome'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tempoRiposo'] = _tempoRiposo;
    data['numSerie'] = _nSerie;
    data['numRep'] = _nRep;
    if (_cronometro != null) {
      data['cronometroProg'] = _cronometro?.toJson();
    }
    data['descrizione'] = _descrizione;
    data['image'] = _image;
    data['nome'] = _nome;
    return data;
  }

  int? get id => _id;

  String? get nome => _nome;

  set nome(String? nome) => nome = nome;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  String? get image => _image;

  set image(String? im) => _image = im;

  int? get nRep => _nRep;

  set nRep(int? rep) => _nRep = rep;

  int? get nSerie => _nSerie;

  set nSerie(int? nSerie) => _nSerie = nSerie;

  int? get tempoRiposo => _tempoRiposo;

  set tempoRiposo(int? tempoRiposo) => _tempoRiposo = tempoRiposo;

  CronometroProgrammabile? get cronometroProg => _cronometro;

  set cronometroProg(CronometroProgrammabile? cronProg) =>
      _cronometro = cronProg;
}

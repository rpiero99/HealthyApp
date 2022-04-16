// ignore_for_file: file_names, unnecessary_getters_setters

import 'dart:ffi';

class Allenamento {
  int? _id = 0;
  DateTime? _oraInizio;
  DateTime? _oraFine;
  DateTime? _tempoTotale;
  Float? _velocitaMedia;
  int? _calorieConsumate;
  Float? _distanza;
  DateTime? _tempoPerKm;
  String? _descrizione;
  String? _nome;
  String? _image;

  Allenamento(
      this._calorieConsumate,
      this._descrizione,
      this._distanza,
      this._image,
      this._nome,
      this._oraInizio,
      this._oraFine,
      this._tempoPerKm,
      this._tempoTotale,
      this._velocitaMedia);

  Allenamento.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _oraInizio = json['oraInizio'];
    _oraFine = json['oraFine'];
    _tempoPerKm = json['tempoPerKm'];
    _tempoTotale = json['tempoTot'];
    _velocitaMedia = json['velocitaMed'];
    _calorieConsumate = json['calorieCons'];
    _descrizione = json['descrizione'];
    _distanza = json['distanza'];
    _image = json['image'];
    _nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['oraInizio'] = _oraInizio;
    data['oraFine'] = _oraFine;
    data['tempoPerKm'] = _tempoPerKm;
    data['tempoTotale'] = _tempoTotale;
    data['velocitaMed'] = _velocitaMedia;
    data['calorieCons'] = _calorieConsumate;
    data['descrizione'] = _descrizione;
    data['distanza'] = _distanza;
    data['image'] = _image;
    data['nome'] = _nome;
    return data;
  }

  int? get id => _id;

  DateTime? get oraInizio => _oraInizio;

  set oraInizio(DateTime? oraInizio) => _oraInizio = oraInizio;

  DateTime? get oraFine => _oraFine;

  set oraFine(DateTime? oraFine) => _oraFine = oraFine;

  DateTime? get tempoTotale {}

  DateTime? get tempoPerKm {}

  Float? get velocitaMedia {}

  int? get calorieConsumate => _calorieConsumate;

  set calorieConsumate(int? calorieConsumate) =>
      _calorieConsumate = calorieConsumate;

  Float? get distanza => _distanza;

  setDistanza() {}

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  String? get nome => _nome;

  set nome(String? nome) => _nome = nome;

  String? get image => _image;

  set image(String? image) => _image = image;

  int calcoloCalorie(){return 0;}

  int calcoloNumeroPassi() {return 0;}

}

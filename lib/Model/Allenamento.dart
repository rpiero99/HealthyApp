// ignore_for_file: file_names, unnecessary_getters_setters

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Utente.dart';

class Allenamento {
  int? _id = 0;
  DateTime? _oraInizio;
  DateTime? _oraFine;
  int? _tempoTotale;
  double? _velocitaMedia;
  double? _calorieConsumate;
  double? _distanza;
  double? _tempoPerKm;
  String? _descrizione;
  String? _nome;

  Allenamento(this._descrizione, this._nome);

  Allenamento.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if(json['oraInizio']!=null){
      Timestamp oraIn = json['oraInizio'];
      _oraInizio = oraIn.toDate();
    }
    if(json['oraFine']!=null){
      Timestamp oraFi = json['oraFine'];
      _oraFine = oraFi.toDate();
    }
    _tempoPerKm = json['tempoPerKm'];
    _tempoTotale = json['tempoTot'];
    _velocitaMedia = json['velocitaMed'];
    _calorieConsumate = json['calorieCons'];
    _descrizione = json['descrizione'];
    _distanza = json['distanza'];
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
    data['nome'] = _nome;
    return data;
  }

  int? get id => _id;

  DateTime? get oraInizio => _oraInizio;

  set oraInizio(DateTime? oraInizio) => _oraInizio = oraInizio;

  DateTime? get oraFine => _oraFine;

  set oraFine(DateTime? oraFine) => _oraFine = oraFine;

  int? get tempoTotale {
    _tempoTotale = oraFine?.difference(oraInizio!).inMinutes;
    return _tempoTotale;
  }

  double? get tempoPerKm {
    _tempoPerKm = (tempoTotale! * 60 / distanza!);
    return _tempoPerKm;
  }

  double? get velocitaMedia {
    _velocitaMedia = (distanza! / (tempoTotale! / 60));
    return _velocitaMedia;
  }

  double? get calorieConsumate => _calorieConsumate;

  set calorieConsumate(double? calorie) => _calorieConsumate = calorie;

  double? get distanza => _distanza;

  set distanza(double? distance) => _distanza = distance;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  String? get nome => _nome;

  set nome(String? nome) => _nome = nome;

  double? calcoloCalorie(Utente utente) {
    calorieConsumate = utente.anagraficaUtente!.pesoUtente! * distanza!;
    return calorieConsumate;
  }
}

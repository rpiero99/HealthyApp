// ignore_for_file: file_names, unnecessary_getters_setters
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Utente.dart';

class Allenamento {
  DateTime? _oraInizio;
  DateTime? _oraFine;
  num? _tempoTotale;
  num? _velocitaMedia;
  num? _calorieConsumate;
  num? _distanza;
  num? _tempoPerKm;
  String? _descrizione;
  String? _nome;

  Allenamento(this._descrizione, this._nome);

  Allenamento.fromJson(Map<String?, dynamic> json) {
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
    if(oraInizio != null){
      Timestamp timestamp = Timestamp.fromDate(_oraInizio!);
      data['oraInizio'] = timestamp;
    }
    if(oraFine != null){
      Timestamp timestamp = Timestamp.fromDate(_oraFine!);
      data['oraFine'] = timestamp;
    }
    data['tempoPerKm'] = _tempoPerKm?.toInt();
    data['tempoTotale'] = _tempoTotale?.toInt();
    data['velocitaMed'] = _velocitaMedia?.toDouble();
    data['calorieCons'] = _calorieConsumate?.toInt();
    data['descrizione'] = _descrizione ?? "";
    data['distanza'] = _distanza?.toDouble();
    data['nome'] = _nome ?? "";
    return data;
  }

  DateTime? get oraInizio => _oraInizio;

  set oraInizio(DateTime? oraInizio) => _oraInizio = oraInizio;

  DateTime? get oraFine => _oraFine;

  set oraFine(DateTime? oraFine) => _oraFine = oraFine;

  num? get tempoTotale {
    _tempoTotale = oraFine?.difference(oraInizio!).inMinutes;
    return _tempoTotale;
  }

  num? get tempoPerKm {
    _tempoPerKm = (tempoTotale! * 60 / distanza!);
    return _tempoPerKm;
  }

  num? get velocitaMedia {
    _velocitaMedia = (distanza! / (tempoTotale! / 60));
    return _velocitaMedia;
  }

  num? get calorieConsumate => _calorieConsumate;

  set calorieConsumate(num? calorie) => _calorieConsumate = calorie;

  num? get distanza => _distanza;

  set distanza(num? distance) => _distanza = distance;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  String? get nome => _nome;

  set nome(String? nome) => _nome = nome;

  num? calcoloCalorie(Utente utente) {
    calorieConsumate = utente.anagraficaUtente!.pesoUtente! * distanza!;
    return calorieConsumate;
  }
}

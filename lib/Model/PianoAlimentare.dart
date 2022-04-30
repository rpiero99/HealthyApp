// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/IdGenerator.dart';
import 'Pasto.dart';
import 'Utente.dart';

class PianoAlimentare {
  String? _id;
  List<Pasto?> _pasti = List.empty(growable: true);
  DateTime? _dataInizio;
  DateTime? _dataFine;
  Utente? _utente;
  String? _descrizione;

  PianoAlimentare(this._dataFine, this._dataInizio, this._descrizione, this._utente){
    id = IdGenerator.generate();
  }

  PianoAlimentare.fromJson(Map<String, dynamic> json) {
    if (json['pasti'] != null) {
      _pasti = <Pasto>[];
      json['pasti'].forEach((p) {
        _pasti.add(Pasto.fromJson(p));
      });
    }
    if(json['dataInizio']!=null){
      Timestamp oraFi = json['dataInizio'];
      _dataInizio = oraFi.toDate();
    }
    _descrizione = json['descrizione'];
    if(json['dataFine']!=null){
      Timestamp oraFi = json['dataFine'];
      _dataFine = oraFi.toDate();
    }
    _utente = json['utente'] != null ?
      Utente.fromJson(json['utente'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pasti'] = _pasti.map((v) => v?.toJson()).toList();
    if(_dataInizio != null){
      Timestamp timestamp = Timestamp.fromDate(_dataInizio!);
      data['dataInizio'] = timestamp;
    }
    data['descrizione'] = _descrizione ?? "";
    if(dataFine != null){
      Timestamp timestamp = Timestamp.fromDate(dataFine!);
      data['dataFine'] = timestamp;
    }
    data['utente'] = _utente != null ? _utente?.toJson() : "";
    return data;
  }

  Pasto createPasto(Enum categoria, int calorie, String descrizione,
      String nome, int oraPasto, int giornoPasto,  int quantita, String type) {
    return Pasto.pianoAlimentare(categoria, calorie, descrizione, nome, oraPasto, giornoPasto, quantita, type);
  }

  void addPasto(Pasto? pasto) => _pasti.add(pasto);

  void removePasto(Pasto? pasto) => _pasti.remove(pasto);

  String? get id => _id;

  set id(String? id) => _id = id;

  DateTime? get dataInizio => _dataInizio;

  set dataInizio(DateTime? dataInizio) => _dataInizio = dataInizio;

  DateTime  ? get dataFine => _dataFine;

  set dataFine(DateTime? dataFine) => _dataFine = dataFine;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  Utente? get utente => _utente;

  set utente(Utente? utente) => _utente = utente;

  List<Pasto?> get pasti => _pasti;

  List<Pasto?> getPastiFromDayWeek(DateTime timestamp){
    List<Pasto?> toReturn = List.empty(growable: true);
   for (Pasto? element in pasti) {
      if(element?.oraDelGiorno?.weekday == timestamp.weekday)toReturn.add(element);}
   return toReturn;
  }
}

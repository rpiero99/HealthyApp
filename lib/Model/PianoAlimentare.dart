// ignore_for_file: file_names, unnecessary_getters_setters

import 'Pasto.dart';
import 'Utente.dart';

class PianoAlimentare {
  int? _id = 0;
  List<Pasto?> _pasti = List.empty(growable: true);
  DateTime? _dataInizio;
  DateTime? _dataFine;
  Utente? _utente;
  String? _descrizione;

  PianoAlimentare(this._dataFine, this._dataInizio, this._descrizione, this._utente);

  PianoAlimentare.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if (json['pasti'] != null) {
      _pasti = <Pasto>[];
      json['pasti'].forEach((p) {
        _pasti.add(Pasto.fromJson(p));
      });
    }
    _dataInizio = json['dataInizio'];
    _descrizione = json['descrizione'];
    _dataFine = json['dataFine'];
    _utente = json['utente'] != null ?
      Utente.fromJson(json['utente'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['pasti'] = _pasti.map((v) => v?.toJson()).toList();
    data['dataInizio'] = _dataInizio;
    data['descrizione'] = _descrizione;
    data['dataFine'] = _dataFine;
    if (_utente != null) {
      data['utente'] = _utente?.toJson();
    }
    return data;
  }

  Pasto createPasto(Enum categoria, int calorie, String descrizione,
      String nome, DateTime ora, int quantita, String type) {
    return Pasto(categoria, calorie, descrizione, nome, ora, quantita, type);
  }

  void addPasto(Pasto? pasto) => _pasti.add(pasto);

  void removePasto(Pasto? pasto) => _pasti.remove(pasto);

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
      if(element?.ora?.weekday == timestamp.weekday)toReturn.add(element);}
   return toReturn;
  }
}

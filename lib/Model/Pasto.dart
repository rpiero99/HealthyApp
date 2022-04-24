// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class Pasto {
  Enum? _categoria;
  String? _nome;
  String? _descrizione;
  num? _calorie;
  DateTime? _ora;
  String? _type;
  num? _quantita;

  Pasto(this._categoria, this._calorie, this._descrizione, this._nome,
      this._ora, this._quantita, this._type);

  Pasto.fromJson(Map<String, dynamic> json) {
    _calorie = json['calorie'];
    _categoria = json['categoria'];
    _descrizione = json['descrizione'] ?? "";
    _nome = json['nome'] ?? "";
    if(json['ora']!=null) {
      Timestamp oraFi = json['ora'];
      _ora = oraFi.toDate();
    }
    _quantita = json['quantita'];
    _type = json['tipo'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calorie'] = _calorie?.toInt();
    data['categoria'] = _categoria;
    data['descrizione'] = _descrizione ?? "";
    data['nome'] = _nome ?? "";
    if(_ora != null){
      Timestamp timestamp = Timestamp.fromDate(_ora!);
      data['ora'] = timestamp;
    }
    data['quantita'] = _quantita?.toInt();
    data['tipo'] = _type ?? "";
    return data;
  }

  Enum? get categoria => _categoria;

  String? get nome => _nome;

  String? get descrizione => _descrizione;

  num? get calorie => _calorie;

  DateTime? get ora => _ora;

  String? get type => _type;

  num? get quantita => _quantita;

  set categoria(Enum? categoria) => _categoria = categoria;

  set nome(String? nome) => _nome = nome;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  set ora(DateTime? ora) => _ora = ora;

  set type(String? type) => _type = type;

  set quantita(num? quantita) => _quantita = quantita;
}

// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class AnagraficaUtente {
  String? _nomeUtente;
  num? _altezzaUtente;
  num? _pesoUtente;
  DateTime? _dataNascitaUtente;
  String? _sesso;
  num? _bmi;

  AnagraficaUtente(this._altezzaUtente, this._dataNascitaUtente,
      this._nomeUtente, this._pesoUtente, this._sesso);

  AnagraficaUtente.fromJson(Map<String, dynamic> json) {
    _nomeUtente = json['nome'];
    _sesso = json['sesso'];
    _altezzaUtente = json['altezza'];
    if(json['dataNascita']!=null){
      Timestamp dataNascita = json['dataNascita'];
      _dataNascitaUtente = dataNascita.toDate();
    }
    _pesoUtente = json['peso'];
    _bmi = json['bmi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = _nomeUtente;
    data['sesso'] = _sesso;
    data['altezza'] = _altezzaUtente;
    if(dataNascitaUtente != null){
      Timestamp timestamp = Timestamp.fromDate(_dataNascitaUtente!);
      data['dataNascita'] = timestamp;
    }
    data['peso'] = _pesoUtente;
    data['bmi'] = _bmi;
    return data;
  }

  String? get nomeUtente => _nomeUtente;

  set nomeUtente(String? nome) => _nomeUtente = nome;

  num? get altezzaUtente => _altezzaUtente;

  set altezzaUtente(num? altezza) => _altezzaUtente = altezza;

  num? get pesoUtente => _pesoUtente;

  set pesoUtente(num? peso) => _pesoUtente = peso;

  DateTime? get dataNascitaUtente => _dataNascitaUtente;

  set dataNascitaUtente(DateTime? dataNascita) => _dataNascitaUtente = dataNascita;

  String? get sessoUtente => _sesso;

  set sessoUtente(String? sesso) => _sesso = sesso;

  get bmi => pesoUtente!/(altezzaUtente!/100)*(altezzaUtente!/100);
}

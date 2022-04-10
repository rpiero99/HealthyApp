import 'dart:ffi';

class AnagraficaUtente {
  int? _id = 0;
  String? _nomeUtente;
  int? _altezzaUtente;
  Float? _pesoUtente;
  DateTime? _dataNascitaUtente;
  bool? _sesso;

  AnagraficaUtente(
      this._altezzaUtente, this._dataNascitaUtente, this._nomeUtente, this._pesoUtente, this._sesso);

  AnagraficaUtente.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _nomeUtente = json['nome'];
    _sesso = json['sesso'];
    _altezzaUtente = json['altezza'];
    _dataNascitaUtente = json['dataNascita'];
    _pesoUtente = json['peso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['nome'] = _nomeUtente;
    data['sesso'] = _sesso;
    data['altezza'] = _altezzaUtente;
    data['dataNascita'] = _dataNascitaUtente;
    data['peso'] = _pesoUtente;
    return data;
  }

  int? get id => _id;

  String? get nomeUtente => _nomeUtente;

  set nomeUtente(String? nome) => _nomeUtente = nome;

  int? get altezzaUtente => _altezzaUtente;

  set altezzaUtente(int? altezza) => this._altezzaUtente = altezza;

  Float? get pesoUtente => this._pesoUtente;

  set pesoUtente(Float? peso) => this._pesoUtente = peso;

  DateTime? get dataNascitaUtente => this._dataNascitaUtente;

  set dataNascitaUtente(DateTime? eta) => this._dataNascitaUtente = eta;

  bool? get sessoUtente => this._sesso;

  set sessoUtente(bool? sesso) => this._sesso = sesso;
}

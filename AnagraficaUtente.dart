import 'dart:ffi';

class AnagraficaUtente {
  String _nomeUtente;
  int _altezzaUtente;
  Float _pesoUtente;
  int _etaUtente;

  AnagraficaUtente(
      this._altezzaUtente, this._etaUtente, this._nomeUtente, this._pesoUtente);

  String get nomeUtente => this._nomeUtente;

  set nomeUtente(String nome) => this._nomeUtente = nome;

  int get altezzaUtente => this._altezzaUtente;

  set altezzaUtente(int altezza) => this._altezzaUtente = altezza;

  Float get pesoUtente => this._pesoUtente;

  set pesoUtente(Float peso) => this._pesoUtente = peso;

  int get etaUtente => this._etaUtente;

  set etaUtente(int eta) => this._etaUtente = eta;
}

// ignore_for_file: file_names, unnecessary_getters_setters

class AnagraficaUtente {
  String? _nomeUtente;
  num? _altezzaUtente;
  num? _pesoUtente;
  DateTime? _dataNascitaUtente;
  String? _sesso;

  AnagraficaUtente(this._altezzaUtente, this._dataNascitaUtente,
      this._nomeUtente, this._pesoUtente, this._sesso);

  AnagraficaUtente.fromJson(Map<String, dynamic> json) {
    _nomeUtente = json['nome'];
    _sesso = json['sesso'];
    _altezzaUtente = json['altezza'];
    _dataNascitaUtente = json['dataNascita'];
    _pesoUtente = json['peso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = _nomeUtente;
    data['sesso'] = _sesso;
    data['altezza'] = _altezzaUtente;
    data['dataNascita'] = _dataNascitaUtente;
    data['peso'] = _pesoUtente;
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
}

import 'Esercizio.dart';

class SchedaPalestra {
  int? _id = 0;
  List<Esercizio?> _esercizi = List.empty(growable: true);
  String? _name;
  String? _descrizione;

  SchedaPalestra(this._descrizione, this._name);

  SchedaPalestra.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    if (json['esercizi'] != null) {
      _esercizi = <Esercizio>[];
      json['esercizi'].forEach((p) {
        _esercizi.add(Esercizio.fromJson(p));
      });
    }
    _name = json['nome'];
    _descrizione = json['descrizione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['esercizi'] = _esercizi.map((v) => v?.toJson()).toList();
    data['nome'] = _name;
    data['descrizione'] = _descrizione;
    return data;
  }

  int? get id => _id;

  List<Esercizio?> get esercizi => _esercizi;

  void addEsercizio(Esercizio? esercizio) => _esercizi.add(esercizio);

  void removeEsercizio(Esercizio? esercizio) => _esercizi.remove(esercizio);

  Esercizio? getEsercizioFromName(String? nome) =>
      _esercizi.where((e) => e!.nome == nome).first;

  String? get nome => _name;

  set nome(String? nome) => _name = nome;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;
}

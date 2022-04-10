import 'Esercizio.dart';

class SchedaPalestra {
  int? _id = 0;
  List<Esercizio> _esercizi = List.empty(growable: true);
  String? _name;
  String? _descrizione;

  SchedaPalestra(this._descrizione, this._name);

  int? get id => _id;
  
  List<Esercizio> get esercizi => _esercizi;

  void addEsercizio(Esercizio esercizio) => this._esercizi.add(esercizio);

  void removeEsercizio(Esercizio esercizio) => this._esercizi.remove(esercizio);

  Esercizio getEsercizioFromName(String nome) =>
      this._esercizi.where((e) => e.nome == nome).first;

  String? get nome => this._name;

  set nome(String? nome) => this._name = nome;

  String? get descrizione => _descrizione;

  set descrizione (String? descrizione) => _descrizione = descrizione;
}

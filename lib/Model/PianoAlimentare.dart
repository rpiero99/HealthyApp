import 'Pasto.dart';

class PianoAlimentare {
  int _id = 0;
  List<Pasto> _pasti = List.empty(growable: true);
  DateTime _dataInizio;
  DateTime _dataFine;
  String _descrizione;

  PianoAlimentare(this._dataFine, this._dataInizio, this._descrizione);

  Pasto createPasto(Enum categoria, int calorie, String descrizione,
      String nome, DateTime ora, int quantita, String type) {
    return new Pasto(
        categoria, calorie, descrizione, nome, ora, quantita, type);
  }

  void addPasto(Pasto pasto) => this._pasti.add(pasto);

  void removePasto(Pasto pasto) => this._pasti.remove(pasto);

  DateTime get dataInizio => this._dataInizio;

  set dataInizio(DateTime dataInizio) => this._dataInizio = dataInizio;

  DateTime get dataFine => this._dataFine;

  set DateFine(DateTime dataFine) => this._dataFine = dataFine;

  String get descrizione => this._descrizione;

  set descrizione(String descrizione) => this._descrizione = descrizione;
}

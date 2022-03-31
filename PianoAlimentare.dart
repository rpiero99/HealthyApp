import 'Pasto.dart';

class PianoAlimentare {
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

  void addPasto(Pasto pasto) {
    this._pasti.add(pasto);
  }

  void removePasto(Pasto pasto) {
    this._pasti.remove(pasto);
  }
}

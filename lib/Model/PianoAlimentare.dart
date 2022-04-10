import 'Pasto.dart';

class PianoAlimentare {
  int? _id = 0;
  List<Pasto?> _pasti = List.empty(growable: true);
  DateTime? _dataInizio;
  DateTime? _dataFine;
  String? _descrizione;

  PianoAlimentare(this._dataFine, this._dataInizio, this._descrizione);

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['pasti'] = _pasti.map((v) => v?.toJson()).toList();
    data['dataInizio'] = _dataInizio;
    data['descrizione'] = _descrizione;
    data['dataFine'] = _dataFine;
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

  DateTime? get dataFine => _dataFine;

  set DateFine(DateTime? dataFine) => _dataFine = dataFine;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;
}

import 'package:healthy_app/Model/Esercizio.dart';

class MapEserciziDay {
  int? _giorno;
  List<Esercizio?> _esercizi = List.empty(growable: true);

  MapEserciziDay(this._giorno);

  MapEserciziDay.fromJson(Map<String, dynamic> json) {
    _giorno = json["giorno"];
    if (json['esercizi'] != null) {
      _esercizi = <Esercizio>[];
      json['esercizi'].forEach((p) {
        _esercizi.add(Esercizio.fromJson(p));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['giorno'] = _giorno;
    data['esercizi'] = _esercizi.map((v) => v?.toJson()).toList();
    return data;
  }

  get giorno => _giorno;

  get eserciziOfDay => _esercizi;

  addEsercizio(Esercizio esercizio){
    _esercizi.add(esercizio);
  }

  removeEsercizio(Esercizio esercizio){
    _esercizi.remove(esercizio);
  }
}

import 'CronometroProgrammabile.dart';

class Esercizio {
  int? _id = 0;
  String? _nome;
  String? _descrizione;
  String? _image;
  int? _ripetizioni;
  int? _numeroSerie;
  DateTime? _tempoRiposo;
  CronometroProgrammabile? _cronometro;

  Esercizio(this._cronometro, this._descrizione, this._image, this._nome,
      this._numeroSerie, this._ripetizioni, this._tempoRiposo);

  Esercizio.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _cronometro = json['cronometroProg'] != null ? CronometroProgrammabile.fromJson(json['cronometroProgram']) : null;
    _ripetizioni = json['numRep'];
    _numeroSerie = json['numSerie'];
    _tempoRiposo = json['tempoRiposo'];
    _descrizione = json['descrizione'];
    _image = json['image'];
    _nome = json['nome'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['tempoRiposo'] = _tempoRiposo;
    data['numSerie'] = _numeroSerie;
    data['numRep'] = _ripetizioni;
    if(_cronometro!=null) {
      data['cronometroProg'] = _cronometro?.toJson();
    }
    data['descrizione'] = _descrizione;
    data['image'] = _image;
    data['nome'] = _nome;
    return data;
  }


  int? get id => _id;
  
  String? get nome => _nome;

  set nome(String? nome) => nome = nome;

  String? get descrizione => _descrizione;

  set descrizione (String? descrizione) => _descrizione = descrizione;

  String? get image => _image;

  set image(String? im) => _image = im;

  int? get ripetizioni => _ripetizioni;

  set ripetizioni(int? ripetizioni) => _ripetizioni = ripetizioni;

 int? get numeroSerie => _numeroSerie;

 set numeroSerie(int? nSerie) => _numeroSerie = nSerie;

 DateTime? get tempoRiposo => _tempoRiposo;

 set tempoRiposo(DateTime? tempoRiposo) => _tempoRiposo = tempoRiposo;

 CronometroProgrammabile? get cronometroProg => _cronometro;

 set cronometroProg(CronometroProgrammabile? cronProg) => _cronometro = cronProg;
} 

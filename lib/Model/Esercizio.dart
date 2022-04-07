import 'CronometroProgrammabile.dart';

class Esercizio {
  int _id = 0;
  String _nome;
  String _descrizione;
  String _image;
  int _ripetizioni;
  int _numeroSerie;
  DateTime _tempoRiposo;
  CronometroProgrammabile _cronometro;

  Esercizio(this._cronometro, this._descrizione, this._image, this._nome,
      this._numeroSerie, this._ripetizioni, this._tempoRiposo);

  int get id => _id;
  
  String get nome => _nome;

  set nome(String nome) => nome = nome;

  String get descrizione => _descrizione;

  String get image => _image;

  set image(String im) => _image = im;

  int get ripetizioni => _ripetizioni;

  set ripetizioni(int ripetizioni) => _ripetizioni = ripetizioni;

 int get numeroSerie => _numeroSerie;

 set numeroSerie(int nSerie) => _numeroSerie = nSerie;

 DateTime get tempoRiposo => _tempoRiposo;

 set tempoRiposo(DateTime tempoRiposo) => _tempoRiposo = tempoRiposo;

 CronometroProgrammabile get cronometroProg => _cronometro;

 set cronometroProg(CronometroProgrammabile cronProg) => _cronometro = cronProg;
} 

import 'CronometroProgrammabile.dart';

class Esercizio {
  String _nome;
  String _descrizione;
  String _image;
  int _ripetizioni;
  int _numeroSerie;
  DateTime _tempoRiposo;
  CronometroProgrammabile _cronometro;

  Esercizio(this._cronometro, this._descrizione, this._image, this._nome,
      this._numeroSerie, this._ripetizioni, this._tempoRiposo);

  String get nome => _nome;
}

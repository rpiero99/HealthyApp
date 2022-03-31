import 'dart:ffi';

class Allenamento {
  DateTime _oraInizio;
  DateTime _oraOraFine;
  DateTime _tempoTotale;
  Float _velocitaMedia;
  int _calorieConsumate;
  Float _distanza;
  DateTime _tempoPerKm;
  String _descrizione;
  String _nome;
  String _image;

  Allenamento(
      this._calorieConsumate,
      this._descrizione,
      this._distanza,
      this._image,
      this._nome,
      this._oraInizio,
      this._oraOraFine,
      this._tempoPerKm,
      this._tempoTotale,
      this._velocitaMedia);
}

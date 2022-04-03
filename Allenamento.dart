import 'dart:ffi';

class Allenamento {
  DateTime _oraInizio;
  DateTime _oraFine;
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
      this._oraFine,
      this._tempoPerKm,
      this._tempoTotale,
      this._velocitaMedia);

  DateTime get oraInizio => this._oraInizio;

  set oraInizio(DateTime oraInizio) => this._oraInizio = oraInizio;

  DateTime get oraFine => this._oraFine;

  set oraFine(DateTime oraFine) => this._oraFine = oraFine;

  DateTime get tempoTotale => this._tempoTotale;

  set tempoTotale(DateTime tempoTotale) => this._tempoTotale = tempoTotale;

  DateTime get tempoPerKm => this._tempoPerKm;

  set tempoPerKm(DateTime tempoPerKm) => this._tempoPerKm = tempoPerKm;

  Float get velocitaMedia => this._velocitaMedia;

  set velocitaMedia(Float velocitaMedia) => this._velocitaMedia = velocitaMedia;

  int get calorieConsumate => this._calorieConsumate;

  set calorieConsumate(int calorieConsumate) =>
      this._calorieConsumate = calorieConsumate;

  Float get distanza => this._distanza;

  set distanza(Float distanza) => this._distanza = distanza;

  String get descrizione => this._descrizione;

  set descrizione(String descrizione) => this._descrizione = descrizione;

  String get nome => this._nome;

  set nome(String nome) => this._nome = nome;

  String get image => this._image;

  set image(String image) => this._image = image;
}

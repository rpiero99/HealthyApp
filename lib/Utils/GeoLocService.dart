import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';

class GeoLocService{
  Stream<StepCount>? _stepCountStream;
  int? _numSteps;
  Position? _startPosition;
  Position? _endPosition;

  GeoLocService(){
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(onStepCount).onError(onStepCountError);
  }

  Position? get startPosition => _startPosition;

  Position? get endPosition => _endPosition;

  set startPosition(Position? start) => _startPosition = start;

  set endPosition(Position? end) => _endPosition = end;

  int? get numSteps => _numSteps;

  Future<Position> getCurrentPosition() async {
   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void onStepCount(StepCount event) {
    _numSteps = event.steps;
    DateTime timeStamp = event.timeStamp;
  }

  void onStepCountError(error) {
    /// Handle the error
  }

  double? calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void cancelListener(){
    _stepCountStream?.listen(onStepCount).cancel();
  }

}
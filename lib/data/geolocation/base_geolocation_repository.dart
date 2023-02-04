import 'package:geolocator/geolocator.dart';

abstract class BaseGeolocationRepository {
  // ignore: body_might_complete_normally_nullable
  Future<Position?> getCurrentLocation() async {}
}

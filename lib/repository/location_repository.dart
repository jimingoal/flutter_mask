import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Future<Position> getCurrentLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}

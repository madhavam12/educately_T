import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:hive/hive.dart';

class GeolocationService {
  Future<List> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return [false, "Location services are disabled."];
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return [false, 'Location permissions are denied'];
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return [
        false,
        'Location permissions are permanently denied, we cannot request permissions.'
      ];
    }
    Position pos = await Geolocator.getCurrentPosition();
    String city = await getCityName(pos);
    return [
      true,
      city,
    ];
  }

  Future<String> getCityName(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    var box = Hive.box('city');

    box.put('name', placemarks[0].locality);
    return placemarks[0].locality;
  }
}

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class CurrentLocation {
//   Future<String> getCurrentLocation() async{

//     LocationPermission permission = await Geolocator.requestPermission();
//     if(permission == LocationPermission.denied){
//       permission = await Geolocator.requestPermission();
//     }
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print("🟨Current Location: ${position.latitude}, ${position.longitude}");

//     // List<Placemark> Placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     String cityName = placemarks[0].locality!;
//     print("😜City Name: $cityName");
//     return cityName;

//   }
// }

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation {
  Future<String> getCurrentLocation() async {
    try {
      // ✅ Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Location services are disabled.";
      }

      // ✅ Check & request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Location permission denied.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return "Location permission permanently denied. Please enable it in settings.";
      }

      // ✅ Get current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("📍 Current Location: ${position.latitude}, ${position.longitude}");

      // ✅ Reverse geocoding to get city name
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String? city = placemarks[0].locality; // Might be null in some cases
        String? country = placemarks[0].country; 

        if (city != null) {
          print(" City Name: $city, Country: $country");
          return city;
        } else {
          return "City name not found.";
        }
      } else {
        return "No placemarks found.";
      }
    } catch (e) {
      print("❌ Error getting location: $e");
      return "Error fetching city.";
    }
  }
}

// class TomorrowIo {
//   final String locationName;
//   final double temperature;
//   final int humidity;
//   final int windSpeed;
//   final double rainIntensity;
//   final double cloudCeiling;
//   final double cloudCover;
//   final DateTime time;

//   TomorrowIo({
//     required this.locationName, 
//     required this.temperature, 
//     required this.humidity, 
//     required this.windSpeed, 
//     required this.rainIntensity, 
//     required this.cloudCeiling, 
//     required this.cloudCover, 
//     required this.time
    
//     });

//   factory TomorrowIo.fromJson(Map<String, dynamic> json) {
//     return TomorrowIo(
//       locationName: json['location']['name'],
//       temperature: json['timelines']['minutely'][0]['values']['temperature'].toDouble(),
//       humidity: json['timelines']['minutely'][0]['values']['humidity'].toInt(),
//       windSpeed: json['timelines']['minutely'][0]['values']['windspeed'].toInt(),
//       rainIntensity: json['timelines']['minutely'][0]['values']['precipitationIntensity'].toDouble(),
//       cloudCeiling: json['timelines']['minutely'][0]['values']['cloudCeiling'].toDouble(),
//       cloudCover: json['timelines']['minutely'][0]['values']['cloudCover'].toDouble(),
//       time: DateTime.parse(json['timelines']['minutely'][0]['time']),
//     );

//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'locationName': locationName,
//       'temperature': temperature,
//       'humidity': humidity,
//       'windSpeed': windSpeed,
//       'rainIntensity': rainIntensity,
//       'cloudCeiling': cloudCeiling,
//       'cloudCover': cloudCover,
//       'time': "",
//     };
//   }

// }

import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


class TomorrowIo {
  final String locationName;
  final double locationLatitude;
  final double locationLongitude;
  final double temperature;
  final int humidity;
  final int windSpeed;
  final double rainIntensity;
  final double cloudCeiling;
  final double cloudCover;
  final int weatherCode;
  final DateTime time;
  List<dynamic> hourlyWeather = [];

  TomorrowIo({
    required this.locationName, 
    required this.temperature, 
    required this.humidity, 
    required this.windSpeed, 
    required this.rainIntensity, 
    required this.cloudCeiling, 
    required this.cloudCover, 
    required this.time,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.weatherCode,
    required this.hourlyWeather,

  });

  factory TomorrowIo.fromJson(Map<String, dynamic> json) {
    
    // Extract values safely with null checking
    final minutelyData = json['timelines']['minutely'][0]['values'];
    
    return TomorrowIo(
      locationName: json['location']['name'] ?? 'Unknown Location',
      temperature: _safeDoubleValue(minutelyData['temperature']),
      humidity: _safeIntValue(minutelyData['humidity']),
      windSpeed: _safeIntValue(minutelyData['windSpeed']),
      rainIntensity: _safeDoubleValue(minutelyData['precipitationIntensity']),
      cloudCeiling: _safeDoubleValue(minutelyData['cloudCeiling']),
      cloudCover: _safeDoubleValue(minutelyData['cloudCover']),
      time: DateTime.parse(json['timelines']['minutely'][0]['time']),
      locationLatitude: _safeDoubleValue(json['location']['lat']),
      locationLongitude: _safeDoubleValue(json['location']['lon']),
      weatherCode: _safeIntValue(minutelyData['weatherCode']),
      hourlyWeather: json['timelines']['hourly'] ?? [],
    );
  }

  get location => null;

  // Helper methods to safely convert values
  static int _safeIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    return 0;
  }

  static double _safeDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainIntensity': rainIntensity,
      'cloudCeiling': cloudCeiling,
      'cloudCover': cloudCover,
      'time': time.toIso8601String(),
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'weatherCode': weatherCode,
      'hourlyWeather': hourlyWeather,
    };
  }




  Future<void> fetchDailyWeather() async{
    final String API_KEY = "";
    final url = "https://api.tomorrow.io/v4/timelines?location=$locationName&fields=temperature,precipitationProbability,precipitationType&timesteps=1d&units=metric&apikey=$API_KEY";
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      print("Response: $json");

      final dailyWeather = json['timelines']['daily'];

      if(dailyWeather != null && dailyWeather.length > 3){
        final tomorrowWeather = dailyWeather[1]['values'];
        final dayAfterTomorrowWeather = dailyWeather[2]['values'];


        print("Tomorrow's Weather: $tomorrowWeather");
        print("Day After Tomorrow's Weather: $dayAfterTomorrowWeather");
      } else {
        print("No daily weather data available.");
      }

    }



  }
}
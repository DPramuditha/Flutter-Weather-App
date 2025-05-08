import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:westher_app/api_services/future_weather.dart';
import 'package:westher_app/api_services/weather_services.dart';
import 'package:westher_app/api_services/current_location.dart';


class GetWeatherApi {

  static const BASE_URL = "http://api.weatherapi.com/v1";
  final String apikey;
  final String lang = "&lang=si";
  final String aqi = "&aqi=yes";

  GetWeatherApi({
    required this.apikey
    });

    Future<WeatherServices> getWeather(String cityName) async{
      try{
        final url = "$BASE_URL/current.json?key=$apikey&q=$cityName&$aqi&$lang";
        final response = await http.get(Uri.parse(url));
        if(response.statusCode ==200){
          final json = jsonDecode(response.body);
          print("☀️Response: $json");
          return WeatherServices.fromJson(json);

        }
        else{
          throw Exception("❌Failed to load weather data");
        }

      }
      catch(e){
        print("Error: $e");
        throw Exception("❌Failed to load weather data");
      }
    }


    Future<WeatherServices> getWeatherCurrentLocation() async{
      try{
        final location = await CurrentLocation().getCurrentLocation();
        if(location.contains("disabled") || location.contains("denied")){
          throw Exception("❌Location permission denied");
        }
        print("🟨Current Location: $location");
        final url = "$BASE_URL/current.json?key=$apikey&q=$location&$aqi&$lang";
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          final json = jsonDecode(response.body);
          return WeatherServices.fromJson(json);
        }
        else{
          throw Exception("❌Failed to load weather data");
        }
      }
      catch(e){
        print("Error: $e");
        throw Exception("❌Failed to load weather data");
      }
    }



    Future<FutureWeather> getHourlyFutureWeather(String city) async{
      try{
        final location = await CurrentLocation().getCurrentLocation();
        if(location.contains("disabled") || location.contains("denied")){
          throw Exception("❌Location permission denied");
        }
        print("✅Current Location: $location");

        final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=5&aqi=yes&alerts=yes";
        final response = await http.get(Uri.parse(url));
        if(response.statusCode == 200){
          final json = jsonDecode(response.body);
          print("☀️Response: $json");
          return FutureWeather.fromJson(json);
          
        }
        else{
          throw Exception("❌Failed to load future weather data");
        }

      }
      catch(e){
        print("Error: $e");
        throw Exception("❌Failed to load future weather data");
      }
    }
  
}
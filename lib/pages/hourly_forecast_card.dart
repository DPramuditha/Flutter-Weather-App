import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:westher_app/api_services/current_location.dart';
import 'package:westher_app/api_services/future_weather.dart';

class HourlyForecastCard extends StatefulWidget {
  const HourlyForecastCard({super.key});

  @override
  State<HourlyForecastCard> createState() => _HourlyForecastCardState();
}

class _HourlyForecastCardState extends State<HourlyForecastCard> {

  FutureWeather? _futureWeather;

  // void fetchHourlyForecast() async {
  //   try {
  //     String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
  //     String city = await CurrentLocation().getCurrentLocation();
  //     final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=1&aqi=yes&alerts=no";
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       setState(() {
  //         _futureWeather = FutureWeather.fromJson(json);
  //       });
  //     } else {
  //       print("❌ Failed to fetch hourly forecast: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("❌ Error: $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchHourlyForecast();
  }

void fetchHourlyForecast() async {
  try {
    print("🔵 Getting location...");
    final city =await CurrentLocation().getCurrentLocation();

    if (city.startsWith("❌") || city.contains("denied")) {
      print("❌ Cannot fetch weather. Reason: $city");
      return;
    }
    //api key
    String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
    print("✅Current Location: $city");

    print("Fetching weather for: $city");
    final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=1&aqi=yes&alerts=no";
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("✅ Weather Data: $json");
      setState(() {
        _futureWeather = FutureWeather.fromJson(json);
      });
    } else {
      print("❌ Failed to fetch weather: ${response.body}");
    }
  } catch (e) {
    print("❌ Error: $e");
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _futureWeather != null 
        ? SingleChildScrollView(
            child: Column(
              children: [
                Text("Hourly Forecast", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SizedBox(
                  height: 200, // Set a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _futureWeather!.hourlyWeather.length,
                    itemBuilder: (context, index) {
                      var hour = _futureWeather!.hourlyWeather[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(hour['time'].split(" ")[1], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Image.network("https:${hour['icon']}", width: 40),
                              Text("${hour['temp']}°C", style: TextStyle(fontSize: 18)),
                              Text(hour['condition'], style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        )
        : const Center(
            child: CircularProgressIndicator(
              color: Color(0xffffa633),
            ),
          ),
    );
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:westher_app/api_services/future_weather.dart';
import 'package:westher_app/api_services/weather_services.dart';
import 'package:westher_app/pages/notification/local_notification.dart';
import 'package:westher_app/pages/weather_main.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

    
   FutureWeather? _futureWeather;
   WeatherServices? _weatherServices;

   

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
  try {
    print("🔵 Getting location...");
    // final city = await CurrentLocation().getCurrentLocation();
    final city = "Attanagalla"; 


    if (city.startsWith("❌") || city.contains("denied")) {
      print("❌ Cannot fetch weather. Reason: $city");
      return;
    }
    //api key
    String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
    print("✅Current Location: $city");

    print("Fetching weather for: $city");
    // final url = "http://api.weatherapi.com/v1/current.json?key=$apikey&q=$city&aqi=yes";
    //  final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=3&aqi=yes&alerts=yes";
     final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=3&aqi=yes&alerts=yes&lang=si";
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); // ✅ This is the fix!
      final json = jsonDecode(decodedBody);
      print("✅ Weather Data: $json");
      setState(() {
        
         _futureWeather = FutureWeather.fromJson(json);
         _weatherServices = WeatherServices.fromJson(json);
         print("✅ Weather data set successfully!");
      });
      print("✅ Weather fetched successfully!");
    } else {
      print("❌ Failed to fetch weather: ${response.body}");
    }
  } catch (e) {
    print("❌ Error: $e");
  }
}


 bool _isClicked = false;
  void _onClick() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Lottie.asset(
            //   'animation_assets/wind-day.json',
            //    width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            SizedBox(
              width: double.infinity,
              height: 400,
              child: ModelViewer(
                src: 'animation_assets/sun.glb',
                alt: "A 3D model of a wind turbine",
                autoRotate: true,
                autoPlay: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xff9400d8), Color(0xff8000bf), Color(0xff6a00a0) ]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text("Welcome to Weather",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Your comprehensive weather companion with real-time updates, forecasts, and beautiful visualizations. Stay prepared for any weather condition!",
                      style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton.icon(onPressed: () async{
                      _onClick();
                      Duration(seconds: 2);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WeatherMain()));
                      await LocalNotification.showNotification(
                        title: "${_weatherServices?.cityName},${_weatherServices?.country}", 
                        body: "Welcome to Weather App! \n${_futureWeather?.temperature.round()}°C ${_futureWeather?.condition} Rain Chance: ${_futureWeather?.dailyChanceOfRain}%");

        
                    }, icon: _isClicked ? Icon(Icons.check_circle, color: Colors.blue,) : Icon(Icons.arrow_forward, color: Colors.black,),
                    label: Text(_isClicked ? "Weather App" : "Get Started",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    ),),
                    SizedBox(height: 20,),
                    
                    
                  ],
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
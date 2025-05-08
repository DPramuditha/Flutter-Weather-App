import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:westher_app/api_services/current_location.dart';
import 'package:westher_app/api_services/get_weather_api.dart';
import 'package:westher_app/api_services/weather_services.dart';
import 'package:westher_app/pages/search_city.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  final GetWeatherApi _getWeatherApi = GetWeatherApi(apikey: dotenv.env["WEATHER_API_KEY"]?? "");
  
  WeatherServices? _weatherServices;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  // void fetchWeather() async{
  //   try{
  //     final weather = await _getWeatherApi.getWeatherCurrentLocation();
  //     if(weather.cityName.contains("disabled") || weather.cityName.contains("denied")){
  //       setState(() {
  //         _weatherServices = null;
  //       });
  //       return;
  //     }
  //     setState(() {
  //       _weatherServices = weather;
  //     });
  //   }
  //   catch(e){
  //     print("Error: $e");
  //   }
  // }

  void fetchWeather() async {
  try {
    print("🔵 Getting location...");
    final city = await CurrentLocation().getCurrentLocation();

    if (city.startsWith("❌") || city.contains("denied")) {
      print("❌ Cannot fetch weather. Reason: $city");
      return;
    }
    //api key
    String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
    print("🟨 Current Location: $city");

    print("Fetching weather for: $city");
    final url = "http://api.weatherapi.com/v1/current.json?key=$apikey&q=$city&aqi=yes&lang=si";
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("✅ Weather Data: $json");
      setState(() {
        _weatherServices = WeatherServices.fromJson(json);
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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCity()));
          },
          icon: Icon(Icons.add_box_rounded)),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset("animation_assets/rain_day.json",
            width: double.infinity,
            fit: BoxFit.cover,
            height: 300,
            ),

            // Image(image: AssetImage("assets/mainImage.jpg"),
            //   width: double.infinity,
            //   height: 400,
            //   fit: BoxFit.cover,
            // ),
              Column(
                children: [
                  Text("${_weatherServices?.cityName}", style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(_weatherServices!.country, style: GoogleFonts.outfit(
                    fontSize: 20,
                  ),),
                  Text("${_weatherServices!.temperature}°C", style: GoogleFonts.outfit(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(_weatherServices!.condition, style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: -0.5,
                  ),),
                  Image(image: NetworkImage("https:${_weatherServices!.icon}"),
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 10,),
                  Text("Feels like 27°C", style: GoogleFonts.outfit(
                    fontSize: 20,
                  ),),
                  SizedBox(height: 20,),
                          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Color(0xffb388eb),Color(0xff9d75d9),Color(0xff8762c7),Color(0xff714fa5),]
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.yellow,),
                                  Text("Humidity", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  Text("60%", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),), 
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Color(0xffb388eb),Color(0xff9d75d9),Color(0xff8762c7),Color(0xff714fa5),]
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.yellow,),
                                  Text("Humidity", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  Text("60%", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                ],
                              ),
                            ),
                          
                          )
                        ],
                      ),
   
                    ],    
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Color(0xffb388eb),Color(0xff9d75d9),Color(0xff8762c7),Color(0xff714fa5),]
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.yellow,),
                                  Text("Wind", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  Text("10 km/h", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Color(0xffb388eb),Color(0xff9d75d9),Color(0xff8762c7),Color(0xff714fa5),]
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.yellow,),
                                  Text("Humidity", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  Text("60%", style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                ],
                              ),
                            ),
                          )
                        ],
                      ) 
                    ],
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
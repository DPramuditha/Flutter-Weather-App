import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:westher_app/api_services/current_location.dart';
import 'package:westher_app/api_services/future_weather.dart';
import 'package:westher_app/api_services/weather_services.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
   
   
  
   WeatherServices? _weatherServices;
   FutureWeather? _futureWeather;

   

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
  try {
    print("🔵 Getting location...");
    // final city = await CurrentLocation().getCurrentLocation();
    final city = "attanagalla"; 


    if (city.startsWith("❌") || city.contains("denied")) {
      print("❌ Cannot fetch weather. Reason: $city");
      return;
    }
    //api key
    String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
    print("✅Current Location: $city");

    print("Fetching weather for: $city");
    // final url = "http://api.weatherapi.com/v1/current.json?key=$apikey&q=$city&aqi=yes";
     final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=1&aqi=yes&alerts=yes";
    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("✅ Weather Data: $json");
      setState(() {
        _weatherServices = WeatherServices.fromJson(json);
         _futureWeather = FutureWeather.fromJson(json);
      });
    } else {
      print("❌ Failed to fetch weather: ${response.body}");
    }
  } catch (e) {
    print("❌ Error: $e");
  }
}

Color getWeatherCardColor(String condition) {
  if (condition.contains("Sunny")) {
    return Color(0xffff8500);
  } 
   else if(condition.contains("Partly cloudy") || condition.contains("Partly Cloudy")){
    return Color(0xffffe633);
  }
  else if(condition.contains("Patchy rain nearby") || condition.contains("Patchy rain nearby")){
    return Color(0xff503cb7);
  }
  else if (condition.contains("Cloudy") || condition.contains("Overcast")) {
    return Color(0xffe0c48b);
  } 
  else if (condition.contains("Rain") || condition.contains("Showers")) {
    return Color(0xff422ea8);
  } else if (condition.contains("Thunderstorm")) {
    return Color(0xff9400d8);
  } else if (condition.contains("Snow")) {
    return Color(0xff8664e3);
  }
   else {
    return Color(0xffffe6cc); 
  }
}

//#503cb7


 LinearGradient getWeatherGradient(String condition) {
  if (condition.contains("Sunny")) {
    return LinearGradient(
      colors: [Color(0xffff8500), Color(0xffffe6cc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Partly cloudy") || condition.contains("Partly Cloudy")) {
    return LinearGradient(
      colors: [Color(0xffffe633), Color(0xff503cb7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Patchy rain nearby") || condition.contains("Patchy rain nearby")) {
    return LinearGradient(
      colors: [Color(0xff503cb7), Color(0xff422ea8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Cloudy") || condition.contains("Overcast")) {
    return LinearGradient(
      colors: [Color(0xffe0c48b), Color(0xff422ea8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Rain") || condition.contains("Showers")) {
    return LinearGradient(
      colors: [Color(0xff422ea8), Color(0xff9400d8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Thunderstorm")) {
    return LinearGradient(
      colors: [Color(0xff9400d8), Color(0xff8664e3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else if (condition.contains("Snow")) {
    return LinearGradient(
      colors: [Color(0xff8664e3), Color(0xffffe6cc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  } else {
    return LinearGradient(
      colors: [Color(0xfff5f5dc), Color(0xfff0f0c0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.search)),
        ],
      ),
      body: _weatherServices != null
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "animation_assets/rain_day.json",
                    width: double.infinity,
                    height: 290,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: [
                      Text(
                        "${_weatherServices?.cityName}",
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_weatherServices?.country}",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${_weatherServices?.temperature.toInt()}°C",
                        style: GoogleFonts.outfit(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                          "${_weatherServices?.condition}",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          Image(image: NetworkImage(
                          "https:${_weatherServices?.icon}"),
                          width: 100,
                          height: 100,
                          ),
                        ],
                      ),
                      Text("Chance of Rain: ${_futureWeather?.dailyChanceOfRain}%",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: -1.0,
                        ),
                      ),
                      Text(
                        "Feels Like: ${_weatherServices?.feelslike}°C",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        
                        ),
                      ),
                SizedBox(
                  height: 180, // Set a fixed height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: _futureWeather!.hourlyWeather.length,
                    itemBuilder: (context, index) {
                      var hour = _futureWeather!.hourlyWeather[index];
                      return Card(
                        elevation: 10,
                        color: getWeatherCardColor(hour['condition']),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(hour['time'].split(" ")[1], style: GoogleFonts.outfit(
                                fontSize: 16, fontWeight: FontWeight.bold,
                              )),
                              Image.network("https:${hour['icon']}", width: 70),
                              Text("${hour['temp']}°C", style: GoogleFonts.outfit(
                                fontSize: 18, fontWeight: FontWeight.bold,
                              )),
                              Text(hour['condition'], style: GoogleFonts.outfit(
                                fontSize: 14
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: double.infinity,
                            height: 320,
                            decoration: BoxDecoration(
                              // color: getWeatherCardColor(_weatherServices!.condition),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                  ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Lottie.asset(
                                    "animation_assets/day_night.json",
                                    width: double.infinity,
                                    // height: 260,
                                    fit: BoxFit.cover,
                                  ),
                                
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Sunrise: ${_futureWeather?.sunrise}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // SizedBox(width: 10),
                                      Text(
                                        "Sunset: ${_futureWeather?.sunset}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Moonrise: ${_futureWeather?.moonrise}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // SizedBox(width: 5),
                                      Text("Moonset: ${_futureWeather?.moonset}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 160,
                          height: 150,
                          decoration: BoxDecoration(
                            color: getWeatherCardColor(_weatherServices!.condition),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.air, size: 40, color: Colors.white),
                              Text(
                                "Humidity",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${_weatherServices?.humidity}%",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: 160,
                          height: 150,
                          decoration: BoxDecoration(
                            color: getWeatherCardColor(_weatherServices!.condition),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Icon(Icons.air, size: 40, color: Colors.white),
                              Text(
                                "Wind",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${_weatherServices?.wind} km/h",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                ],
              ),
            )
          : Center(
              // child: CircularProgressIndicator(),
              child: Lottie.asset("animation_assets/loading.json", 
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
      // backgroundColor: _weatherServices != null 
      //     ? getWeatherCardColor(_weatherServices!.condition)
      //     : Colors.white,
    );
  }
}
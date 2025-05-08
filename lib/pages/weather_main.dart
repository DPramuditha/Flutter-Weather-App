import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:westher_app/api_services/current_location.dart';
import 'package:westher_app/api_services/future_weather.dart';
import 'package:westher_app/api_services/weather_services.dart';
import 'package:westher_app/api_services/weather_tomorrow.dart';
import 'package:westher_app/pages/search_city.dart';
import 'package:westher_app/pages/weather_test.dart';

class WeatherMain extends StatefulWidget {
  const WeatherMain({super.key});

  @override
  State<WeatherMain> createState() => _WeatherMainState();
}

class _WeatherMainState extends State<WeatherMain> {

   WeatherServices? _weatherServices;
   FutureWeather? _futureWeather;
   WeatherTomorrow? _weatherTomorrow;

   

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
  try {
    print("🔵 Getting location...");
    final city = await CurrentLocation().getCurrentLocation();
    // final city = "Attanagalla"; 


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
        _weatherServices = WeatherServices.fromJson(json);
         _futureWeather = FutureWeather.fromJson(json);
        _weatherTomorrow = WeatherTomorrow.fromJson(json);
      });
      print("✅ Weather fetched successfully!");
    } else {
      print("❌ Failed to fetch weather: ${response.body}");
    }
  } catch (e) {
    print("❌ Error: $e");
  }
}

  Color textColor = Colors.black;
  
  String getAirQualityLevel(int index) {
    switch (index) {
      case 1:
      case 2:
      case 3:
        textColor = Colors.green;
        return "Low";
      case 4:
      case 5:
      case 6:
        textColor = Colors.orange;
        return "Moderate";
      case 7:
      case 8:
      case 9:
        textColor = Colors.red;
        return "High";
      case 10:
        textColor = Colors.purple;
        return "Very High";
      default:
        textColor = Colors.grey;
        return "Unknown";
    }
  }

  Widget _weatherDetailItem({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String getLottieAnimationPath(int? conditionCode) {
    // Default animation if no condition code is available
    if (conditionCode == null) return "animation_assets/woman-takin.json";
    
    // Sunny/Clear conditions (1000)
    if (conditionCode == 1000) {
      return "animation_assets/woman-takin.json";
    }
    
    // Rain conditions (all rain-related codes)
    if ([1063, 1150, 1153, 1180, 1183, 1186, 1189, 1192, 1195, 1240, 1243, 1246].contains(conditionCode)) {
      return "animation_assets/rain_day.json";
    }
    
    // Windy conditions (assuming you have wind animations for these codes)
    // Note: Adjust these codes based on what you consider "windy"
    if ([1030, 1117, 1135].contains(conditionCode)) {
      return "animation_assets/wind-day.json";
    }
    
    // Default to sunny/clear for any other condition
    return "animation_assets/woman-takin.json";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _weatherServices != null ? Text("${_weatherServices?.cityName}, ${_weatherServices?.country}",style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),)
        : Center(
          child: Lottie.asset("animation_assets/loading_appbar.json", 
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
        leading: Icon(
          Icons.location_pin,
          color: Colors.blue,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchCity(),
                ),
              );
            },
          ),
        ],
      ),
      body: _futureWeather!= null || _weatherServices != null
          ? 
      SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              child: Lottie.asset(
              getLottieAnimationPath(_weatherServices?.code),
              )
            ),
            Column(
              children: [
                  Text("Today ${_futureWeather?.time}",style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),),
              
                    
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${_futureWeather?.temperature.round()}",
                    style: GoogleFonts.rubik(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    ),),
                    Column(
                    children: [
                      Text("°C",style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      ),),
                      Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Air: ${getAirQualityLevel(_futureWeather?.gbDefraIndex ?? 0)}",
                        style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        ),
                      ),
                      ),
                    ],
                    ),
                  ],
                  ),
                    
                    Positioned(
                    right: 10,
                    top: 10, // Changed from 60 to 40 to move it higher
                    child: RotatedBox(
                      quarterTurns: 3, // Rotates 90 degrees clockwise
                      child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(Icons.cloud, color: Colors.blue, size: 20),
                      SizedBox(width: 5),
                      Text(
                      "Feels Like ${double.parse(_weatherServices?.feelslike ?? '0').round()}°C",
                      style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                      )
                      ],
                      ),
                    ),
                    ),
                    ],
                    ),
                  ),
                    // Positioned(
                    // left: 10,
                    // top: 200,
                    //   child: RotatedBox(
                    //     quarterTurns: 1,
                    //     child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(Icons.cloud, color: Colors.black, size: 20),
                    //       SizedBox(width: 5),
                    //       Text(
                    //       "Feels Like ${_weatherServices?.feelslike}°C",
                    //       style: GoogleFonts.outfit(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       )
                    //     ],
                    //     ),
                    //   ),
                    // ),
            

              
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        ),
                      ],
                      ),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Column(
                          children: [
                            Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                "${_futureWeather?.condition}",
                                style: GoogleFonts.notoSansSinhala(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                ),
                              ),
                              ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                image: NetworkImage("https:${_weatherServices?.icon}"),
                                width: 100,
                                height: 100,
                              ),
                              ),
                            ],
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                  BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: Offset(0, 5)
                  ),
                  BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, -2)
                  )
                  ]
                  ),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    _weatherDetailItem(
                      icon: Icons.water_drop_outlined,
                      value: "${_weatherServices?.humidity}%",
                      label: "Humidity",
                      iconColor: Colors.blue,
                    ),
                    _weatherDetailItem(
                      icon: Icons.air,
                      value: "${_weatherServices?.wind} km/h",
                      label: "Wind",
                      iconColor: Colors.cyan,
                    ),
                    _weatherDetailItem(
                      icon: Icons.umbrella_outlined,
                      value: "${_futureWeather?.dailyChanceOfRain}%",
                      label: "Rain Chance",
                      iconColor: Colors.indigo,
                    ),
                    ],
                    ),
                    ],
                  ),
                  ),
                  ),
                  ),
                  ),

                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 920,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xfff4d8c2), Color(0xffe4c8b2), Color(0xffd5b7a4)]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),    
                    ),
                    // color: Color(0xfff1e1c2).withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                      color: Color(0xfff4d8c2).withOpacity(0.1),
                      spreadRadius: 8,
                      blurRadius: 25,
                      offset: Offset(0, 4),
                      ),
                      BoxShadow(
                      color: Color(0xffe0c48b).withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 20,
                      ),
                    ],
                  ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hourly Weather Section
                      SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: _futureWeather!.hourlyWeather.length,
                        itemBuilder: (context, index) {
                        var hour = _futureWeather!.hourlyWeather[index];
                        return Padding(
                          padding: EdgeInsets.only(
                          top: 20,
                          left: 12,
                          right: 12,
                          ),
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              ),
                            ],
                            ),
                            child: Image.network("https:${hour['icon']}", width: 70),
                            ),
                            Text("${hour['temp'].round()}°C", style: GoogleFonts.outfit(
                            fontSize: 18, fontWeight: FontWeight.bold,
                            )),
                            Text(hour['time'].split(" ")[1], style: GoogleFonts.outfit(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            )),
                            Text(hour['condition'], style: GoogleFonts.outfit(
                            fontSize: 14
                            )),
                          ],
                          ),
                        );
                        },
                      ),
                      ),
                    // Tomorrow's Weather Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tomorrow's Forecast",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${_weatherTomorrow?.date}",style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                      "Tomorrow",
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.water_drop, color: Colors.blue, size: 16),
                                        SizedBox(width: 5),
                                        Text(
                                          "Rain: ${_weatherTomorrow?.dailyChanceOfRain}%",
                                          style: GoogleFonts.outfit(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${_weatherTomorrow?.temperature?.toInt() ?? 0}°",
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Image.network(
                                      "https:${_weatherTomorrow?.icon}",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Air Quality Detail Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                        children: [
                          Icon(Icons.air_rounded, color: Colors.teal, size: 24),
                          SizedBox(width: 8),
                          Text(
                          "Air Quality Details",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          ),
                        ],
                        ),
                        SizedBox(height: 10),
                        Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                          ],
                        ),
                        child: Column(
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            Column(
                              children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.co2, color: Colors.red, size: 22),
                              ),
                              SizedBox(height: 5),
                              _airQualityItem(
                                label: "CO",
                                value: "${_futureWeather?.airQualityCo.toStringAsFixed(2) ?? 'N/A'} μg/m³",
                              ),
                              ],
                            ),
                            Column(
                              children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.warning_amber_rounded, color: Colors.amber[700], size: 22),
                              ),
                              SizedBox(height: 5),
                              _airQualityItem(
                                label: "NO₂",
                                value: "${_weatherServices?.airQualityNo2?.toStringAsFixed(2) ?? 'N/A'} μg/m³",
                              ),
                              ],
                            ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            Column(
                              children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.cloud_outlined, color: Colors.blue, size: 22),
                              ),
                              SizedBox(height: 5),
                              _airQualityItem(
                                label: "O₃",
                                value: "${_weatherServices?.airQualityO3?.toStringAsFixed(2) ?? 'N/A'} μg/m³",
                              ),
                              ],
                            ),
                            Column(
                              children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.water_damage_outlined, color: Colors.purple, size: 22),
                              ),
                              SizedBox(height: 5),
                              _airQualityItem(
                                label: "SO₂",
                                value: "${_weatherServices?.airQualitySo2?.toStringAsFixed(2) ?? 'N/A'} μg/m³",
                              ),
                              ],
                            ),
                            ],
                          ),
                          ],
                        ),
                        ),
                      ],
                      ),
                    ),
                    // Sunrise and Sunset Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sunrise & Sunset",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.wb_sunny_rounded,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Sunrise",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _futureWeather?.sunrise.split(' ')[0] ?? '6:00 AM',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 60,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.nightlight_round,
                                        color: Colors.deepPurple,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Sunset",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _futureWeather?.sunset.split(' ')[0] ?? '6:00 PM',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        GestureDetector(
                                      onTap: () {
                                        // Navigate to live weather map
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OpenWeatherMap(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.blue.shade400, Colors.blue.shade700],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.3),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.map_outlined,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Live Weather Map",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    ],
                    ),
                  ),  
              ],
            ),
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
      
    );
    
  }
}


                   // Helper method for air quality items (add this to the class)
                    Widget _airQualityItem({required String label, required String value}) {
                      return Column(
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            value,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    }
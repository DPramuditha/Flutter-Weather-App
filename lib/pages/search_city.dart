import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:westher_app/api_services/future_weather.dart';
import 'package:westher_app/api_services/tomorrow_io.dart';
import 'package:westher_app/api_services/weather_services.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {

  TextEditingController _searchCityController = TextEditingController();


  TomorrowIo? _tomorrowIo;

  @override
  void initState() {
    super.initState();
    // _fetchWeatherData(_searchCityController.text);
    fetchWeather(_searchCityController.text);
  }


  // Future<void> _fetchWeatherData(String city) async{
  //   try{
  //     String apiKey = dotenv.env["WEATHER_API_KEY"] ?? "API_KEY_NOT_FOUND";
  //     final response = await http.get(Uri.parse("http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=1&aqi="));
  //     if(response.statusCode == 200){
  //       setState(() {
  //         _weatherServices = WeatherServices.fromJson(jsonDecode(response.body));
  //         _futureWeather = FutureWeather.fromJson(jsonDecode(response.body));
  //       });
  //       print("City: ${_weatherServices?.cityName}");
  //       print("Country: ${_weatherServices?.country}");
  //     }else if(response.statusCode == 404){
  //       print("City not found");
  //       // Lottie.asset("animation_assets/error.json",
  //       //   width: 200,
  //       //   fit: BoxFit.cover,
  //       // );
  //       setState(() {
  //         _weatherServices = null;
  //         _futureWeather = null;
  //       });
  //     }else{
  //       throw Exception("Failed to load weather data");
  //     }

  //   }
  //   catch(e){
  //     print(e.toString());
  //   }
  // }

 void fetchWeather(String city) async {
  try {
    print("🔵 Getting location...");
    // final city = await CurrentLocation().getCurrentLocation();
    // final city = "Colombo"; 


    if (city.startsWith("❌") || city.contains("denied")) {
      print("❌ Cannot fetch weather. Reason: $city");
      return;
    }
    //api key
    // String apikey = dotenv.env["WEATHER_API_KEY"] ?? "";
    String apikey = "hhi43TIvdX2zNZJBQ8oJ3g06mjkIYW6r"; // Replace with your actual API key

    print("✅Current Location: $city");

    print("Fetching weather for: $city");

    //  final url = "http://api.weatherapi.com/v1/forecast.json?key=$apikey&q=$city&days=3&aqi=yes&alerts=yes&lang=si";
     final url ='https://api.tomorrow.io/v4/weather/forecast?location=$city&apikey=$apikey';

    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes); // ✅ This is the fix!
      final json = jsonDecode(decodedBody);

      setState(() {
        _tomorrowIo = TomorrowIo.fromJson(json);
        // Ensure hourly weather data exists
        if (_tomorrowIo!.hourlyWeather.isNotEmpty) {
          findAndDisplayCurrentWeather();
        }
      });

      print("✅ Weather Data: $json");
      setState(() {
        _tomorrowIo = TomorrowIo.fromJson(json);

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


    String apiKey = dotenv.env["Tomorrow_Weather_API_KEY"] ?? "API_KEY_NOT_FOUND";

    Widget _weatherItem({
      required String title,
      required String value,
      required IconData icon,
      required Color color,
    }) {
      return Container(
        width: 120,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 5),
            Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value, style: GoogleFonts.outfit(fontSize: 14)),
          ],
        ),
      );

    }

  String getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 1000: // Clear, Sunny
        return '☀️';
      case 1100: // Mostly Clear
        return '🌤️';
      case 1101: // Partly Cloudy
        return '⛅';
      case 1102: // Mostly Cloudy
        return '🌥️';
      case 1001: // Cloudy
        return '☁️';
      case 2000: // Fog
        return '🌫️';
      case 2100: // Light Fog
        return '🌫️';
      case 4000: // Drizzle
        return '🌦️';
      case 4001: // Rain
        return '🌧️';
      case 4200: // Light Rain
        return '🌧️';
      case 4201: // Heavy Rain
        return '⛈️';
      case 5000: // Snow
        return '❄️';
      case 5001: // Flurries
        return '🌨️';
      case 5100: // Light Snow
        return '🌨️';
      case 5101: // Heavy Snow
        return '⛄';
      case 6000: // Freezing Drizzle
        return '🌧️';
      case 6001: // Freezing Rain
        return '🌨️';
      case 7000: // Thunder
        return '⚡';
      case 7101: // Strong Winds
        return '💨';
      case 8000: // Thunderstorm
        return '⛈️';
      default:
        return '🌡️';
    }

}

  Map<String, dynamic>? currentWeather;
  // void findCurrentWeather(){
  //   DateTime now = DateTime.now().toUtc();

  //   for (var weatherEntry in _tomorrowIo!.hourlyWeather) {
  //   DateTime entryTime = DateTime.parse(weatherEntry['time']);
  //   if (entryTime.hour == now.hour && entryTime.day == now.day) {
  //     setState(() {
  //       currentWeather = weatherEntry['values'];
  //       print("✅Current Weather: $currentWeather");
  //     });
  //     break;
  //   }
  // }
  //  if (currentWeather == null && _tomorrowIo!.hourlyWeather.isNotEmpty) {
  //   setState(() {
  //     currentWeather = _tomorrowIo!.hourlyWeather[0]['values'];
  //   });
  // }

  // }


  // Add this function to find and display current weather
void findAndDisplayCurrentWeather() {
  if (_tomorrowIo == null || _tomorrowIo!.hourlyWeather.isEmpty) {
    return;
  }
  
  // Get current time in Sri Lanka (UTC+5:30)
  final now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
  
  // Find the closest hourly forecast time
  Map<String, dynamic>? closestWeather;
  Duration smallestDifference = Duration(days: 1);
  
  for (var entry in _tomorrowIo!.hourlyWeather) {
    final entryTime = DateTime.parse(entry['time']);
    final difference = entryTime.difference(now).abs();
    
    if (difference < smallestDifference) {
      smallestDifference = difference;
      closestWeather = entry['values'];
    }
  }
  
  if (closestWeather != null) {
    setState(() {
      currentWeather = closestWeather;
      print("✅ Current weather found for Sri Lanka time: ${now.toString()}");
      print("✅ Current Weather: $currentWeather");
    });
  } else if (_tomorrowIo!.hourlyWeather.isNotEmpty) {
    setState(() {
      currentWeather = _tomorrowIo!.hourlyWeather[0]['values'];
      print("⚠️ Using first forecast entry as fallback");
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Icon(Icons.location_pin, color: Colors.blue, size: 40),
        title: _tomorrowIo != null ? Builder(
          builder: (context) {
            // Parse location parts safely
            final locationParts = _tomorrowIo!.locationName.split(",").map((e) => e.trim()).toList();
            
            // Extract city and region if available
            String mainLocation = locationParts.isNotEmpty ? locationParts[0] : "Unknown";
            String secondaryLocation = locationParts.length > 1 ? locationParts[1] : "";
            
            // Extract country or last element if available
            String country = "";
            if (locationParts.length > 2) {
              country = locationParts.last;
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  secondaryLocation.isEmpty ? mainLocation : '$mainLocation, $secondaryLocation',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (country.isNotEmpty)
                  Text(
                    country,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            );
          },
        ) : Lottie.asset(
          "animation_assets/loading_appbar 01.json", 
          width: 140,
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background Map Layer
                _tomorrowIo != null ? Positioned.fill(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(_tomorrowIo?.locationLatitude ?? 0.0, _tomorrowIo?.locationLongitude ?? 0.0),
                      maxZoom: 18,
                      minZoom: 5,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.none, // Disable map interactions
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                        // opacity: 0.7, // Make the map slightly transparent
                      ),
                      // TileLayer(
                      //   urlTemplate: 'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=$apiKey',
                      //   userAgentPackageName: 'com.example.rainmap',
                      //   tileProvider: NetworkTileProvider(),
                      // ),

              //         TileLayer(
              //   urlTemplate:
              //       'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key={apiKey}&traffic_incidents=incidents_s0&traffic_flow=flow_relative0&poi=poi_main', // Use style URL if available
              //   additionalOptions: {
              //     'apiKey': apiKey,
              //   },
              // ),
                    MarkerLayer(
              markers: [
    if (_tomorrowIo?.locationLatitude != null && _tomorrowIo?.locationLongitude != null)
          Marker(
        width: 40,
        height: 40,
        point: LatLng(
          _tomorrowIo!.locationLatitude,
          _tomorrowIo!.locationLongitude,
        ),
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
  ],
),
                    ],
                  ),
                ) : Container(
                  color: Colors.grey[200], // Fallback background color
                ),
                
                // Content Layer with Semi-transparent background
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Add a semi-transparent overlay to improve readability
                      Column(
                        children: [
                          // Search bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 280,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xff503cb7), Color(0xff422ea8)]),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                    
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2
                                    ),
                                    child: TextFormField(
                                      controller: _searchCityController,
                                      decoration: InputDecoration(
                                        hintText: "Search City",
                                        hintStyle: TextStyle(color: Colors.white),
                                        prefixIcon: Icon(Icons.search, color: Colors.white),
                                        fillColor: Colors.white,
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear, color: Colors.white),
                                          onPressed: () {
                                            _searchCityController.clear();
                                          },
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xff9400d8), Color(0xff8000bf), Color(0xff6a00a0)]),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.search, color: Colors.white, size: 30),
                                    onPressed: () {
                                      fetchWeather(_searchCityController.text);
                                      // _fetchWeatherData(_searchCityController.text);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          
                          SizedBox(height: 10),
                          
                          // Weather content
                          _tomorrowIo != null ? Column(
                            children: [
                              // Your existing weather content...
                              SingleChildScrollView(
                                child: Stack(
                                  children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Text("${currentWeather?['temperature']?.round()}",
                                              style: GoogleFonts.outfit(
                                                fontSize: 120,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("°",
                                              style: GoogleFonts.saira(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text("${getWeatherIcon(currentWeather?['weatherCode'])}",
                                              style: GoogleFonts.outfit(
                                                fontSize: 70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                              ],
                                            ),
                                          ),
                                        
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              _weatherItem(
                                                title: "Humidity",
                                                value: "${currentWeather!["humidity"]}%",
                                                icon: Icons.water_drop,
                                                color: Colors.blue,
                                              ),
                                              _weatherItem(
                                                title: "Wind Speed",
                                                value: "${currentWeather!["windSpeed"]} km/h",
                                                icon: Icons.air,
                                                color: Colors.green,
                                              ),
                                              _weatherItem(
                                                title: "Rain Intensity",
                                                value: "${currentWeather?["rainIntensity"]} mm/h",
                                                icon: Icons.cloud,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(20),
                                  //     child: BackdropFilter(
                                  //       filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  //       child: Container(
                                  //         width: double.infinity,
                                  //         height: 100,
                                  //         decoration: BoxDecoration(
                                  //           // gradient: LinearGradient(colors: [Color(0xff503cb7).withOpacity(0.3), Color(0xff422ea8).withOpacity(0.3)]),
                                  //           borderRadius: BorderRadius.circular(20),
                                  //         ),
                                  //         child: Column(
                                  //           children: [
                                  //             Text("Future Forecast",
                                  //               style: GoogleFonts.outfit(
                                  //                 fontSize: 20,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                    ],
                                  ),
                                  ],
                                ),
                              ),
                            ],
                          ) : Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,    
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _tomorrowIo != null ? SingleChildScrollView(
                child: Container(
                width: double.infinity,
                height: 290,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffffd333).withOpacity(0.8), Color(0xffffa633).withOpacity(0.8)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                  children: [
                    Text("Future Forecast",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          var weatherData = index == 0 
                              ? _tomorrowIo?.hourlyWeather[0]
                              : index == 1 
                                  ? _tomorrowIo?.hourlyWeather[24]
                                  : _tomorrowIo?.hourlyWeather[48];

                          String day = index == 0 ? "Yesterday" : index == 1 ? "Today" : "Tomorrow";
                          
                          return Container(
                            width: 160,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(day,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  getWeatherIcon(weatherData?['values']['weatherCode'] ?? 0),
                                  style: TextStyle(fontSize: 32),
                                ),
                                Column(
                                  children: [
                                    _buildWeatherMetric(
                                      "Temperature",
                                      "${weatherData?['values']['temperature']?.round()}°",
                                      Colors.orange,
                                      (weatherData?['values']['temperature'] ?? 0) / 50,
                                    ),
                                    _buildWeatherMetric(
                                      "Humidity",
                                      "${weatherData?['values']['humidity']}%",
                                      Colors.blue,
                                      (weatherData?['values']['humidity'] ?? 0) / 100,
                                    ),
                                    _buildWeatherMetric(
                                      "Wind",
                                      "${weatherData?['values']['windSpeed']} km/h",
                                      Colors.green,
                                      (weatherData?['values']['windSpeed'] ?? 0) / 50,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )

                  ]
                )
              )
            ) 
                         
            ) : Center(
              // child: CircularProgressIndicator(
              //   color: Colors.blue,
              // ),
            ),
        
          ],
        ),
      ),
    );
  }

    Widget _buildWeatherMetric(String label, String value, Color color, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(value,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

            // Add this helper method in the class
            // Widget _buildWeatherCard(String day, String date, int temp, int code, Color color) {
            //   return Container(
            //   width: 150,
            //   margin: EdgeInsets.symmetric(horizontal: 8),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [color, color.withOpacity(0.7)],
            //     ),
            //     borderRadius: BorderRadius.circular(20),
            //     boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.2),
            //       blurRadius: 8,
            //       offset: Offset(0, 4),
            //     ),
            //     ],
            //   ),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //     Text(day,
            //       style: GoogleFonts.outfit(
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //       ),
            //     ),
            //     SizedBox(height: 8),
            //     Text(date,
            //       style: GoogleFonts.outfit(
            //       fontSize: 14,
            //       color: Colors.white.withOpacity(0.9),
            //       ),
            //     ),
            //     SizedBox(height: 16),
            //     Text(getWeatherIcon(code),
            //       style: TextStyle(fontSize: 40),
            //     ),
            //     SizedBox(height: 16),
            //     Text("$temp°",
            //       style: GoogleFonts.outfit(
            //       fontSize: 28,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //       ),
            //     ),
            //     ],
            //   ),
            //   );
            // }
//}


 
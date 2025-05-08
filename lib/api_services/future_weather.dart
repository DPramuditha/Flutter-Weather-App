class FutureWeather {
  final String date;
  final double temperature;
  final String time;
  final String icon;
  final String condition;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;
  final double humidity;
  final double wind;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final double airQualityCo;
  final double airQualityNo2;
  final double airQualityO3;
  final double airQualitySo2;
  final double pm2_5;
  final double pm10;
  final int gbDefraIndex;
  final double uv;
  final List<Map<String, dynamic>> hourlyWeather; // ✅ Added to store hourly weather data

  FutureWeather({
    required this.date, 
    required this.temperature, 
    required this.time, 
    required this.icon, 
    required this.condition, 
    required this.dailyChanceOfRain, 
    required this.dailyChanceOfSnow, 
    required this.humidity, 
    required this.wind, 
    required this.sunrise, 
    required this.sunset, 
    required this.moonrise, 
    required this.moonset, 
    required this.airQualityCo, 
    required this.airQualityNo2, 
    required this.airQualityO3, 
    required this.airQualitySo2,
    required this.pm2_5, 
    required this.pm10, 
    required this.gbDefraIndex,
    required this.uv,
    required this.hourlyWeather, 
    });


  // factory FutureWeather.fromJson(Map<String, dynamic> json) {
  //   return FutureWeather(
  //     date: json['forecast']['forecastday'][0]['date'],
  //     temperature: json['forecast']['forecastday']["hour"][0]['temp_c'].toDouble(), 
  //     time: json['date'],
  //     icon: json['forecast']['forecastday'][0]['hour'][0]['condition']['icon'],
  //     condition: json['forecast']['forecastday'][0]['hour'][0]['condition']['text'],
  //     dailyChanceOfRain: json['forecast']['forecastday'][0]['day']['daily_chance_of_rain'],
  //     dailyChanceOfSnow: json['forecast']['forecastday'][0]['day']['daily_chance_of_snow'],
  //     humidity: json['forecast']['forecastday'][0]['day']['avghumidity'].toDouble(),
  //     wind: json['forecast']['forecastday'][0]['day']['maxwind_kph'].toDouble(),
  //     sunrise: json['forecast']['forecastday'][0]['astro']['sunrise'],
  //     sunset: json['forecast']['forecastday'][0]['astro']['sunset'],
  //     moonrise: json['forecast']['forecastday'][0]['astro']['moonrise'],
  //     moonset: json['forecast']['forecastday'][0]['astro']['moonset'],
  //     airQualityCo: json['forecast']['forecastday'][0]['hour'][0]['air_quality']['co'].toDouble(),
  //     airQualityNo2: json['forecast']['forecastday'][0]['hour'][0]['air_quality']['no2'].toDouble(),
  //     airQualityO3: json['forecast']['forecastday'][0]['hour'][0]['air_quality']['o3'].toDouble(),
  //     airQualitySo2: json['forecast']['forecastday'][0]['hour'][0]['air_quality']['so2'].toDouble(),

  //     hourlyWeather: (json['forecast']['forecastday'][0]['hour'] as List) // ✅ Extracting hourly weather
  //         .map((hour) => {
  //               "time": hour['time'],        
  //               "temp": hour['temp_c'],      //
  //               "condition": hour['condition']['text'], 
  //               "icon": hour['condition']['icon'],      
  //             })
  //         .toList(),
    
  //   );

  factory FutureWeather.fromJson(Map<String, dynamic> json) {
  try {
    // First, safely extract the hourly weather data
    List<Map<String, dynamic>> hourlyWeather = [];
    
    if (json['forecast'] != null && 
        json['forecast']['forecastday'] != null && 
        json['forecast']['forecastday'].isNotEmpty &&
        json['forecast']['forecastday'][0]['hour'] != null) {
      
      hourlyWeather = (json['forecast']['forecastday'][0]['hour'] as List)
          .map((hour) => {
                "time": hour['time'] ?? "",
                "temp": hour['temp_c'] ?? 0,
                "condition": hour['condition']['text'] ?? "",
                "icon": hour['condition']['icon'] ?? "",
              })
          .toList();
    }
    
    // Then create the FutureWeather object with null safety
    return FutureWeather(
      date: json['forecast']?['forecastday']?[0]?['date'] ?? "",
      temperature: json['current']?['temp_c']?.toDouble() ?? 0.0,
      time: json['location']?['localtime'] ?? "",
      icon: json['current']?['condition']?['icon'] ?? "",
      condition: json['current']?['condition']?['text'] ?? "",
      dailyChanceOfRain: json['forecast']?['forecastday']?[0]?['day']?['daily_chance_of_rain'] ?? 0,
      dailyChanceOfSnow: json['forecast']?['forecastday']?[0]?['day']?['daily_chance_of_snow'] ?? 0,
      humidity: json['forecast']?['forecastday']?[0]?['day']?['avghumidity']?.toDouble() ?? 0.0,
      wind: json['forecast']?['forecastday']?[0]?['day']?['maxwind_kph']?.toDouble() ?? 0.0,
      sunrise: json['forecast']?['forecastday']?[0]?['astro']?['sunrise'] ?? "",
      sunset: json['forecast']?['forecastday']?[0]?['astro']?['sunset'] ?? "",
      moonrise: json['forecast']?['forecastday']?[0]?['astro']?['moonrise'] ?? "",
      moonset: json['forecast']?['forecastday']?[0]?['astro']?['moonset'] ?? "",
      airQualityCo: json['current']?['air_quality']?['co']?.toDouble() ?? 0.0,
      airQualityNo2: json['current']?['air_quality']?['no2']?.toDouble() ?? 0.0,
      airQualityO3: json['current']?['air_quality']?['o3']?.toDouble() ?? 0.0,
      airQualitySo2: json['current']?['air_quality']?['so2']?.toDouble() ?? 0.0,
      pm2_5: json['current']?['air_quality']?['pm2_5']?? 0,
      pm10: json['current']?['air_quality']?['pm10']?? 0,
      uv: json['current']?['uv']?.toDouble() ?? 0.0,
      gbDefraIndex: json['current']?['air_quality']?['gb-defra-index']?? 0,

      hourlyWeather: hourlyWeather,
    );
  } catch (e) {
    print("❌ Error parsing weather data: $e");
    
    // Return a default object to prevent crashes
    return FutureWeather(
      date: "",
      temperature: 0.0,
      time: "",
      icon: "",
      condition: "Error loading data",
      dailyChanceOfRain: 0,
      dailyChanceOfSnow: 0,
      humidity: 0.0,
      wind: 0.0,
      sunrise: "",
      sunset: "",
      moonrise: "",
      moonset: "",
      airQualityCo: 0.0,
      airQualityNo2: 0.0,
      airQualityO3: 0.0,
      airQualitySo2: 0.0,
      pm2_5: 0,
      pm10: 0,
      gbDefraIndex: 0,
      uv: 0.0,
      hourlyWeather: [],
    );
  }

  }





 


}
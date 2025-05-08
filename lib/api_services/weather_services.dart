class WeatherServices {
  final String cityName;
  final String country;
  final double temperature;
  final String condition;
  final String icon;
  final int code;
  final String feelslike;
  final double wind;
  final double pressure;
  final int humidity;
  final double airQualityCo;
  final double airQualityNo2;
  final double airQualityO3;
  final double airQualitySo2;
  final double airQualityPm2_5;
  final double airQualityPm10;
  final int gbDefraIndex;
  final DateTime localTime;

  WeatherServices({
    required this.cityName, 
    required this.country, 
    required this.temperature, 
    required this.condition, 
    required this.icon, 
    required this.code, 
    required this.feelslike, 
    required this.wind, 
    required this.pressure, 
    required this.humidity, 
    required this.airQualityCo,
    required this.airQualityNo2,
    required this.airQualityO3,
    required this.airQualitySo2,
    required this.airQualityPm2_5,
    required this.airQualityPm10,
    required this.gbDefraIndex,
    required this.localTime,
  });
  
    factory WeatherServices.fromJson(Map<String, dynamic> json) {
      return WeatherServices(
        cityName: json['location']['name'],
        country: json['location']['country'],
        temperature: json['current']['temp_c'].toDouble(),
        condition: json['current']['condition']['text'],
        icon: json['current']['condition']['icon'],
        code: json['current']['condition']['code'],
        feelslike: json['current']['feelslike_c'].toString(),
        wind: json['current']['wind_kph'].toDouble(),
        pressure: json['current']['pressure_mb'].toDouble(),
        humidity: json['current']['humidity'],
        airQualityCo: json['current']['air_quality']['co'].toDouble(),
        airQualityNo2: json['current']['air_quality']['no2'].toDouble(),
        airQualityO3: json['current']['air_quality']['o3'].toDouble(),
        airQualitySo2: json['current']['air_quality']['so2'].toDouble(),
        airQualityPm2_5: json['current']['air_quality']['pm2_5'].toDouble(),
        airQualityPm10: json['current']['air_quality']['pm10'].toDouble(),
        gbDefraIndex: json['current']['air_quality']['gb-defra-index'],
        localTime: DateTime.parse(json['location']['localtime']),
      );
    }
}
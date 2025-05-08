class WeatherTomorrow {
  final String date;
  final double temperature;
  final String time;
  final String icon;
  final String condition;
  final dailyChanceOfRain;
  final int gbDefraIndex;


  WeatherTomorrow({
    required this.date,
    required this.temperature,
    required this.time,
    required this.icon,
    required this.condition,
    required this.dailyChanceOfRain,
    required this.gbDefraIndex,
  });


  factory WeatherTomorrow.fromJson(Map<String, dynamic> json) {
    return WeatherTomorrow(
      date: json['forecast']['forecastday'][1]['date'] ?? "",
      temperature: json['forecast']['forecastday'][1]['day']['avgtemp_c'].toDouble() ?? 0.0,                              
      time: json['forecast']['forecastday'][1]['hour'][0]['time'] ?? "",
      icon: json['forecast']['forecastday'][1]['hour'][0]['condition']['icon'] ?? "",
      condition: json['forecast']['forecastday'][1]['hour'][0]['condition']['text'] ?? "",
      dailyChanceOfRain: json['forecast']['forecastday'][1]['day']['daily_chance_of_rain'] ?? 0,
      gbDefraIndex: json['forecast']['forecastday'][1]['day']['air_quality']['gb-defra-index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'temperature': temperature,
      'time': time,
      'icon': icon,
      'condition': condition,
      'dailyChanceOfRain': dailyChanceOfRain,
      'gbDefraIndex': gbDefraIndex,
    };
  }



}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:westher_app/pages/notification/local_notification.dart';
import 'package:westher_app/pages/search_city.dart';
import 'package:westher_app/pages/start_page.dart';
import 'package:westher_app/pages/weather_main.dart';
import 'package:westher_app/pages/weather_test.dart';


main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  

  await dotenv.load(fileName: ".env");
  

  runApp(WeatherApp());
}
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}


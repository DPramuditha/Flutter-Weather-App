import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> inDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    // Handle the notification response here
    print("Notification tapped: ${notificationResponse.payload}");
  }

  static Future<void> init() async {
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings, 
      onDidReceiveNotificationResponse: inDidReceiveNotificationResponse
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      await androidImplementation?.requestNotificationsPermission();
    }

    // Request exact alarms permission if needed
    await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();
  }

  static Future<void> showNotification({required String title, required String body}) async {
    try {
      // Make sure notifications are initialized first
      await init();
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        "westher_app",
        "westher_app_channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        channelShowBadge: true,
        enableVibration: true,
      );
      
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails
      );
      
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: "Notification Payload",
      );
      
      print("Notification sent successfully");
    } catch (e) {
      print("Error showing notification: $e");
    }
  }
}
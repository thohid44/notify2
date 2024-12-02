import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: DarwinInitializationSettings(
          // requestAlertPermission: false,
          // requestBadgePermission: false,
          // requestSoundPermission: false,
          ),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final String? payload = response.payload;
        if (response.payload != null) {
          print('notification payload: $payload');
          // await Get.to(TripDetailsPage("$payload"));
        }

        // await Navigator.push(
        //   context,
        //   MaterialPageRoute<void>(builder: (context) => TripDetailsPage("$payload")),
        // );
      },
    );
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      print("Notification Details $notificationDetails");
      print("PayLoad ${message.toMap()}");
     if(message.data['lang']=='ar'){
       await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.data['body_ar'],
        notificationDetails,
        payload: message.data['_id'],
      );
     }else {
       await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.data['body_bn'],
        notificationDetails,
        payload: message.data['_id'],
      );
     }
    } on Exception catch (e) {
      print(e);
    }
  }
}

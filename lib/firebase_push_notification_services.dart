import 'dart:async';
import 'package:BuyGoods/local_notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Define a global stream controller
StreamController<String> globalStreamController =
    StreamController<String>.broadcast();

class FirebasePushNotificationServices {
  /// Initialize & handle firebase notification
  handleNotification() async {
    await _notificationInitialize();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    
    FirebaseMessaging.instance.getInitialMessage().then(_getInitialMessage);

    FirebaseMessaging.onMessage.listen(_onMessageListen);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _notificationInitialize() async {
    /// Foreground Notification Options Enabled
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _getInitialMessage(RemoteMessage? message) async {
    print("FirebaseMessaging.instance.getInitialMessage");
    if (message != null) {
      _handleLocalizedMessage(message);
    }
  }

  Future<void> _onMessageListen(RemoteMessage message) async {
    print("FirebaseMessaging.onMessage.listen");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (message.notification != null) {
      _handleLocalizedMessage(message);
      LocalNotificationService.createAndDisplayNotification(message);
    }
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    print("FirebaseMessaging.onMessageOpenedApp.listen");
    if (message.notification != null) {
      _handleLocalizedMessage(message);
    }
  }

  Future<void> _handleLocalizedMessage(RemoteMessage message) async {
 
    String userLang = _getUserLanguage(); 
    String? localizedTitle;
    String? localizedBody;

    // Check for language-specific content in `data`
    Map<String, dynamic> data = message.data;
    if (userLang == "bn") {
      localizedTitle = data['title_bn'];
      localizedBody = data['body_bn'];
    } else if (userLang == "ar") {
      localizedTitle = data['title_ar'];
      localizedBody = data['body_ar'];
    } else {
      localizedTitle = data['title_en'];
      localizedBody = data['body_en'];
    }

    // Log or display the localized content
    print("Localized Title: $localizedTitle");
    print("Localized Body: $localizedBody");

    // Optionally update the notification or UI
    // LocalNotificationService.showNotification(
    //   title: localizedTitle ?? message.notification?.title ?? "Default Title",
    //   body: localizedBody ?? message.notification?.body ?? "Default Body",
    // );
  
  }

  String _getUserLanguage() {
    // Replace this logic with actual user language detection
    // e.g., from device settings or app preferences
    return "en"; // Example: Returning Bangla as the default language
  }
}

import 'package:clipboard/clipboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var fmcToken;
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    setState(() {
      fmcToken = token.toString();
    });
    FlutterClipboard.copy('$fmcToken').then((value) => print('Copied'));
    print("Device Id $fmcToken");
  }

  @override
  void initState() {
    super.initState();
    subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Multiple Notifications"),
          ),
          Text("${fmcToken}", style: TextStyle(fontSize: 19)),
          ElevatedButton(
              onPressed: () {
                getDeviceTokenToSendNotification();
              },
              child: Text("Copy"))
        ],
      ),
    ));
  }
}

void subscribe() {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic('all');
  print("Subscribe to all topic");
}

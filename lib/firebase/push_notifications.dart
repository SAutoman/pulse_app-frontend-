import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static FirebaseMessaging fireMessaging = FirebaseMessaging.instance;
  static StreamController<RemoteMessage> pushStreamController =
      StreamController.broadcast();

  static closeStreams() {
    pushStreamController.close();
  }

  static Future<void> requestPermision() async {
    NotificationSettings settings = await fireMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> initPushNotifications() async {
    //FOREGROUND Notificaitons *********************************
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received');
      if (message.notification != null) {
        print('Foreground message received with notification');
        pushStreamController.add(message);
      }
    });

    //BACKGROUND Notificaitons ********************************
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // APP OPENED FROM TERMINATED STATE : Check if the app was opened from a terminated state by a notification tap
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage.notification != null) {
        print('Notification from terminated state');
        pushStreamController.add(initialMessage);
      }
    }

    // APP IN BACKGROUND BUT NOT TERMINATED: Listen for when a user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        pushStreamController.add(message);
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

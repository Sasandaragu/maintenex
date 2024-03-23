import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'Features/reminders/screens/local_notifications.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {

  //Widget Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  ///GetX Local Storage
  await GetStorage.init();

  ///Await Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  ///Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  LocalNotifications.init();
  
  // for Scheduling the notifications
  tz.initializeTimeZones();

  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  flutterLocalNotificationsPlugin.getActiveNotifications();
  flutterLocalNotificationsPlugin.pendingNotificationRequests();
  LocalNotifications.onClickNotification;

     var initialNotification = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      if (initialNotification?.didNotificationLaunchApp == true) {
        Future.delayed(const Duration(seconds: 1), () {
          String payload = initialNotification?.notificationResponse?.payload ?? '';
          // Check the payload and navigate accordingly
          
          LocalNotifications.handleNotificationTap(payload);
        });
      }

  runApp(const App());
}



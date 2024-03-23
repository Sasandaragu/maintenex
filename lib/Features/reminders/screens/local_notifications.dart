// ignore_for_file: deprecated_member_use
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintenex/Features/mileage/Screens/addMileage.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/features/documents/models/document_model.dart';
import 'package:maintenex/features/documents/screens/uploading_screen.dart';
import 'package:maintenex/features/reminders/models/milestone_model.dart';
import 'package:maintenex/features/reminders/screens/reminders_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  // Unique counter for notification IDs to identify each notification uniquely
  static int _notificationIdCounter = 1;

  static void onNotificationTap(NotificationResponse notificationResponse) {
    String payload = notificationResponse.payload ?? '';
    handleNotificationTap(payload);
  }

  static void handleNotificationTap(String payload) {
    if(payload == 'REMINDERS_PAYLOAD'){
      VehicleRepository.instance.currentVehicle.vehicleNo;
      Get.to(()=>const ReminderScreen());

    }if (payload == 'DOCUMENT_EXPIRY_PAYLOAD'){
      Get.to(()=>const DocumentsPage());

    }if (payload == 'MILEAGE_REMINDER_PAYLOAD'){
      // ignore: non_constant_identifier_names
      Get.to(()=> AddMileageScreen(onMileageAdded: (MileageEntry) {},));
    }
  }

  //Setting up necessary initialization settings for different platforms and configures actions on notification tap.
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) {});


    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

      //Navigating to the specific screens according to the payload of a notification 
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload == 'REMINDERS_PAYLOAD') {
          onClickNotification.add(details.payload!);
        }if (details.payload == 'DOCUMENT_EXPIRY_PAYLOAD') {
          onClickNotification.add(details.payload!);
        }if (details.payload == 'MILEAGE_REMINDER_PAYLOAD') {
          onClickNotification.add(details.payload!);
        }
      },
    );
  }

  // Shows a simple notification for each reminder.
  static Future<void> showSimpleNotifications(List<MileStoneModel> reminders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    int today = now.year * 10000 + now.month * 100 + now.day;

    for (var reminder in reminders) {
      final int notificationId = _getUniqueNotificationId();

      // Check if notification for this reminder has been sent today
      String key = 'lastNotificationDate_${reminder.maintenanceId}';
      int lastNotificationDate = prefs.getInt(key) ?? 0;

      //Limiting the notification to be sent once per day
      if (lastNotificationDate != today) {
        await _flutterLocalNotificationsPlugin.show(
          notificationId,
          "Reminder: ${reminder.title}",
          "It's time to visit your vehicle's service provider.",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'Maintenance channel', // Channel ID
              'Maintenance Reminders', // Channel name
              channelDescription: 'Notifications for upcoming maintenance activities', // Channel description
              importance: Importance.max,
              priority: Priority.high,
              largeIcon: DrawableResourceAndroidBitmap('repair'),
            ),
          ),
          payload: 'REMINDERS_PAYLOAD',
        );

        // Update the last notification date for this reminder
        await prefs.setInt(key, today);
      }
    }
  }


  // Schedules a notification for the expiry of a vehicle document.
  static Future<void> scheduleDocumentExpiryNotification(VehicleDocument document) async {
    final dateFormat = DateFormat('yyyy-MM-dd'); 
    DateTime expiryDate = dateFormat.parse(document.expiryDate);
    DateTime notificationDate = expiryDate.subtract(const Duration(days: 10));

    // Convert notificationDate to local timezone
    final tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime.from(notificationDate, tz.local);

    final int notificationId =document.hashCode; // Use a unique ID for each notification
    const String title = "Document Expiry Reminder";
    String body = "Your ${document.documentType} is expiring on ${document.expiryDate}.";

    // Check if a notification with the same ID is already scheduled
    final List<PendingNotificationRequest> pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    bool notificationExists = pendingNotifications.any((notification) => notification.id == notificationId);

    if (!notificationExists) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledNotificationDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'document_expiry_channel', 
            'Document Expiry Reminders', 
            channelDescription: 'Notifications for document expiries', 
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('documents'),
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'DOCUMENT_EXPIRY_PAYLOAD',
      );
    }
  }


  static Future<void> scheduleMileageReminder() async {
  int notificationId = 0;
  String title = "Update Mileage";
  String body = "Don't forget to enter the latest mileage of your vehicle.";
  String payload = 'MILEAGE_REMINDER_PAYLOAD';

  // Set the interval to 2 weeks
  const int interval = 2 * 7 * 24 * 60 * 60; // 2 weeks in seconds

  final tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: interval));

  await _flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    title,
    body,
    scheduledNotificationDateTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'mileage_update_channel', // Channel ID
        'Mileage Reminder', // Channel name
        channelDescription: 'Notification for mileage update', // Channel description
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('mileage'),
      ),
    ),
    payload: payload,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // Match the day of week and time
  );
}

  

  //Generates unique notification IDs to avoid conflicts.
  static int _getUniqueNotificationId() => ++_notificationIdCounter;

  // Method to cancel all scheduled notifications.
  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> checkScheduledNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Get the list of pending notification requests
  List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  // Check if the document expiry notification is scheduled
  bool isDocumentExpiryScheduled = pendingNotifications.any((notification) =>
      notification.payload == 'DOCUMENT_EXPIRY_PAYLOAD');

  print('Is document expiry notification scheduled: $isDocumentExpiryScheduled');
}
}

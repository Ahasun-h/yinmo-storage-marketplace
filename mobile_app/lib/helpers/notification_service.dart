import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:urban_koala/networks/api_access.dart';
import 'dart:convert';
import 'package:urban_koala/helpers/all_routes.dart';
import 'package:urban_koala/helpers/navigation_service.dart';
import '../constants/app_constants.dart';
import 'di.dart';

class NotificationService {
  NotificationService._();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription<String>? _tokenRefreshSubscription;

  static Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User granted provisional permission");
    } else {
      log("User denied permission");
    }
    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification clicked: ${response.payload}");
        if (response.payload != null) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload!);
            handleNavigation(data);
          } catch (e) {
            log("Error parsing notification payload: $e");
          }
        }
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("Initial message: ${message.data}");
        handleNavigation(message.data);
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getNotificationRxOBJ.get();
      notificationRxObj.setNotification(true);
      if (message.notification != null && !Platform.isIOS) {
        showNotification(
          title: message.notification!.title ?? 'No Title',
          body: message.notification!.body ?? 'No Body',
          payload: jsonEncode(message.data),
        );
      }
    });

    // Handle messages when the app is opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationRxObj.clearNotification();
      log("Message opened: ${message.data}");
      handleNavigation(message.data);
    });

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((token) {
      log("Firebase Messaging Token refreshed: $token");
      appData.write(kKeyFCMToken, token);
    });

    await getToken();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel', // Channel ID
      'Main Channel', // Channel name
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  static Future<void> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _waitForApnsToken();
        if (apnsToken == null) {
          log(
            "APNS token is not available yet. Skipping immediate FCM fetch and waiting for refresh.",
          );
          return;
        }
        log("APNS Token: $apnsToken");
      }
      String? token = await _messaging.getToken();
      log("Firebase Messaging Token: $token");
      if (token != null && token.isNotEmpty) {
        appData.write(kKeyFCMToken, token);
      }
      // Save token to your backend for sending notifications
    } catch (e) {
      log("Error fetching token: $e");
    }
  }

  static Future<String?> _waitForApnsToken() async {
    for (int attempt = 0; attempt < 10; attempt++) {
      try {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          return apnsToken;
        }
      } catch (_) {
        // iOS may not have delivered the APNS token immediately after permission.
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    return null;
  }

  static void handleNavigation(Map<String, dynamic> data) {
    if (data.containsKey('type')) {
      if (data['type'] == 'message') {
        _navigateToMessage(data);
      } else if (data['type'] == 'booking') {
        _navigateToBooking(data);
      }
    } else {
      // Infer type from keys
      if (data.containsKey('conversation_id') ||
          data.containsKey('sender_id') ||
          data.containsKey('receiver_id')) {
        _navigateToMessage(data);
      } else {
        // Default to booking for empty payloads or explicit booking keys
        _navigateToBooking(data);
      }
    }
  }

  static void _navigateToMessage(Map<String, dynamic> data) {
    NavigationService.navigateToWithArgs(
      Routes.messaging,
      {
        "conversationId": data['conversation_id'],
        "receiverName": data['receiver_name'] ?? "User",
        "reciverImg": data['receiver_image'] ?? "",
        "receiverId": data['receiver_id'] ?? data['sender_id'],
      },
    );
  }

  static void _navigateToBooking(Map<String, dynamic> data) {
    String? userType = appData.read(kKeyUserType);
    if (userType == "service_provider") {
      NavigationService.navigateTo(Routes.hostBooking);
    } else {
      // Navigate to My Bookings tab (index 1) which is pageNum
      NavigationService.navigateToWithObject(Routes.navigation, 1);
    }
  }
}

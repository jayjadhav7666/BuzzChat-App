import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:buzzchat/config/cutomMessage.dart';
import 'package:buzzchat/model/userModel.dart';
import 'package:buzzchat/pages/chat/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //for notification request
  void requestNotificationServices() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      successMessage('User Granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      successMessage('User Granted Provisional Permission');
    } else {
      AppSettings.openAppSettings();
      errorMessage('User Denied Permission');
    }
  }

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/logo',
    );

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: DarwinInitializationSettings(),
    ); // combine setting for different devices
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(message);
      },
    ); //initilize local notifications and handle tap event when click on it
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
   
      if (kDebugMode) {
        log(notification!.title.toString());
        log(notification.body.toString());
        log(message.data.toString());
      }
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    String? imageUrl = message.data['image'];
    String? senderName = message.data['senderName'];
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );
    AndroidNotificationDetails androidNotificationDetails;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final imagePath = await _downloadAndSaveImage(
        imageUrl,
        'notification_img.jpg',
      );
      //android setting
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        playSound: true,
        importance: Importance.high,
        priority: Priority.high,
        sound: channel.sound,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          largeIcon: FilePathAndroidBitmap(imagePath),
          contentTitle: senderName,
        ),
      );
    } else {
      androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toUpperCase(),
        playSound: true,
        importance: Importance.high,
        priority: Priority.high,
        sound: channel.sound,
      );
    }
    //merge notifications
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    //show notification
    Future.delayed((Duration.zero), () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  //for handle notification
  void handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      String senderId = message.data['senderId'] ?? '';

      // Fetch user model from Firestore (you must write this function)
      UserModel sender = await getUserById(senderId);

      // Navigate to ChatPage with GetX
      Get.offAll(() => ChatPage(userModel: sender));
    }
  }

  Future<UserModel> getUserById(String uid) async {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserModel.fromJson(doc.data()!);
  }

  //for background or terminate state
  Future<void> setUpInteractionMessage(BuildContext context) async {
    //background State
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
    // terminated state
    await FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(message);
      }
    });
  }

  //for get token
  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    log('$token');
    return token;
  }
}

Future<String> _downloadAndSaveImage(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await http.get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

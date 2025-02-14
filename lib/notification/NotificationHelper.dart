import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hoonar/screens/notification/notification_list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants/global_key.dart';
import '../main.dart';

class NotificationHelper {
  static BuildContext? _context;

  static void setContext(BuildContext context) =>
      NotificationHelper._context = context;

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@drawable/notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          handleNotificationClick(response.payload!);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message, flutterLocalNotificationsPlugin, true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String? title;
      String? body;
      String? image;
      int? msgFlag;
      print("onOpenApp: App opened");
      try {
        Map<String, dynamic> demo = message.toMap();
        if (demo['data'] != null) {
          /* String str = json.encode(demo['data']['data']);
          print(str);
          String data = str.replaceFirst("\"", "", 0);
          String data1 = data.replaceFirst("\"", "", data.length - 1);

          final body = json.decode(data1.replaceAll(r'\', ''));*/

          handleNotificationClick(message.data.toString());
        }
      } catch (e) {}
    });
  }

  static void handleNotificationClick(String payload) {
    try {
      // Map<String, dynamic> data = jsonDecode(payload);
      GlobalVariable.navKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const NotificationListScreen(),
        ),
      );
    } catch (e) {
      print("Error handling notification click: $e");
    }
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    String? title;
    String? body;
    String? image;
    if (data) {
      Map<String, dynamic> demo = message.toMap();
      if (demo['data'] != null) {
        Map<String, dynamic> data = demo['data'];
        print(data);

        title = data['title'];
        body = data['body'];
        image = data['image'];
      } else {
        title = message.from;
        body = message.messageId;
        // orderID = message.notification!.titleLocKey;
        if (Platform.isAndroid) {
          image = (message.notification!.android!.imageUrl != null &&
                  message.notification!.android!.imageUrl!.isNotEmpty)
              ? message.notification!.android!.imageUrl!.startsWith('http')
                  ? message.notification!.android!.imageUrl
                  : message.notification!.android!.imageUrl
              : null;
        } else if (Platform.isIOS) {
          image = (message.notification!.apple!.imageUrl != null &&
                  message.notification!.apple!.imageUrl!.isNotEmpty)
              ? message.notification!.apple!.imageUrl!.startsWith('http')
                  ? message.notification!.apple!.imageUrl
                  : message.notification!.apple!.imageUrl
              : null;
        }
      }
      if (image != null && image.isNotEmpty) {
        try {
          await showBigPictureNotificationHiddenLargeIcon(
              title!, body!, image, fln);
        } catch (e) {
          await showBigTextNotification(title!, body!, fln);
        }
      } else {
        await showBigTextNotification(title!, body!, fln);
      }
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  String? title;
  String? body0;
  String? image;
  Map<String, dynamic> demo = message.toMap();
  if (demo['data'] != null) {
    String str = json.encode(demo['data']['data']);
    print(str);
    String data = str.replaceFirst("\"", "", 0);
    String data1 = data.replaceFirst("\"", "", data.length - 1);

    final body = json.decode(data1.replaceAll(r'\', ''));
    // MainNotificationModel mainNotificationModel =
    //     MainNotificationModel.fromJson(body);
    // _title = mainNotificationModel.title;
    // _body = mainNotificationModel.message;
    // _image = mainNotificationModel.image;
  } else {
    title = message.from;
    body0 = message.messageId;
    // orderID = message.notification!.titleLocKey;
    if (Platform.isAndroid) {
      image = (message.notification!.android!.imageUrl != null &&
              message.notification!.android!.imageUrl!.isNotEmpty)
          ? message.notification!.android!.imageUrl!.startsWith('http')
              ? message.notification!.android!.imageUrl
              : message.notification!.android!.imageUrl
          : null;
    } else if (Platform.isIOS) {
      image = (message.notification!.apple!.imageUrl != null &&
              message.notification!.apple!.imageUrl!.isNotEmpty)
          ? message.notification!.apple!.imageUrl!.startsWith('http')
              ? message.notification!.apple!.imageUrl
              : message.notification!.apple!.imageUrl
          : null;
    }
  }
  if (image != null && image.isNotEmpty) {
    try {
      await showBigPictureNotificationHiddenLargeIcon(
          title!, body0!, image, flutterLocalNotificationsPlugin!);
    } catch (e) {
      await showBigTextNotification(
          title!, body0!, flutterLocalNotificationsPlugin!);
    }
  } else {
    await showBigTextNotification(
        title!, body0!, flutterLocalNotificationsPlugin!);
  }
}

Future<void> showBigPictureNotificationHiddenLargeIcon(String title,
    String body, String image, FlutterLocalNotificationsPlugin fln) async {
  final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
  final String bigPicturePath =
      await _downloadAndSaveFile(image, 'bigPicture');
  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
    FilePathAndroidBitmap(bigPicturePath),
    hideExpandedLargeIcon: true,
    contentTitle: title,
    htmlFormatContentTitle: true,
    summaryText: body,
    htmlFormatSummaryText: true,
  );
  late DarwinNotificationDetails iOSPlatformChannelSpecifics;
  late AndroidNotificationDetails androidPlatformChannelSpecifics;

  if (Platform.isAndroid) {
    androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Hoonar',
      'Hoonar',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.max,
      icon: "@drawable/notification_icon",
      // playSound: true,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      // sound: const RawResourceAndroidNotificationSound('notification'),
    );
  } else {
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'largeIcon');
    iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        attachments: <DarwinNotificationAttachment>[
          DarwinNotificationAttachment(bigPicturePath)
        ],
        presentSound: true);
    // iOSPlatformChannelSpecifics2 =
    //     DarwinNotificationDetails(presentSound: true);
  }

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      // android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await fln.show(0, title, body, platformChannelSpecifics, payload: title);
}

Future<void> showTextNotification(
    String title, String body, FlutterLocalNotificationsPlugin fln) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Hoonar',
    'Hoonar',
    // playSound: true,
    importance: Importance.max,
    icon: "@drawable/notification_icon",
    priority: Priority.max,
    // sound: RawResourceAndroidNotificationSound('notification'),
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await fln.show(0, title, body, platformChannelSpecifics, payload: title);
}

Future<void> showBigTextNotification(
    String title, String body, FlutterLocalNotificationsPlugin fln) async {
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    body,
    htmlFormatBigText: true,
    contentTitle: title,
    htmlFormatContentTitle: true,
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Hoonar',
    'Hoonar',
    importance: Importance.max,
    styleInformation: bigTextStyleInformation,
    priority: Priority.max,
    icon: "@drawable/notification_icon",
    // playSound: true,
    // sound: const RawResourceAndroidNotificationSound('notification'),
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await fln.show(0, title, body, platformChannelSpecifics, payload: title);
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

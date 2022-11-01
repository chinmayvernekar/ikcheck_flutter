import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/Utils/styles.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:provider/provider.dart';

import '../Utils/globalVariables.dart';

final _firebaseMessaging = FirebaseMessaging.instance;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> onBackgroundMessageFromNotification(RemoteMessage message) async {
  // Map data1 = {'type': ''};
  // if (message.data['notificationType'] == 'MESSAGE') {
  //   // Provider.of<MainProvider>(globelContext!, listen: false)
  //   //     .setMessageBool(true);
  //   // data1['type'] = 'MESSAGE';
  //   // routingFunctionForNotificationAndDeeplink(data1);
  // } else if (message.data['notificationType'] == 'ALERT') {
  //   // data1['type'] = 'ALERT';
  //   // routingFunctionForNotificationAndDeeplink(data1);
  //   // await ApiCallManagement().getDashboardDetails(globelContext!);
  // }
  // await storeString(
  //     'BACKGROUNDNOTIFICATIONTYPE', message.data['notificationType']);
  // print(
  //     'BACKGROUNDNOTIFICATIONTYPE ${await getString('BACKGROUNDNOTIFICATIONTYPE')}');
  // if (message.data['notificationType'] == 'MESSAGE') {
  //   Map data = Provider.of<MainProvider>(globelContext!, listen: false)
  //       .dashboardDetails;
  //   if (data['unReadNewsCount'] == null) {
  //     data['unReadNewsCount'] = 1;
  //   } else {
  //     data['unReadNewsCount'] = data['unReadNewsCount'] + 1;
  //   }
  //   Provider.of<MainProvider>(globelContext!, listen: false)
  //       .setDashboardDetails(data);
  // } else if (message.data['notificationType'] == 'ALERT') {
  // try {
  //   backgroundVariableCheck = message.data['notificationType'];
  // } catch (e) {
  //   storeString('BACKGROUNDNOTIFICATIONTYPE', message.data['notificationType']);
  //   print('err $e ${message.data}');
  // }
  // }
}

commonFloatingMsg(message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: AppColors.primary,
            playSound: true,
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
          ),
        ));
  }
}

class FCM {
  Future<String> getTokenValue() async {
    String token = await _firebaseMessaging.getToken() ?? '';
    return token;
  }

  setNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // openRidePopup(message);
      await commonFloatingMsg(message);
      Map data1 = {'type': ''};
      if (message.data['notificationType'] == 'MESSAGE') {
        Map data = Provider.of<MainProvider>(globelContext!, listen: false)
            .dashboardDetails;
        if (data['unReadNewsCount'] == null) {
          data['unReadNewsCount'] = 1;
        } else {
          data['unReadNewsCount'] = data['unReadNewsCount'] + 1;
        }
        Provider.of<MainProvider>(globelContext!, listen: false)
            .setDashboardDetails(data);
      } else if (message.data['notificationType'] == 'ALERT') {
        Map data = Provider.of<MainProvider>(globelContext!, listen: false)
            .dashboardDetails;
        if (data['unreadAlert'] == null) {
          data['unreadAlert'] = 1;
        } else {
          data['unreadAlert'] = data['unreadAlert'] + 1;
        }
        Provider.of<MainProvider>(globelContext!, listen: false)
            .setDashboardDetails(data);
      }
      Timer(const Duration(seconds: 3), () async {
        await flutterLocalNotificationsPlugin.cancelAll();
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await flutterLocalNotificationsPlugin.cancelAll();
      Map data1 = {'type': ''};
      if (message.data['notificationType'] == 'MESSAGE') {
        Provider.of<MainProvider>(globelContext!, listen: false)
            .setMessageBool(true);
        data1['type'] = 'MESSAGE';
        Map data = Provider.of<MainProvider>(globelContext!, listen: false)
            .dashboardDetails;
        if (data['unReadNewsCount'] == null) {
          data['unReadNewsCount'] = 1;
        } else {
          data['unReadNewsCount'] = data['unReadNewsCount'] + 1;
        }
        Provider.of<MainProvider>(globelContext!, listen: false)
            .setDashboardDetails(data);
        await routingFunctionForNotificationAndDeeplink(data1, globelContext!);
      } else if (message.data['notificationType'] == 'ALERT') {
        Map data = Provider.of<MainProvider>(globelContext!, listen: false)
            .dashboardDetails;
        if (data['unreadAlert'] == null) {
          data['unreadAlert'] = 1;
        } else {
          data['unreadAlert'] = data['unreadAlert'] + 1;
        }
        Provider.of<MainProvider>(globelContext!, listen: false)
            .setDashboardDetails(data);
        await routingFunctionForNotificationAndDeeplink(data, globelContext!);
        // await ApiCallManagement().getDashboardDetails(globelContext!);
      }
    });
    // With this token you can test it easily on your phone
    final token = _firebaseMessaging.getToken().then((value) async {
      print('Token: $value');
      ApiCallManagement().postFirebaseToken(value, 'T.D.LOGIN', globelContext!);
    });
  }
}

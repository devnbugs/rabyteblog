import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import '../constants/constant.dart';

class NotificationService {
  Future deleteNotificationData(key) async {
    final list = Hive.box(Constants.notificationTag);
    await list.delete(key);
  }

  Future deleteAllNotificationData() async {
    final list = Hive.box(Constants.notificationTag);
    await list.clear();
  }

  bool checkingPermisson() {
    debugPrint('Notifications: ${OneSignal.Notifications.permission}');
    return OneSignal.Notifications.permission;
  }

  Future subscribe() async {
    await OneSignal.User.pushSubscription.optIn();
  }

  Future unsubscribe() async {
    await OneSignal.User.pushSubscription.optOut();
  }

  // OneSignal
  Future initOneSignal(BuildContext context) async {
    OneSignal.initialize(Config.onesignalAppID);
  
    _requestPermission();
    
    OneSignal.Notifications.addClickListener((event) {
      _handleOnClickNotification(context, event);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      _saveNotificationData(event.notification);
      debugPrint('saved by forground');
    });

    // final OSNotificationPermission iOSPermission = await OneSignal.Notifications.permissionNative();
    // debugPrint('ios: ${iOSPermission.name}');
  }

  _handleOnClickNotification(context, OSNotificationClickEvent event) async {
    final bool saved = await _isNotifcationSaved(event.notification.notificationId);
    if (!saved) {
      await _saveNotificationData(event.notification);
    }
    _navigateToDetailsScreen(context, event.notification);
    debugPrint('saved by onClick');
  }

  Future _saveNotificationData(OSNotification message) async {
    final list = Hive.box(Constants.notificationTag);
    final notificationData = NotificationModel.fromOSNotifcation(message);
    final data = NotificationModel.getMap(notificationData);
    await list.put(notificationData.id, data);
  }

  Future _navigateToDetailsScreen(context, OSNotification message) async {
    final notificationModel = NotificationModel.fromOSNotifcation(message);
    navigateToNotificationDetailsScreen(context, notificationModel);
  }

  Future<bool> _isNotifcationSaved(String notificationId) async {
    final list = Hive.box(Constants.notificationTag);
    final bool value = list.containsKey(notificationId) ? true : false;
    debugPrint('is Saved: $value');
    return value;
  }

  _requestPermission() async {
    if (await OneSignal.Notifications.canRequest()) {
      OneSignal.Notifications.requestPermission(true);
    }
  }
}

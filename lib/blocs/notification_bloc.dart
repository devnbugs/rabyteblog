import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../services/notification_service.dart';
import '../services/sp_service.dart';
import '../utils/notification_permission_dialog.dart';

class NotificationBloc extends ChangeNotifier {
  bool _subscribed = false;
  bool get subscribed => _subscribed;

  Future checkPermission() async {
    await SPService().getNotificationSubscription().then((bool value) async {
      if (value) {
        _subscribed = true;
      } else {
        _subscribed = false;
      }
    });
    notifyListeners();
  }

  

  handleSubscription(context, bool newValue) async {
    if (newValue) {
      final bool hasPermisson = NotificationService().checkingPermisson();
      if (hasPermisson) {
        await NotificationService().subscribe();
        await SPService().setNotificationSubscription(newValue);
        _subscribed = true;
        OneSignal.Notifications.requestPermission(true);
      } else {
        openNotificationPermissionDialog(context);
      }
    } else {
      await NotificationService().unsubscribe();
      await SPService().setNotificationSubscription(newValue);
      OneSignal.Notifications.requestPermission(false);
      _subscribed = false;
    }
    notifyListeners();
  }
}

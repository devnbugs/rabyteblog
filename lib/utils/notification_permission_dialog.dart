import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';


openNotificationPermissionDialog (BuildContext context){
  showDialog(context: context, builder: (context)=> AlertDialog(
    surfaceTintColor: Theme.of(context).colorScheme.onSurface,
    title: const Text('Allow Notifications from Settings'),
    content: const Text('You need to allow notifications from your settings first to enable this'),
    actions: [
      TextButton(
        child: const Text('Close'),
        onPressed: ()=> Navigator.pop(context),
      ),
      TextButton(
        child: const Text('Open Settings'),
        onPressed: (){
          Navigator.pop(context);
          AppSettings.openAppSettings(type: AppSettingsType.notification);
        },
      ),
    ],
  ));
}
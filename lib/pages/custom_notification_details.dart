import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/widgets/html_body/html_body.dart';

class CustomNotificationDeatils extends StatelessWidget {
  const CustomNotificationDeatils({super.key, required this.notificationModel})
     ;

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notification-details').tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  AntDesign.clockcircleo,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppService.getTime(notificationModel.date!, context),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppService.getNormalText(notificationModel.title!),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                wordSpacing: 1,
                letterSpacing: -0.5
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 2,
              height: 30,
            ),
            HtmlBody(
                content: notificationModel.body!,
                isVideoEnabled: true,
                isimageEnabled: true,
                isIframeVideoEnabled: true),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class CustomNotificationCard extends StatelessWidget {
  const CustomNotificationCard({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    AppService.getNormalText(notificationModel.title!),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                  )),
                  IconButton(
                      constraints: const BoxConstraints(minHeight: 40),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      onPressed: () =>
                          NotificationService().deleteNotificationData(notificationModel.id))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                AppService.getNormalText(notificationModel.body!),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.time,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppService.getTime(notificationModel.date!, context),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          navigateToNotificationDetailsScreen(context, notificationModel);
        });
  }
}

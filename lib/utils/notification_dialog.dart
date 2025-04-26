import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/utils/next_screen.dart';

void openNotificationDialog(context, NotificationModel notificationModel) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: false,
            contentPadding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            surfaceTintColor: Theme.of(context).colorScheme.onSurface,
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.notifications_none, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        'New Notification Alert!',
                        style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                        notificationModel.title!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                      HtmlUnescape().convert(
                          parse(notificationModel.body).documentElement!.text),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary
                      )
                    ),
                ],
              ),
            

            actions: [
              TextButton(
                child: const Text('Open'),
                onPressed: (){
                  Navigator.pop(context);
                  navigateToNotificationDetailsScreen(context, notificationModel);
                },
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
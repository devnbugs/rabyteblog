import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class PostNotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;
  const PostNotificationCard({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    notificationModel.thumbnailUrl == null || notificationModel.thumbnailUrl == ''
                        ? Container()
                        : SizedBox(height: 90, width: 90, child: CustomCacheImage(imageUrl: notificationModel.thumbnailUrl, radius: 5)),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppService.getNormalText(notificationModel.body.toString()),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            const Icon(
                              CupertinoIcons.time,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              AppService.getTime(notificationModel.date!, context),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
                            ),
                            const Spacer(),
                            IconButton(
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => NotificationService().deleteNotificationData(notificationModel.id)),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        onTap: () => navigateToNotificationDetailsScreen(context, notificationModel));
  }
}

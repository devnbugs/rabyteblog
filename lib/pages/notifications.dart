import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordpress_app/cards/custom_notification_card.dart';
import 'package:wordpress_app/cards/post_notification_card.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/constant.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationList = Hive.box(Constants.notificationTag);

    void openClearAllDialog() {
      showModalBottomSheet(
          elevation: 2,
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: false,
          backgroundColor: Theme.of(context).canvasColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'clear-notification-dialog',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.6, wordSpacing: 1),
                  ).tr(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(100, 50),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          NotificationService().deleteAllNotificationData();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('notifications').tr(),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => openClearAllDialog(),
            style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 15, left: 15)),
            child: const Text('clear-all').tr(),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: notificationList.listenable(),
              builder: (BuildContext context, dynamic value, Widget? child) {
                List items = notificationList.values.toList();
                items.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                if (items.isEmpty) {
                  return EmptyPageWithImage(
                    image: Config.notificationImage,
                    title: 'no-notification-title'.tr(),
                    description: 'no-notification-description'.tr(),
                  );
                }
                return _NotificationList(items: items);
              }),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.items,
  });

  final List items;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 15,
        ),
        itemBuilder: (BuildContext context, int index) {
          final NotificationModel notificationModel = NotificationModel.fromHive(items[index]);
          if (notificationModel.postID == null) {
            return CustomNotificationCard(
              notificationModel: notificationModel,
            );
          } else {
            return PostNotificationCard(notificationModel: notificationModel);
          }
        },
      ),
    );
  }
}

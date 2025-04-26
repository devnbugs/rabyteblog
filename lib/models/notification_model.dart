import 'package:easy_localization/easy_localization.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationModel {
  final String id;
  final String? timestamp;
  final DateTime? date;
  final String? title;
  final String? body;
  final int? postID;
  final String? thumbnailUrl;

  NotificationModel({
    required this.id,
    this.timestamp,
    this.date,
    this.title,
    this.body,
    this.postID,
    this.thumbnailUrl,
  });

  factory NotificationModel.fromOSNotifcation(OSNotification data) {
    final String id = data.notificationId;
    final int? postID = data.additionalData?['post_id'];
    final DateTime now = DateTime.now();
    final String timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    // final String? imageUrl = Platform.isIOS
    //     ? data.attachments != null
    //         ? data.attachments!['id']
    //         : null
    //     : data.bigPicture;

    final String? thumbnail = data.additionalData?['thumbnail'];

    
    return NotificationModel(
      id: id,
      timestamp: timestamp,
      title: data.title,
      body: data.body,
      postID: postID,
      date: now,
      thumbnailUrl: thumbnail,
    );
  }

  factory NotificationModel.fromHive(dynamic d) {
    return NotificationModel(
      id: d['id'],
      timestamp: d['timestamp'],
      title: d['title'],
      body: d['body'],
      postID: d['post_id'],
      date: d['date'],
      thumbnailUrl: d['image'],
    );
  }

  static Map<String, dynamic> getMap(NotificationModel d) {
    return {
      'id': d.id,
      'timestamp': d.timestamp,
      'date': d.date,
      'title': d.title,
      'body': d.body,
      'post_id': d.postID,
      'image': d.thumbnailUrl,
    };
  }
}

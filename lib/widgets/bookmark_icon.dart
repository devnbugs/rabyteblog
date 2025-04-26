import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordpress_app/services/bookmark_service.dart';

class BookmarkIcon extends StatelessWidget {
  const BookmarkIcon({
    super.key,
    required this.bookmarkedList,
    required this.article,
    required this.iconSize,
    this.iconColor, 
    this.normalIconColor
  });

  final Box bookmarkedList;
  final Article? article;
  final double iconSize;
  final Color? iconColor;
  final Color? normalIconColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bookmarkedList.listenable(),
      builder: (context, dynamic value, Widget? child) {
        return IconButton(
          iconSize: iconSize,
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          alignment: Alignment.centerRight,
            icon: bookmarkedList.keys.contains(article!.id)
                ? Icon(Icons.favorite, color: iconColor ?? Colors.pinkAccent)
                : Icon(Icons.favorite_border, color: normalIconColor ?? Colors.grey),
            onPressed: () {
              BookmarkService().handleBookmarkIconPressed(article!, context);
            });
      },
    );
  }
}
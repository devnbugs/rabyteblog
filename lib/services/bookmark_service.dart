import 'package:hive/hive.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/constant.dart';

class BookmarkService {
  final bookmarkedList = Hive.box(Constants.bookmarkTag);

  Future handleBookmarkIconPressed(Article article, context) async {
    if (bookmarkedList.keys.contains(article.id)) {
      removeFromBookmarkList(article);
    } else {
      addToBookmarkList(article, context);
      openSnacbar(context, 'added-bookmark'.tr());
    }
  }

  Future addToBookmarkList(Article article, context) async {
    final json = article.toJson();
    await bookmarkedList.put(article.id, json);
  }

  Future removeFromBookmarkList(Article article) async {
    await bookmarkedList.delete(article.id);
  }

  Future clearBookmarkList() async {
    await bookmarkedList.clear();
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordpress_app/cards/bookmark_card.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/bookmark_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../constants/constant.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({super.key});

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> with AutomaticKeepAliveClientMixin {
  void _openCLearAllDialog() {
    showModalBottomSheet(
        elevation: 2,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Theme.of(context).canvasColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            height: 210,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'clear-bookmark-dialog',
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        BookmarkService().clearBookmarkList();
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
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookmarkList = Hive.box(Constants.bookmarkTag);
    return Scaffold(
      appBar: AppBar(
        title: const Text('bookmarks').tr(),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => _openCLearAllDialog(),
            style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 15, left: 15)),
            child: const Text('clear-all').tr(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: bookmarkList.listenable(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  if (bookmarkList.isEmpty) {
                    return EmptyPageWithImage(
                      image: Config.bookmarkImage,
                      title: 'bookmark-empty'.tr(),
                      description: 'save-contents-here'.tr(),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: bookmarkList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final keys = bookmarkList.keys;
                      final jsonList = keys.map((e) => bookmarkList.get(e)).toList();
                      final List<Article> articles = jsonList.map((e) => Article.fromJsonLocal(e)).toList();
                      final Article article = articles[index];
                      return BookmarkCard(article: article);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

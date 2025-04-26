import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordpress_app/pages/future_article_details.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class AppLinksService {
  Future<void> initUniLinks(context) async {
    try {
      final initialLink = await AppLinks().getInitialLinkString();
      handleLinks(context, initialLink);
    } on PlatformException {
      debugPrint('platform error');
    }
  }

  handleLinks(context, String? initialLink) async {
    if (initialLink != null) {
      debugPrint('has link: $initialLink');
      final url = Uri.parse(initialLink);
      String slug = url.path;
      Future.delayed(const Duration(milliseconds: 100)).then(
        (value) => nextScreen(
          context,
          FutureArticleDetails(
            postID: null,
            fromNotification: false,
            slug: slug,
          ),
        ),
      );
    } else {
      debugPrint('no links found');
    }
  }
}

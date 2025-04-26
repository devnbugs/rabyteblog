import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/pages/article_details/article_details_layout_1.dart';
import 'package:wordpress_app/pages/article_details/video_article_details.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';

class FutureArticleDetails extends StatefulWidget {
  final int? postID;
  final String? slug;
  final bool fromNotification;
  const FutureArticleDetails({super.key, required this.postID, this.slug, required this.fromNotification});

  @override
  State<FutureArticleDetails> createState() => _FutureArticleDetailsState();
}

class _FutureArticleDetailsState extends State<FutureArticleDetails> {
  late Future _fetchData;

  @override
  void initState() {
    _fetchData = widget.fromNotification ? WordPressService().fetchPostsById(widget.postID!) : WordPressService().getPostBySlug(widget.slug!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchData,
      builder: (context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.active || snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: LoadingIndicatorWidget()),
          );
        } else if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Something is wrong. Please try again!'),
            ),
          );
        } else {
          Article article = snap.data;
          if (AppService.isVideoPost(article)) {
            return VideoArticleDeatils(article: article);
          } else {
            return ArticleDetailsLayout1(article: article);
          }
        }
      },
    );
  }
}

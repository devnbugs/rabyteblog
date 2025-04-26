import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/cards/card5.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';

class RelatedArticles extends StatefulWidget {
  final int? postId;
  final int? catId;

  const RelatedArticles(
      {super.key,
      required this.postId,
      required this.catId,})
     ;

  @override
  State<RelatedArticles> createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {
  Future? data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = WordPressService().fetchPostsByCategoryIdExceptPostId(widget.postId, widget.catId, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  verticalLine(context, 22),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'contents-you-might-love',
                    style: TextStyle(
                      letterSpacing: -0.7,
                      wordSpacing: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ).tr(),
                ],
              ),
            ),
          
        const SizedBox(
          height: 15,
        ),
        FutureBuilder(
          future: data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const _LoadingWidget();
              case ConnectionState.done:
              if (snapshot.hasError || snapshot.data == null) {
                  return const _NoContents();
                } else if (snapshot.data.isEmpty) {
                  return const _NoContents();
                }

                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(
                          height: 15,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      Article? article = snapshot.data[index];
                      return Card5(
                          article: article!);
                    });
            }
          },
        ),
      ],
    );
  }
}

class _NoContents extends StatelessWidget {
  const _NoContents();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      margin: const EdgeInsets.only(right: 20, left: 20),
      child: const Text(
        'no-contents',
        style: TextStyle(
          fontSize: 16,
        ),
      ).tr(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 20, left: 20),
      child: const LoadingIndicatorWidget()
    );
  }
}

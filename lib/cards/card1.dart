import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/video_icon.dart';
import '../blocs/config_bloc.dart';
import '../constants/constant.dart';

//small card with right sight image
class Card1 extends StatelessWidget {
  final Article article;
  final String heroTag;
  const Card1({
    super.key,
    required this.article,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    final configs = context.read<ConfigBloc>().configs!;
    final bool showDateTime = configs.showDateTime;

    return InkWell(
        child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppService.getNormalText(article.title!),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 17),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Chip(
                            side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1, strokeAlign: 0),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            label: Text(
                              article.category.toString(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Hero(
                      tag: heroTag,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomCacheImage(imageUrl: article.image, radius: 5.0),
                          ),
                          VideoIcon(
                            article: article,
                            iconSize: 40,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: showDateTime,
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.time,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        AppService.getTime(article.date!, context),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      BookmarkIcon(
                        bookmarkedList: bookmarkedList,
                        article: article,
                        iconSize: 18,
                      )
                    ],
                  ),
                ),
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag, configs));
  }
}

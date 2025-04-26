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

//big card with title only
class Card3 extends StatelessWidget {
  const Card3({super.key, required this.article, required this.heroTag});
  final Article article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    final configs = context.read<ConfigBloc>().configs!;
    final bool showDateTime = configs.showDateTime;

    return InkWell(
        child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                          child: Hero(
                              tag: heroTag,
                              child: CustomCacheImage(imageUrl: article.image, radius: 0))),
                    ),
                    VideoIcon(
                      article: article,
                      iconSize: 60,
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.category!.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppService.getNormalText(article.title!),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: showDateTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary),
                            ),
                            const Spacer(),
                            BookmarkIcon(
                              bookmarkedList: bookmarkedList,
                              article: article,
                              iconSize: 18,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag, configs));
  }
}

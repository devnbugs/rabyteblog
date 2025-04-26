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

//small card with left side image
class Card6 extends StatelessWidget {
  const Card6({
    super.key,
    required this.article,
    required this.heroTag,
  });
  final Article article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    final configs = context.read<ConfigBloc>().configs!;
    final bool showDateTime = configs.showDateTime;
    
    return InkWell(
        child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 130,
                      child: Hero(
                          tag: heroTag,
                          child: CustomCacheImage(imageUrl: article.image, radius: 5)),
                    ),
                    VideoIcon(
                      article: article,
                      iconSize: 50,
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppService.getNormalText(article.title!),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          article.category!.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: showDateTime,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Flexible(
                                flex: 6,
                                fit: FlexFit.tight,
                                child: Text(
                                  AppService.getTime(article.date!, context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
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
                  ),
                )
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag, configs));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabyteblog/blocs/config_bloc.dart';
import 'package:rabyteblog/models/article.dart';
import 'package:rabyteblog/services/app_service.dart';
import 'package:rabyteblog/services/bookmark_service.dart';
import 'package:rabyteblog/utils/cached_image.dart';
import 'package:rabyteblog/utils/next_screen.dart';
import 'package:rabyteblog/widgets/video_icon.dart';

class BookmarkCard extends StatelessWidget {
  final Article article;
  const BookmarkCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final String heroTag = UniqueKey().toString();
    final configs = context.read<ConfigBloc>().configs!;
    final bool showDateTime = configs.showDateTime;

    return InkWell(
        child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 110,
                      width: 110,
                      child: Hero(
                          tag: heroTag,
                          child: CustomCacheImage(imageUrl: article.image, radius: 5)),
                    ),
                    VideoIcon(article: article, iconSize: 40)
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
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
                              ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                                  Text(AppService.getTime(article.date!, context),
                                      style: TextStyle(
                                          fontSize: 12, color: Theme.of(context).colorScheme.secondary)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () => BookmarkService().removeFromBookmarkList(article))
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        onTap: () => navigateToDetailsScreen(context, article, heroTag, configs));
  }
}

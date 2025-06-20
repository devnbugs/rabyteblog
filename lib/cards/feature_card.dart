import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabyteblog/models/article.dart';
import 'package:rabyteblog/services/app_service.dart';
import 'package:rabyteblog/utils/cached_image.dart';
import 'package:rabyteblog/utils/next_screen.dart';
import 'package:rabyteblog/widgets/video_icon.dart';

import '../blocs/config_bloc.dart';

class FeatureCard extends StatelessWidget {
  final Article article;
  final String heroTag;
  const FeatureCard({super.key, required this.article, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    final bool showDateTime = configs.showDateTime;
    return InkWell(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: heroTag,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: <BoxShadow>[BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10, offset: const Offset(0, 3))]),
                      child: CustomCacheImage(imageUrl: article.image, radius: 5),
                    ),
                    VideoIcon(
                      article: article,
                      iconSize: 80,
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    decoration: const BoxDecoration(
                        color: Colors.black26, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppService.getNormalText(article.title!),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: showDateTime,
                          child: Row(
                            children: <Widget>[
                              const Icon(CupertinoIcons.time, size: 16, color: Colors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(AppService.getTime(article.date!, context), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade200))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
        onTap: () => navigateToDetailsScreen(context, article, heroTag, configs));
  }
}

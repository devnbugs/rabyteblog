import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/pages/article_details/post_date.dart';
import 'package:wordpress_app/pages/article_details/post_views.dart';
import 'package:wordpress_app/pages/author_artcles.dart';
import 'package:wordpress_app/pages/comments_page.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/html_body/html_body.dart';
import 'package:wordpress_app/widgets/related_articles.dart';
import 'package:wordpress_app/widgets/tags.dart';
import '../../blocs/theme_bloc.dart';
import '../../config/custom_ad_config.dart';
import '../../constants/constant.dart';
import '../../models/article.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../services/wordpress_service.dart';
import '../../widgets/banner_ad.dart';
import '../../widgets/custom_ad.dart';
import '../../widgets/native_ad_widget.dart';

class ArticleDetailsLayout3 extends StatefulWidget {
  final String? tag;
  final Article article;

  const ArticleDetailsLayout3({super.key, this.tag, required this.article});

  @override
  State<ArticleDetailsLayout3> createState() => _ArticleDetailsLayout3State();
}

class _ArticleDetailsLayout3State extends State<ArticleDetailsLayout3> {
  Future _handleShare() async {
    Share.share(widget.article.link!);
  }

  _updatePostViews() {
    Future.delayed(const Duration(seconds: 2)).then((value) => WordPressService.addViewsToPost(widget.article.id!));
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final configs = context.read<ConfigBloc>().configs!;
      final adb = context.read<AdsBloc>();
      adb.increaseClickCounter();
      if (configs.admobEnabled && configs.interstitialAdsEnabled) {
        adb.showLoadedAd(configs.clickAmount);
      }
    });
    _updatePostViews();
  }

  @override
  Widget build(BuildContext context) {
    final Article article = widget.article;
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    final configs = context.read<ConfigBloc>().configs!;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: HeroMode(
                        enabled: widget.tag != null,
                        child: Hero(tag: widget.tag ?? '', child: CustomCacheImageWithDarkFilterBottom(imageUrl: article.image, radius: 0))),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            backgroundColor: Theme.of(context).primaryColor,
                            labelPadding: const EdgeInsets.only(left: 10, right: 10),
                            side: BorderSide.none,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            label: Text(article.category.toString().toUpperCase()),
                            labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            AppService.getNormalText(article.title!),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 1.8, letterSpacing: -0.5, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              PostDate(article: article, textColor: Colors.white),
                              PostViews(article: article, textColor: Colors.white),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                          )
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Theme.of(context).colorScheme.onSecondary,
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.arrow_back_ios_sharp, size: 18, color: Theme.of(context).colorScheme.primary),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                                radius: 17,
                                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                                child: BookmarkIcon(bookmarkedList: bookmarkedList, article: article, iconSize: 18)),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Theme.of(context).colorScheme.onSecondary,
                              child: IconButton(
                                icon: Icon(Icons.share, size: 18, color: Theme.of(context).colorScheme.primary),
                                onPressed: () => _handleShare(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Align(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.50,
                  minChildSize: 0.50,
                  builder: ((context, scrollController) {
                    return SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => nextScreenPopupiOS(context, AuthorArticles(article: article)),
                                      child: Row(
                                        children: [
                                          ClipOval(child: SizedBox(height: 40, child: CachedNetworkImage(imageUrl: article.avatar.toString()))),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                article.author.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    AppService.getReadingTime(article.content.toString()),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Visibility(
                                      visible: configs.commentsEnabled && configs.loginEnabled,
                                      child: Row(
                                        children: <Widget>[
                                          TextButton.icon(
                                            style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                                            icon: const Icon(Feather.message_circle, color: Colors.white, size: 20),
                                            label: Text(
                                              'comments',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
                                            ).tr(),
                                            onPressed: () => nextScreenPopupiOS(
                                                context,
                                                CommentsPage(
                                                  article: article,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //native ads
                              Visibility(
                                visible: AppService.nativeAdVisible(Constants.adPlacements[2], configs),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: NativeAdWidget(isDarkMode: context.read<ThemeBloc>().darkTheme ?? false, isSmallSize: true),
                                ),
                              ),

                              //custom ads
                              Visibility(
                                visible: AppService.customAdVisible(Constants.adPlacements[2], configs),
                                child: Container(
                                  height: CustomAdConfig.defaultBannerHeight,
                                  padding: const EdgeInsets.only(top: 30),
                                  child: CustomAdWidget(
                                    assetUrl: configs.customAdAssetUrl,
                                    targetUrl: configs.customAdDestinationUrl,
                                  ),
                                ),
                              ),
                              HtmlBody(content: article.content.toString(), isVideoEnabled: true, isimageEnabled: true, isIframeVideoEnabled: true),
                              const SizedBox(
                                height: 20,
                              ),
                              Tags(tagIds: widget.article.tags ?? []),
                              //native ads
                              Visibility(
                                visible: AppService.nativeAdVisible(Constants.adPlacements[3], configs),
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: NativeAdWidget(isDarkMode: context.read<ThemeBloc>().darkTheme ?? false, isSmallSize: true)),
                              ),

                              //custom ads
                              Visibility(
                                visible: AppService.customAdVisible(Constants.adPlacements[3], configs),
                                child: Container(
                                  height: CustomAdConfig.defaultBannerHeight,
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: CustomAdWidget(
                                    assetUrl: configs.customAdAssetUrl,
                                    targetUrl: configs.customAdDestinationUrl,
                                  ),
                                ),
                              ),
                              RelatedArticles(
                                postId: article.id,
                                catId: article.catId,
                              ),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),

        // Banner Ads Admob
        bottomNavigationBar: Visibility(
          visible: configs.admobEnabled && configs.bannerAdsEnabled,
          child: const BannerAdWidget(),
        ),
      ),
    );
  }
}

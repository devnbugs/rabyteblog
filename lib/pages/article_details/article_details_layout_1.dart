import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/pages/article_details/post_views.dart';
import 'package:wordpress_app/pages/author_artcles.dart';
import 'package:wordpress_app/pages/comments_page.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/banner_ad.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/custom_ad.dart';
import 'package:wordpress_app/widgets/html_body/html_body.dart';
import 'package:wordpress_app/widgets/native_ad_widget.dart';
import 'package:wordpress_app/widgets/related_articles.dart';
import 'package:wordpress_app/widgets/tags.dart';
import '../../blocs/theme_bloc.dart';
import '../../config/custom_ad_config.dart';
import '../../constants/constant.dart';
import '../../models/article.dart';
import '../../services/wordpress_service.dart';
import '../../utils/cached_image.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'post_date.dart';

class ArticleDetailsLayout1 extends StatefulWidget {
  final String? tag;
  final Article article;

  const ArticleDetailsLayout1({super.key, this.tag, required this.article});

  @override
  State<ArticleDetailsLayout1> createState() => _ArticleDetailsLayout1State();
}

class _ArticleDetailsLayout1State extends State<ArticleDetailsLayout1> {
  double _rightPaddingValue = 140;
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      setState(() {
        _rightPaddingValue = 10;
      });
    });
    _updatePostViews();
  }

  @override
  Widget build(BuildContext context) {
    final Article article = widget.article;
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    final configs = context.read<ConfigBloc>().configs!;

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        bottom: true,
        top: false,
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              expandedHeight: 290,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: FlexibleSpaceBar(
                  background: HeroMode(
                enabled: widget.tag != null,
                child: Hero(
                  tag: widget.tag ?? '',
                  child: CustomCacheImage(imageUrl: article.image, radius: 0.0),
                ),
              )),
              actions: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.arrow_back_ios_sharp, size: 18, color: Theme.of(context).colorScheme.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: IconButton(
                    icon: Icon(Icons.share, size: 18, color: Theme.of(context).colorScheme.primary),
                    onPressed: () => _handleShare(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: IconButton(
                    icon: Icon(Feather.external_link, size: 18, color: Theme.of(context).colorScheme.primary),
                    onPressed: () => AppService().openLinkWithCustomTab(context, article.link!),
                  ),
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).secondaryHeaderColor),
                                    child: AnimatedPadding(
                                      duration: const Duration(milliseconds: 1000),
                                      padding: EdgeInsets.only(left: 10, right: _rightPaddingValue, top: 5, bottom: 5),
                                      child: Text(article.category.toString().toUpperCase(),
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    )),
                                const Spacer(),
                                BookmarkIcon(
                                  bookmarkedList: bookmarkedList,
                                  article: article,
                                  iconSize: 22,
                                  iconColor: Colors.blueGrey,
                                  normalIconColor: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                PostDate(article: article),
                                PostViews(article: article),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppService.getNormalText(article.title!),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold, wordSpacing: 1.8, letterSpacing: -0.5),
                            ),
                            Divider(
                              color: Theme.of(context).primaryColor,
                              endIndent: 280,
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
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
                                        style: TextButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
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
                          ],
                        ),
                      ),

                      //native ads
                      Visibility(
                        visible: AppService.nativeAdVisible(Constants.adPlacements[2], configs),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: NativeAdWidget(isDarkMode: context.read<ThemeBloc>().darkTheme ?? false, isSmallSize: true)),
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
                      Tags(tagIds: widget.article.tags ?? [])
                    ],
                  ),

                  //native ads
                  Visibility(
                    visible: AppService.nativeAdVisible(Constants.adPlacements[3], configs),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: NativeAdWidget(isDarkMode: context.read<ThemeBloc>().darkTheme ?? false, isSmallSize: true),
                    ),
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
          ],
        ),
      ),

      // Banner Ads Admob
      bottomNavigationBar: Visibility(
        visible: configs.admobEnabled && configs.bannerAdsEnabled,
        child: const BannerAdWidget(),
      ),
    );
  }
}

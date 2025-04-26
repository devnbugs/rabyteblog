import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/constants/constant.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/pages/article_details/article_details_layout_1.dart';
import 'package:wordpress_app/pages/custom_notification_details.dart';
import 'package:wordpress_app/pages/article_details/video_article_details.dart';
import 'package:wordpress_app/pages/future_article_details.dart';
import 'package:wordpress_app/services/app_service.dart';
import '../pages/article_details/article_details_layout2.dart';
import '../pages/article_details/article_details_layout3.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplaceiOS(context, page) {
  Navigator.pushReplacement(context, CupertinoModalPopupRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void nextScreenPopupiOS(context, page) {
  Navigator.push(
    context,
    CupertinoPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void nextScreenReplaceAnimation(context, page) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ));
  }

  void nextScreenCloseOthersAnimation(context, page) {
    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    ), ((route) => false));
  }

void navigateToDetailsScreen(context, Article article, String? heroTag, ConfigModel configs) {
  if (AppService.isVideoPost(article)) {
    nextScreeniOS(context, VideoArticleDeatils(article: article));
  } else {
    final Widget layout = getPostLayout(article, heroTag, configs);
    nextScreeniOS(context, layout);
  }
}

// Not used now. Replaced by normal
void navigateToDetailsScreenByReplace(context, Article article, String? heroTag, ConfigModel configs) {
  if (AppService.isVideoPost(article)) {
    nextScreenReplaceAnimation(context, VideoArticleDeatils(article: article));
  } else {
    final Widget layout = getPostLayout(article, heroTag, configs);
    nextScreenReplaceiOS(context, layout);
  }
}

Widget getPostLayout (Article article , String? heroTag, ConfigModel configs){
  if(configs.postDetailsLayout == Constants.postDetailsLayouts[0]){
    final List<Widget> layouts = [
      ArticleDetailsLayout1(article: article, tag: heroTag,),
      ArticleDetailsLayout2(article: article, tag: heroTag,),
      ArticleDetailsLayout3(article: article, tag: heroTag,)
    ];
    var layout = layouts..shuffle()..take(1);
    return layout.first;
    
  } else if(configs.postDetailsLayout == Constants.postDetailsLayouts[1]){
    return ArticleDetailsLayout1(article: article, tag: heroTag,);

  } else if (configs.postDetailsLayout == Constants.postDetailsLayouts[2]){
    return ArticleDetailsLayout2(article: article, tag: heroTag);

  } else if (configs.postDetailsLayout == Constants.postDetailsLayouts[3]){
    return ArticleDetailsLayout3(article: article, tag: heroTag);

  } else{
    return ArticleDetailsLayout1(article: article, tag: heroTag);
  }
}

void navigateToNotificationDetailsScreen(context, NotificationModel notificationModel) {
  if (notificationModel.postID == null) {
    nextScreenPopupiOS(context, CustomNotificationDeatils(notificationModel: notificationModel));
  } else {
    nextScreen(
        context,
        FutureArticleDetails(
          postID: notificationModel.postID!,
          fromNotification: true,
        ));
  }
}

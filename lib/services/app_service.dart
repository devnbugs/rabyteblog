import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hive/hive.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:reading_time/reading_time.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/utils/toast.dart';
import '../config/language_config.dart';
import '../constants/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class AppService {
  Future<bool> checkInternet() async {
    bool internet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      internet = false;
    }
    return internet;
  }

  Future addToRecentSearchList(String newSerchItem) async {
    final hive = await Hive.openBox(Constants.resentSearchTag);
    hive.add(newSerchItem);
  }

  Future removeFromRecentSearchList(int selectedIndex) async {
    final hive = await Hive.openBox(Constants.resentSearchTag);
    hive.deleteAt(selectedIndex);
  }

  Future openLink(context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      openToast1("Can't launch the url");
    }
  }

  Future openEmailSupport(context, String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email.trim(),
      query:
          'subject=About ${Config.appName}&body=', //add subject and body here
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1("Can't open the email app");
    }
  }

  Future sendCommentReportEmail(context, String postTitle, String comment,
      String postLink, String userName, String supportEmail) async {
    final String formattedComment = AppService.getNormalText(comment);
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query:
          'subject=${Config.appName} - Comment Report&body=$userName has reported on a comment on $postTitle.\nReported Comment: $formattedComment\nPost Link: $postLink', //add subject and body here
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1("Can't open the email app");
    }
  }

  Future openLinkWithCustomTab(BuildContext context, String url) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: CustomTabsOptions(
          colorScheme: context.read<ThemeBloc>().darkTheme! ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    } catch (e) {
      openToast1('Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future launchAppReview(context) async {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    StoreRedirect.redirect(androidAppId: sb.packageName, iOSAppId: Config.iOSAppID);
    if (Platform.isIOS) {
      if (Config.iOSAppID == '000000') {
        openToast1('The iOS version is not available on the AppStore yet');
      }
    }
  }

  static getNormalText(String text) {
    return HtmlUnescape().convert(parse(text).documentElement!.text);
  }

  static String getVimeoId(String videoUrl) {
    RegExp regExp = RegExp(
        r'(?:http|https)?:?\/?\/?(?:www\.)?(?:player\.)?vimeo\.com\/(?:channels\/(?:\w+\/)?|groups\/(?:[^\/]*)\/videos\/|video\/|)(\d+)(?:|\/\?)');
    return regExp.firstMatch(videoUrl)!.group(1).toString();
  }

  static bool isEmailValid(email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static String getTime(DateTime dateTime, BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.currentLocale;
    final data = timeago.format(dateTime, locale: currentLocale.toString());
    return data;
  }

  static String getDate(DateTime dateTime) {
    final date = Jiffy.parseFromDateTime(dateTime).yMMMd;
    return date;
  }

  static bool isVideoPost(Article article) {
    if (article.videoPost! && (article.videoUrl != '' || article.youtubeUrl != '' || article.viemoUrl != '')) {
      return true;
    } else {
      return false;
    }
  }

  // configuring list to string for blocked categories
  static String getIds(List<int> ids) {
    if (ids.isEmpty) {
      return '0';
    } else {
      final rawIds = ids.join(',');
      return rawIds;
    }
  }

  static String getReadingTime(String text) {
    if (text == '') {
      return '';
    } else {
      var reader = readingTime(getNormalText(text));
      return reader.msg;
    }
  }

  static bool nativeAdVisible(String placement, ConfigModel configs) {
    if (configs.admobEnabled && configs.nativeAdsEnabled && configs.nativeAdPlacements.contains(placement)) {
      return true;
    } else {
      return false;
    }
  }

  static bool customAdVisible(String placement, ConfigModel configs) {
    if (!configs.nativeAdsEnabled && configs.customAdsEnabled && configs.customAdAssetUrl != '' && configs.customAdPlacements.contains(placement)) {
      return true;
    } else {
      return false;
    }
  }

  static Future appStartupFunctions() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp();

    Directory directory = await getApplicationDocumentsDirectory();
    // Hive.init(directory.path);
    Hive
      ..init(directory.path)
      ..openBox(Constants.bookmarkTag)
      ..openBox(Constants.resentSearchTag)
      ..openBox(Constants.notificationTag);

    LanguageConfig.setLocaleMessagesForTimeAgo();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}

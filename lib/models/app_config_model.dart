import 'package:wordpress_app/constants/constant.dart';

class ConfigModel {
  final List<int> homeCategories;
  final String supportEmail;
  final String priivacyPolicyUrl;
  final String fbUrl;
  final String youtubeUrl;
  final String instagramUrl;
  final String twitterUrl;
  final List<int> blockedCategories;
  final bool menubarEnabled;
  final bool logoPositionCenter;
  final bool popularPostEnabled;
  final bool featuredPostEnabled;
  final bool welcomeScreenEnabled;
  final bool commentsEnabled;
  final bool loginEnabled;
  final bool multiLanguageEnabled;
  final bool customAdsEnabled;
  final String customAdAssetUrl;
  final String customAdDestinationUrl;
  final List<String> customAdPlacements;
  final int postIntervalCount;
  final bool admobEnabled;
  final bool bannerAdsEnabled;
  final bool interstitialAdsEnabled;
  final int clickAmount;
  final String postDetailsLayout;
  final bool nativeAdsEnabled;
  final List<String> nativeAdPlacements;
  final bool onBoardingEnbaled;
  final bool socialEmbedPostsEnabled;
  final bool videoTabEnabled;
  final bool socialLoginsEnabled;
  final bool fbLoginEnabled;
  final String threadsUrl;
  final bool featuredPostsAutoSlide;
  final bool showDateTime;
  final bool showPostViews;

  ConfigModel(
      {required this.homeCategories,
      required this.supportEmail,
      required this.priivacyPolicyUrl,
      required this.fbUrl,
      required this.youtubeUrl,
      required this.instagramUrl,
      required this.twitterUrl,
      required this.blockedCategories,
      required this.menubarEnabled,
      required this.logoPositionCenter,
      required this.popularPostEnabled,
      required this.featuredPostEnabled,
      required this.welcomeScreenEnabled,
      required this.commentsEnabled,
      required this.loginEnabled,
      required this.multiLanguageEnabled,
      required this.customAdsEnabled,
      required this.customAdAssetUrl,
      required this.customAdDestinationUrl,
      required this.customAdPlacements,
      required this.postIntervalCount,
      required this.admobEnabled,
      required this.bannerAdsEnabled,
      required this.interstitialAdsEnabled,
      required this.clickAmount,
      required this.postDetailsLayout,
      required this.nativeAdsEnabled,
      required this.nativeAdPlacements,
      required this.onBoardingEnbaled,
      required this.socialEmbedPostsEnabled,
      required this.videoTabEnabled,
      required this.socialLoginsEnabled,
      required this.threadsUrl,
      required this.fbLoginEnabled,
      required this.featuredPostsAutoSlide,
      required this.showDateTime,
      required this.showPostViews,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
        homeCategories: _getListInt(json['home_categories']),
        supportEmail: _getString(json['support_email']),
        priivacyPolicyUrl: _getString(json['privacy_policy_url']),
        fbUrl: _getString(json['fb_url']),
        youtubeUrl: _getString(json['youtube_url']),
        instagramUrl: _getString(json['instagram_url']),
        twitterUrl: _getString(json['twitter_url']),
        blockedCategories: _getListInt(json['blocked_categories']),
        menubarEnabled: _getBool(json['menubar_enabled']),
        logoPositionCenter: _getBool(json['logo_position_center']),
        popularPostEnabled: _getBool(json['popular_post_enabled']),
        featuredPostEnabled: _getBool(json['featured_post_enabled']),
        welcomeScreenEnabled: _getBool(json['welcome_screen_enabled']),
        commentsEnabled: _getBool(json['comments_enabled']),
        loginEnabled: _getBool(json['login_enabled']),
        multiLanguageEnabled: _getBool(json['multilanguage_enabled']),
        customAdsEnabled: _getBool(json['custom_ads_enabled']),
        customAdAssetUrl: _getString(json['custom_ad_asset']),
        customAdDestinationUrl: json['custom_ad_destination_url'],
        customAdPlacements: _getListString(json['custom_ad_placements']),
        postIntervalCount: _getPostInterval(json['post_interval_count']),
        admobEnabled: _getBool(json['admob_enabled']),
        bannerAdsEnabled: _getBool(json['banner_ads_enabled']),
        interstitialAdsEnabled: _getBool(json['interstitial_ads_enabled']),
        clickAmount: _getClickAmount(json['click_amount']),
        postDetailsLayout: _getPostLayout(json['post_details_layout']),
        nativeAdsEnabled: _getBool(json['native_ads_enabled']),
        nativeAdPlacements: _getListString(json['native_ad_placements']),
        onBoardingEnbaled: _getBool(json['onboarding_enabled']),
        socialEmbedPostsEnabled: _getBool(json['social_embedded_enabled']),
        videoTabEnabled: _getBool(json['video_tab_enabled']),
        socialLoginsEnabled: _getBool(json['social_logins_enabled']),
        threadsUrl: _getString(json['threads_url']),
        fbLoginEnabled: _getBool(json['fb_login_enabled']),
        featuredPostsAutoSlide: _getBool(json['feature_posts_autoslide']),
        showDateTime: _getBool(json['datetime_enabled']),
        showPostViews: _getBool(json['post_views_enabled']),
    );
  }

  static String _getPostLayout(dynamic value) {
    if (value == false || value == '' || value == null) {
      return Constants.postDetailsLayouts[0];
    } else {
      return value;
    }
  }

  static String _getString(value) {
    if (value == false || value == null) {
      return '';
    } else {
      return value;
    }
  }

  static bool _getBool(value) {
    if (value == '1') {
      return true;
    } else {
      return false;
    }
  }

  static int _getPostInterval (dynamic value){
    if (value == false || value == null || value == '0') {
      return Constants.defaultPostIntervalforAds;
    } else {
      return int.parse(value.toString());
    }
  }

  static int _getClickAmount (dynamic value){
    if (value == false || value == null) {
      return Constants.defaultClickAmountToShowInterstitialAds;
    } else {
      return int.parse(value.toString());
    }
  }

  static List<int> _getListInt(value) {
    if (value == false || value == null) {
      return [];
    } else {
      return value.cast<int>();
    }
  }

  static List<String> _getListString(dynamic value) {
    if (value == false || value == null || value == '') {
      return [];
    } else {
      List list = [];
      if (value is Map) {
        list = value.values.toList();
      } else if (value is List) {
        list = value;
      } else if (value is String) {
        list.add(value);
      } else {
        list = [];
      }

      return list.cast<String>();
    }
  }
}

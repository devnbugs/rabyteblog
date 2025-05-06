import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {
  // ----Android----
  static const String appIdAndroid = 'ca-app-pub-2742296332020210~5912277974';
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-2742296332020210/7500707724';
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-2742296332020210/7078035892';
  static const String nativeAdUnitIdAnndroid = 'ca-app-pub-2742296332020210/5764954223';

  // ----iOS------
  static const String appIdiOS = 'ca-app-pub-2742296332020210~3556194483';
  static const String interstitialAdUnitIdiOS = 'ca-app-pub-2742296332020210/5307425702';
  static const String bannerAdUnitIdiOS = 'ca-app-pub-2742296332020210/9930031141';
  static const String nativeAdUnitIdiOS = 'ca-app-pub-2742296332020210/6741002276';

  // -- Don't edit these --

  static Future initAdmob() async {
    await MobileAds.instance.initialize();
  }

  static String getAdmobAppId() {
    if (Platform.isAndroid) {
      return appIdAndroid;
    } else {
      return appIdiOS;
    }
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return bannerAdUnitIdAndroid;
    } else {
      return bannerAdUnitIdiOS;
    }
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return interstitialAdUnitIdAndroid;
    } else {
      return interstitialAdUnitIdiOS;
    }
  }


  static String getNativeAdUnitId() {
    if (Platform.isAndroid) {
      return nativeAdUnitIdAnndroid;
    } else {
      return nativeAdUnitIdiOS;
    }
  }
}

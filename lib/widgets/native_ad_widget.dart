import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/config/config.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key, required this.isDarkMode, required this.isSmallSize});
  final bool isDarkMode;
  final bool isSmallSize;

  @override
  NativeAdWidgetState createState() => NativeAdWidgetState();
}

class NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = AdConfig.getNativeAdUnitId();

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double minHeight = widget.isSmallSize ? 90.0 : 320.0;
    final double maxHeight = widget.isSmallSize ? 120.0 : 360.0;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320.0,
        minHeight: minHeight,
        maxWidth: 400.0,
        maxHeight: maxHeight,
      ),
      child: _nativeAdIsLoaded && _nativeAd != null
          ? AdWidget(ad: _nativeAd!)
          : Container(
              color: Theme.of(context).colorScheme.surface,
              alignment: Alignment.center,
              child: const Text(
                'Ad',
                style: TextStyle(fontSize: 20),
              ),
            ),
    );
  }

  // Loads a native ad.
  void loadAd() {
    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeAdOptions: NativeAdOptions(
          mediaAspectRatio: MediaAspectRatio.landscape,
          adChoicesPlacement: AdChoicesPlacement.topRightCorner,
        ),

        // Styling
        nativeTemplateStyle: widget.isDarkMode ? nativeTemplateDark() : nativeTemplateLight())
      ..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }


  //Dark Mode
  NativeTemplateStyle nativeTemplateDark() {
    final templateType = widget.isSmallSize ? TemplateType.small : TemplateType.medium;
    return NativeTemplateStyle(
      templateType: templateType,
      mainBackgroundColor: Colors.grey.shade800,
      cornerRadius: 10.0,
      callToActionTextStyle:
          NativeTemplateTextStyle(textColor: Colors.white, backgroundColor: Config.appThemeColor, style: NativeTemplateFontStyle.normal, size: 16.0),
      primaryTextStyle:
          NativeTemplateTextStyle(textColor: Colors.white, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.bold, size: 16.0),
      secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade100, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 14.0),
      tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade100, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 14.0),
    );
  }

  
  // Light Mode
  NativeTemplateStyle nativeTemplateLight() {
    final templateType = widget.isSmallSize ? TemplateType.small : TemplateType.medium;
    return NativeTemplateStyle(
      templateType: templateType,
      mainBackgroundColor: Colors.white,
      cornerRadius: 10.0,
      callToActionTextStyle:
          NativeTemplateTextStyle(textColor: Colors.white, backgroundColor: Config.appThemeColor, style: NativeTemplateFontStyle.normal, size: 16.0),
      primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade900, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.bold, size: 16.0),
      secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.blueGrey.shade600, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 14.0),
      tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.blueGrey.shade500, backgroundColor: Colors.transparent, style: NativeTemplateFontStyle.normal, size: 14.0),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import '../blocs/theme_bloc.dart';
import '../config/custom_ad_config.dart';
import '../constants/constant.dart';
import '../services/app_service.dart';
import 'custom_ad.dart';
import 'native_ad_widget.dart';

class InlineAds extends StatelessWidget {
  const InlineAds({super.key, this.isSliver});

  final bool? isSliver;

  @override
  Widget build(BuildContext context) {
    final configs = context.watch<ConfigBloc>().configs!;
    return Column(
      children: [
        //native ads
        Visibility(
            visible: AppService.nativeAdVisible(Constants.adPlacements[1], configs),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: NativeAdWidget(
                isDarkMode: context.watch<ThemeBloc>().darkTheme ?? false,
                isSmallSize: false,
              ),
            )),

        //custom ads
        Visibility(
          visible: AppService.customAdVisible(Constants.adPlacements[1], configs),
          child: Container(
              height: CustomAdConfig.defaultBannerHeight,
              padding: isSliver != null && isSliver == true ? const EdgeInsets.only(bottom: 15) : const EdgeInsets.only(top: 15) ,
              child: CustomAdWidget(
                assetUrl: configs.customAdAssetUrl,
                targetUrl: configs.customAdDestinationUrl,
                radius: 5,
              )),
        )
      ],
    );
  }
}

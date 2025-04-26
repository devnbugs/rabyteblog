import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/splash.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyPageWithImage(
            image: Config.noInternetImage,
            title: 'no-internet'.tr(),
            description: 'check-connection'.tr(),
          ),
          RoundedLoadingButton(
            onPressed: ()=> nextScreenReplaceAnimation(context, const SplashPage()),
            animateOnTap: false,
            elevation: 0,
            controller: RoundedLoadingButtonController(),
            color: Theme.of(context).primaryColor,
            child: Text('try-again', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),).tr(),
          )
        ],
      ),
    );
  }
}

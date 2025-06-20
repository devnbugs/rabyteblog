import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rabyteblog/config/language_config.dart';
import 'package:rabyteblog/services/app_service.dart';
import 'app.dart';

void main() async {
  await AppService.appStartupFunctions();
  runApp(EasyLocalization(
    supportedLocales: LanguageConfig.supportedLocales,
    path: 'assets/translations',
    fallbackLocale: LanguageConfig.fallbackLocale,
    startLocale: LanguageConfig.startLocale,
    child: const MyApp(),
  ));
}

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class LanguageConfig {
  //Initial Language
  static const Locale startLocale = Locale('en', 'US');

  //Language if any error happens
  static const Locale fallbackLocale = Locale('en', 'US');

  // Languages
  static const Map<String, List<String>> languages = {
    //language_name : [language_code, country_code(Capital format)]
    "English": ['en', 'US'],
    "Spanish": ['es', 'ES'],
    "French" : ['fr', 'FR'],
    "Hindi": ['hi', 'IN'],
    "Arabic": ['ar', 'SA'],
    "Bangla": ['bn', 'BD'],
  };



  // Local Messages for time ago
  static void setLocaleMessagesForTimeAgo() {
    final List<String> localesString = languages.values.map((e) => Locale(e.first, e.last).toString()).toList();

    //must be align with languages
    timeago.setLocaleMessages(localesString[0], timeago.EnMessages());
    timeago.setLocaleMessages(localesString[1], timeago.EsMessages());
    timeago.setLocaleMessages(localesString[2], timeago.FrMessages());
    timeago.setLocaleMessages(localesString[3], timeago.HiMessages());
    timeago.setLocaleMessages(localesString[4], timeago.ArMessages());
    timeago.setLocaleMessages(localesString[5], timeago.EnMessages());
  }

  // Don't edit this
  static List<Locale> supportedLocales =
      languages.values.map((e) => Locale(e.first, e.last,)).toList();
}

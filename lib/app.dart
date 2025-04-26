import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/comment_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/category_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/latest_articles_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/popular_articles_bloc.dart';
import 'blocs/settings_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'blocs/user_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'models/theme.dart';
import 'pages/splash.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver = FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsBloc>(create: (context) => SettingsBloc()),
                ChangeNotifierProvider<CategoryBloc>(create: (context) => CategoryBloc()),
                ChangeNotifierProvider<FeaturedBloc>(create: (context) => FeaturedBloc()),
                ChangeNotifierProvider<LatestArticlesBloc>(create: (context) => LatestArticlesBloc()),
                ChangeNotifierProvider<UserBloc>(create: (context) => UserBloc()),
                ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
                ChangeNotifierProvider<PopularArticlesBloc>(create: (context) => PopularArticlesBloc()),
                ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
                ChangeNotifierProvider<CommentsBloc>(create: (context) => CommentsBloc()),
                ChangeNotifierProvider<ConfigBloc>(create: (context) => ConfigBloc()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  navigatorObservers: [firebaseObserver],
                  locale: context.locale,
                  theme: ThemeModel().lightTheme,
                  darkTheme: ThemeModel().darkTheme,
                  themeMode: mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                  home: const SplashPage()));
        },
      ),
    );
  }
}

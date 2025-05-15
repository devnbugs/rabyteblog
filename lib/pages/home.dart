import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/blocs/featured_bloc.dart';
import 'package:wordpress_app/blocs/latest_articles_bloc.dart';
import 'package:wordpress_app/blocs/notification_bloc.dart';
import 'package:wordpress_app/blocs/popular_articles_bloc.dart';

import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/services/app_links_service.dart';
import 'package:wordpress_app/services/ad_manager.dart';

import 'package:wordpress_app/tabs/home_tab.dart';
import 'package:wordpress_app/tabs/home_tab_without_tabs.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/search_tab.dart';
import 'package:wordpress_app/tabs/video_tab.dart';
import 'package:wordpress_app/tabs/bookmark_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  int _tapCount = 0;

  final List<IconData> _iconList = [
    Feather.home,
    Feather.search,
    Feather.heart,
    Feather.user,
  ];

  final List<IconData> _iconListWithVideoTab = [
    Feather.home,
    Feather.youtube,
    Feather.search,
    Feather.heart,
    Feather.user,
  ];

  final List<Widget> _tabs = [
    const SearchTab(),
    const BookmarkTab(),
    const SettingPage(),
  ];

  final List<Widget> _tabsWithVideo = [
    const VideoTab(),
    const SearchTab(),
    const BookmarkTab(),
    const SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initData();
    _fetchPostsData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initData() async {
    final cb = context.read<CategoryBloc>();
    final nb = context.read<NotificationBloc>();
    final ab = context.read<AdsBloc>();
    final ub = context.read<UserBloc>();
    final sb = context.read<SettingsBloc>();
    final configs = context.read<ConfigBloc>().configs!;

    NotificationService().initOneSignal(context);

    Future.microtask(() {
      nb.checkPermission();
      cb.fetchData(configs.blockedCategories);
    });

    await AppLinksService().initUniLinks(context);
    sb.getPackageInfo();

    if (!ub.guestUser) {
      ub.getUserData();
    }

    if (configs.admobEnabled) {
      await AdConfig.initAdmob().then((_) {
        if (configs.interstitialAdsEnabled) {
          ab.initiateAds();
        }
      });
    }
  }

  void _fetchPostsData() {
    Future.microtask(() {
      if (!mounted) return;
      final configs = context.read<ConfigBloc>().configs!;
      if (configs.featuredPostEnabled) {
        context.read<FeaturedBloc>().fetchData();
      }
      if (configs.popularPostEnabled) {
        context.read<PopularArticlesBloc>().fetchData();
      }
      context.read<LatestArticlesBloc>().fetchData(configs.blockedCategories);
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  Future<bool> _onBackPressed() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      return false;
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      return true;
    }
  }

  void _onUserTap() {
    _tapCount++;
    if (_tapCount >= 10) {
      _tapCount = 0;
      AdManager.showRewardedAd(() {
        debugPrint("User watched the ad and earned a reward.");
      });
    }
  }

  List<Widget> _childrens(ConfigBloc cb) {
    return cb.configs!.videoTabEnabled ? _tabsWithVideo : _tabs;
  }

  List<Tab> _categoryTabs(ConfigBloc cb) {
    return [
      Tab(text: 'explore'.tr()),
      ...cb.homeCategories.map((e) => Tab(text: e.name)),
    ];
  }

  AnimatedBottomNavigationBar _bottomNavigationBar(
      BuildContext context, ConfigBloc cb) {
    return AnimatedBottomNavigationBar(
      icons: cb.configs!.videoTabEnabled ? _iconListWithVideoTab : _iconList,
      gapLocation: GapLocation.none,
      activeIndex: _selectedIndex,
      iconSize: 22,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cb = context.watch<ConfigBloc>();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(context, cb),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            cb.configs!.homeCategories.isEmpty
                ? HomeTabWithoutTabs(configs: cb.configs!)
                : HomeTab(
                    configs: cb.configs!,
                    homeCategories: cb.homeCategories,
                    categoryTabs: _categoryTabs(cb),
                  ),
            ..._childrens(cb),
          ],
        ),
      ),
    );
  }
}

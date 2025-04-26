import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/tabs/home_tab.dart';
import 'package:wordpress_app/tabs/home_tab_without_tabs.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/search_tab.dart';
import 'package:wordpress_app/tabs/video_tab.dart';
import '../blocs/featured_bloc.dart';
import '../blocs/latest_articles_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../blocs/popular_articles_bloc.dart';
import '../services/app_links_service.dart';
import '../tabs/bookmark_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController? _pageController;

  final List<IconData> _iconList = [Feather.home, Feather.search, Feather.heart, Feather.user];

  final List<IconData> _iconListWithVideoTab = [Feather.home, Feather.youtube, Feather.search, Feather.heart, Feather.user];

  final List<Widget> _tabs = [
    const SearchTab(),
    const BookmarkTab(),
    const SettingPage(),
  ];

  final List<Widget> _tabsWithVideo = [const VideoTab(), const SearchTab(), const BookmarkTab(), const SettingPage()];

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
      await AdConfig.initAdmob().then((value) {
        if (configs.interstitialAdsEnabled) {
          ab.initiateAds();
        }
      });
    }
  }

  _fetchPostsData() async {
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initData();
    _fetchPostsData();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController!.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _onBackPressed() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      _pageController!.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cb = context.read<ConfigBloc>();
    return PopScope(
      onPopInvokedWithResult: (didPop, x) {
        if (didPop) {
          return;
        }
        _onBackPressed();
      },
      child: Scaffold(
        bottomNavigationBar: _bottonNavigationBar(context, cb),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          controller: _pageController,
          children: <Widget>[
            cb.configs!.homeCategories.isEmpty
                ? HomeTabWithoutTabs(
                    configs: cb.configs!,
                  )
                : HomeTab(
                    configs: cb.configs!,
                    homeCategories: cb.homeCategories,
                    categoryTabs: _categoryTabs(cb),
                  ),
            ..._childrens(cb)
          ],
        ),
      ),
    );
  }

  List<Widget> _childrens(ConfigBloc cb) {
    if (cb.configs!.videoTabEnabled) {
      return _tabsWithVideo;
    } else {
      return _tabs;
    }
  }

  List<Tab> _categoryTabs(ConfigBloc cb) {
    return cb.homeCategories.map((e) => Tab(text: e.name)).toList()..insert(0, Tab(text: 'explore'.tr()));
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(BuildContext context, ConfigBloc cb) {
    return AnimatedBottomNavigationBar(
      icons: cb.configs!.videoTabEnabled ? _iconListWithVideoTab : _iconList,
      gapLocation: GapLocation.none,
      activeIndex: _selectedIndex,
      iconSize: 22,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/pages/notifications.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/app_logo.dart';
import 'package:wordpress_app/widgets/drawer.dart';
import 'package:wordpress_app/widgets/tab_medium.dart';
import '../pages/search.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.configs,
    required this.categoryTabs,
    required this.homeCategories,
  });

  final List<Category> homeCategories;
  final ConfigModel configs;
  final List<Tab> categoryTabs;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    _tabController = TabController(length: widget.categoryTabs.length, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: Visibility(
          visible: widget.configs.menubarEnabled, child: const CustomDrawer()),
      key: scaffoldKey,
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: widget.configs.logoPositionCenter,
            titleSpacing: 0,
            title: const AppLogo(
              height: 19,
            ),
            leading: Visibility(
              visible: widget.configs.menubarEnabled,
              child: IconButton(
                icon: const Icon(
                  Feather.menu,
                  size: 25,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
            ),
            elevation: 1,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  AntDesign.search1,
                  size: 22,
                ),
                onPressed: () {
                  nextScreenPopupiOS(context, const SearchPage());
                },
              ),
              const SizedBox(width: 3),
              IconButton(
                padding: const EdgeInsets.only(right: 8),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  AntDesign.bells,
                  size: 20,
                ),
                onPressed: () => nextScreenPopupiOS(context, const Notifications()),
              ),
              
            ],
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar(
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontFamily: 'Manrope', fontSize: 15, fontWeight: FontWeight.w600),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey, //niceish grey
              isScrollable: true,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: widget.categoryTabs,
            ),
          ),
        ];
      }, body: Builder(
        builder: (BuildContext context) {
          final ScrollController innerScrollController = PrimaryScrollController.of(context);
          return TabMedium(
            sc: innerScrollController,
            tc: _tabController,
            scaffoldKey: scaffoldKey,
            homeCategories: widget.homeCategories,
          );
        },
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

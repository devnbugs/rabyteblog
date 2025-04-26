import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/pages/notifications.dart';
import 'package:wordpress_app/top_tabs/tab0.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/app_logo.dart';
import 'package:wordpress_app/widgets/drawer.dart';

import '../pages/search.dart';

class HomeTabWithoutTabs extends StatefulWidget {
  const HomeTabWithoutTabs({super.key, required this.configs});

  final ConfigModel configs;

  @override
  State<HomeTabWithoutTabs> createState() => _HomeTabWithoutTabsState();
}

class _HomeTabWithoutTabsState extends State<HomeTabWithoutTabs> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: Visibility(visible: widget.configs.menubarEnabled, child: const CustomDrawer()),
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
          ),
        ];
      }, body: Builder(
        builder: (BuildContext context) {
          final ScrollController innerScrollController = PrimaryScrollController.of(context);
          return Tab0(sc: innerScrollController);
        },
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/cards/card6.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/empty_icon.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import '../constants/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var searchFieldCtrl = TextEditingController();
  bool _searchStarted = false;

  Future? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _searchBar(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [_searchStarted == false ? _suggestionUI() : _afterSearchUI()],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        autofocus: true,
        controller: searchFieldCtrl,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "search-contents".tr(),
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: Icon(
                Icons.close,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  _searchStarted = false;
                });
                searchFieldCtrl.clear();
              }),
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value == '' || value.isEmpty) {
            openSnacbar(context, 'Type something!');
          } else {
            setState(() => _searchStarted = true);
            data = WordPressService().fetchPostsBySearch(searchFieldCtrl.text, context.read<ConfigBloc>().configs!.blockedCategories);
            AppService().addToRecentSearchList(value);
          }
        },
      ),
    );
  }

  Widget _afterSearchUI() {
    final configs = context.read<ConfigBloc>().configs!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const _LoadingWidget();
              case ConnectionState.done:
              if (snapshot.hasError || snapshot.data == null) {
                  return const EmptyPageWithIcon(icon: Icons.error, title: 'Error!');
                } else if (snapshot.data.isEmpty) {
                  return EmptyPageWithImage(
                    image: Config.noContentImage,
                    title: 'no-contents'.tr(),
                    description: 'try-again'.tr(),
                  );
                }

                return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      Article article = snapshot.data[index];
                      if ((index + 1) % configs.postIntervalCount == 0) {
                        return Column(
                          children: [
                            Card6(
                              article: article,
                              heroTag: UniqueKey().toString(),
                            ),
                            const InlineAds(),
                          ],
                        );
                      } else {
                        return Card6(
                          article: article,
                          heroTag: UniqueKey().toString(),
                        );
                      }
                    });
            }
          },
        ),
      ],
    );
  }

  Widget _suggestionUI() {
    final recentSearchs = Hive.box(Constants.resentSearchTag);
    return recentSearchs.isEmpty
        ? const _EmptySearchAnimation()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'recent-searches'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              ValueListenableBuilder(
                valueListenable: recentSearchs.listenable(),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return ListView.separated(
                    itemCount: recentSearchs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: ListTile(
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.only(left: 20, right: 10),
                            title: Text(
                              recentSearchs.getAt(index),
                              style: const TextStyle(fontSize: 17),
                            ),
                            leading: Icon(
                              CupertinoIcons.time_solid,
                              color: Colors.grey[400],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
                              onPressed: () => AppService().removeFromRecentSearchList(index),
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() => _searchStarted = true);
                              searchFieldCtrl.text = recentSearchs.getAt(index);
                              data =
                                  WordPressService().fetchPostsBySearch(searchFieldCtrl.text, context.read<ConfigBloc>().configs!.blockedCategories);
                            }),
                      );
                    },
                  );
                },
              ),
            ],
          );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
        itemBuilder: (BuildContext context, int index) {
          return const LoadingCard(height: 200);
        });
  }
}

class _EmptySearchAnimation extends StatelessWidget {
  const _EmptySearchAnimation();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            height: 200,
            width: 200,
            child: const FlareActor(
              Config.searchAnimation,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "search",
              //color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
        ),
        const Text(
          'search-for-contents',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.7, wordSpacing: 1),
        ).tr(),
        const SizedBox(
          height: 10,
        ),
        Text(
          'search-description',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
        ).tr()
      ],
    );
  }
}

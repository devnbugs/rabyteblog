import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/tab_scroll_controller.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/cards/card4.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cards/card1.dart';
import '../models/article.dart';

class CustomCategoryTab extends StatefulWidget {
  final Category category;
  final ScrollController sc;

  const CustomCategoryTab({super.key, required this.category, required this.sc});

  @override
  State<CustomCategoryTab> createState() => _CustomCategoryTabState();
}

class _CustomCategoryTabState extends State<CustomCategoryTab> {
  final List<Article> _articles = [];
  bool? _isLoading;
  bool? _hasData;
  int _page = 1;
  final int _postAmountPerLoad = 5;

  Future _fetchData() async {
    await WordPressService().fetchPostsByCategoryId(widget.category.id, _page, _postAmountPerLoad).then((value) {
      _articles.addAll(value);
      _isLoading = false;
      if (_articles.isEmpty) {
        _hasData = false;
      }
      setState(() {});
    });
  }

  _onReload() async {
    setState(() {
      _isLoading = null;
      _hasData = true;
      _articles.clear();
      _page = 1;
    });
    await _fetchData();
  }

  @override
  void initState() {
    super.initState();
    widget.sc.addListener(scrollListener);
    _hasData = true;
    _fetchData();
  }

  void scrollListener() async {
    bool isEnd = TabScrollController().isEnd(widget.sc);
    debugPrint('isEnd: $isEnd');
    if (mounted) {
      if (isEnd && _articles.isNotEmpty) {
        setState(() {
          _page += 1;
          _isLoading = true;
        });
        await _fetchData().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      onRefresh: () async {
        await _onReload();
      },
      child: _hasData == false
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                EmptyPageWithImage(image: Config.noContentImage, title: 'no-contents'.tr())
              ],
            )
          : ListView.separated(
              key: PageStorageKey(widget.category.id),
              padding: const EdgeInsets.all(15),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _articles.isNotEmpty ? _articles.length + 1 : 5,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 15,
              ),
              shrinkWrap: true,
              itemBuilder: (_, int index) {
                if (_articles.isEmpty && _hasData == true) {
                  return const LoadingCard(height: 250);
                } else if (index < _articles.length) {
                  if ((index + 1) % configs.postIntervalCount == 0) {
                    return Column(
                      children: [
                        Card1(
                          article: _articles[index],
                          heroTag: UniqueKey().toString(),
                        ),
                        const InlineAds(),
                      ],
                    );
                  } else {
                    return Card4(
                      article: _articles[index],
                      heroTag: UniqueKey().toString(),
                    );
                  }
                }
                return Opacity(opacity: _isLoading == true ? 1.0 : 0.0, child: const LoadingIndicatorWidget());
              },
            ),
    );
  }
}

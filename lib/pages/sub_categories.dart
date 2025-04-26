import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/cards/card1.dart';
import 'package:wordpress_app/cards/card4.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import '../cards/category_card.dart';
import '../models/article.dart';
import '../services/wordpress_service.dart';
import '../utils/loading_card.dart';
import '../utils/next_screen.dart';
import '../widgets/loading_indicator_widget.dart';
import 'search.dart';

class SubCategories extends StatefulWidget {
  const SubCategories({super.key, required this.category, required this.subCategories});
  final Category category;
  final List<Category> subCategories;

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name.toString()),
        actions: [
          IconButton(
            style: IconButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 15)),
            icon: const Icon(AntDesign.search1, size: 22),
            onPressed: () => nextScreenPopupiOS(context, const SearchPage()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: widget.subCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryCard(
                  category: widget.subCategories[index],
                  allCategories: widget.subCategories,
                  isTitleCenter: true,
                  titleFontSize: 22,
                );
              },
            ),
            const Divider(),
            _CategoryArticles(
              scrollController: scrollController,
              category: widget.category,
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryArticles extends StatefulWidget {
  const _CategoryArticles({required this.scrollController, required this.category});

  final ScrollController scrollController;
  final Category category;

  @override
  State<_CategoryArticles> createState() => __CategoryArticlesState();
}

class __CategoryArticlesState extends State<_CategoryArticles> {
  final List<Article> _articles = [];
  int page = 1;
  bool? _loading;
  bool? _hasData;
  final int _postAmount = 10;

  late ScrollController controller;

  @override
  void initState() {
    controller = widget.scrollController;
    controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    widget.scrollController.addListener(_scrollListener);
    _fetchArticles();
    _hasData = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    widget.scrollController.dispose();
  }

  Future _fetchArticles() async {
    await WordPressService().fetchPostsByCategoryId(widget.category.id, page, _postAmount).then((value) {
      _articles.addAll(value);
      if (_articles.isEmpty) {
        _hasData = false;
      }
      setState(() {});
    });
  }

  _scrollListener() async {
    var isEnd = widget.scrollController.offset >= widget.scrollController.position.maxScrollExtent && !widget.scrollController.position.outOfRange;
    if (isEnd && _articles.isNotEmpty) {
      setState(() {
        page += 1;
        _loading = true;
      });
      await _fetchArticles().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.watch<ConfigBloc>().configs!;

    return Column(
      children: [
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),
          itemCount: _articles.isEmpty ? 5 : _articles.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (BuildContext context, int index) {
            if (_articles.isEmpty && _hasData == true) {
              return const LoadingCard(height: 280);
            } else if (index < _articles.length) {
              if ((index + 1) % configs.postIntervalCount == 0) {
                return Column(
                  children: [
                    Card4(article: _articles[index], heroTag: UniqueKey().toString()),
                    const InlineAds(),
                  ],
                );
              } else {
                return Card1(article: _articles[index], heroTag: UniqueKey().toString());
              }
            }

            return null;
          },
        ),
        Opacity(opacity: _loading == true ? 1.0 : 0.0, child: const LoadingIndicatorWidget())
      ],
    );
  }
}

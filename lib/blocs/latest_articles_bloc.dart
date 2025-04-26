import 'package:flutter/material.dart';
import '../models/article.dart';

import '../services/wordpress_service.dart';

class LatestArticlesBloc extends ChangeNotifier {
  int _page = 1;
  int get page => _page;

  final List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _loading = false;
  bool get loading => _loading;

  final int _postAmountPerLoad = 10;

  Future fetchData(List<int> blockedCategoryIds) async {
    await WordPressService().fetchAllPosts(_page, _postAmountPerLoad, blockedCategoryIds).then((value) {
      _articles.addAll(value);
      notifyListeners();
    });
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  pageIncreament() {
    _page += 1;
    notifyListeners();
  }

  onReload(List<int> blockedCategoryIds) async {
    _articles.clear();
    _page = 1;
    notifyListeners();
    fetchData(blockedCategoryIds);
  }
}

import 'package:flutter/material.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import '../models/article.dart';

class PopularArticlesBloc extends ChangeNotifier {
  final List<Article> _articles = [];
  List<Article> get articles => _articles;

  final int _contentAmount = 4;
  final String _timeRange = 'last30days';

  bool _hasData = true;
  bool get hasData => _hasData;

  Future fetchData() async {
    _hasData = true;
    _articles.clear();
    notifyListeners();

    await WordPressService().fetchPopularPosts(_timeRange, _contentAmount).then((value) {
      _articles.addAll(value);
      if (_articles.isEmpty) {
        _hasData = false;
      }
      notifyListeners();
    });
  }
}

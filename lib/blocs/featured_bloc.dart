import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import '../models/article.dart';

class FeaturedBloc extends ChangeNotifier {
  final List<Article> _articles = [];
  List<Article> get articles => _articles;

  final CarouselSliderController carouselController = CarouselSliderController();

  bool _hasData = true;
  bool get hasData => _hasData;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  Future fetchData() async {
    _hasData = true;
    _articles.clear();
    notifyListeners();
    carouselController.animateToPage(0);

    await WordPressService().fetchFeaturedPosts().then((value) {
      _articles.addAll(value);
      if (_articles.isEmpty) {
        _hasData = false;
      }
    });
    notifyListeners();
  }

  void updatePageIndex(int newIndex) {
    _pageIndex = newIndex;
    notifyListeners();
  }
}

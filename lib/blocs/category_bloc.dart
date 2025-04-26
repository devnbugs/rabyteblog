
import 'package:flutter/material.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import '../models/category.dart';

class CategoryBloc extends ChangeNotifier {
  List<Category> _categoryData = [];
  List<Category> get categoryData => _categoryData;

  Future fetchData(List<int> blockedCategoryIds) async {
    _categoryData.clear();
    notifyListeners();
    _categoryData = await WordPressService().getCategories(blockedCategoryIds);
    notifyListeners();
  }

  
}

import 'package:flutter/material.dart';

import '../models/app_config_model.dart';
import '../models/category.dart';
import '../services/wordpress_service.dart';

class ConfigBloc extends ChangeNotifier {

  late ConfigModel? _configs;
  ConfigModel? get configs => _configs;

  late List<Category> _homeCategories = [];
  List<Category> get homeCategories => _homeCategories;


  Future<bool> getConfigsData() async {
    bool hasData = false;
    _configs = await WordPressService().getConfigsFromAPI();
    if (_configs != null) {
      debugPrint('Got data from API');
      _homeCategories = await WordPressService().fetchCategoriesByIDs(_configs!.homeCategories);
      hasData = true;
    }
    notifyListeners();
    return hasData;
  }
}

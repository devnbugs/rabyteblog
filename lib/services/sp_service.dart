import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/category.dart';

class SPService {

  Future clearLocalData () async{
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future setNotificationSubscription (bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('n_subscribe', value);
  }

  Future<bool> getNotificationSubscription () async{
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('n_subscribe') ?? true;
    return value;
  }

  Future saveConfigs (ConfigModel configModel) async{
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(configModel);
    await prefs.setString('configs', data);
    debugPrint('saveDone');
  }

  Future<ConfigModel?> getConfigs () async{
    final prefs = await SharedPreferences.getInstance();
    String? rawData = prefs.getString('configs');
    if(rawData != null){
      Map<String, dynamic> json = jsonDecode(rawData);
      ConfigModel configModel = ConfigModel.fromJson(json);
      debugPrint(configModel.supportEmail);
      return configModel;
    }else{
      return null;
    }
  }

  Future saveHomeCategories (List<Category> categories) async{
    final prefs = await SharedPreferences.getInstance();
    var data = jsonEncode(categories);
    await prefs.setString('home_categories', data);
    debugPrint('saveDone');
  }

  Future<List<Category>> getHomeCategoriesFromSP () async{
    List<Category> categories = [];
    final prefs = await SharedPreferences.getInstance();
    String? rawData = prefs.getString('home_categories');
    if(rawData != null){
      categories = jsonDecode(rawData);
      debugPrint(categories[0].name);
    }
    return categories;
  }
}
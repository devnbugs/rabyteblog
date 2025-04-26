import 'package:wordpress_app/config/wp_config.dart';

class Category {
  final int? id;
  final String? name;
  final int? parent;
  final int? count;
  final String? categoryThumbnail;

  Category({this.id, this.name, this.parent, this.count, this.categoryThumbnail});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        parent: json['parent'],
        count: json["count"],
        categoryThumbnail: _getCategoryThumbnail(json['thumbnail'])
    );
  }

  static String _getCategoryThumbnail (data){
    if(data == null || data == false || data == ''){
      return WpConfig.defaultCategoryThumbnail;
    }else{
      final String imageUrl =  data['guid'] ?? WpConfig.defaultCategoryThumbnail;
      return imageUrl;
    }
  }
}

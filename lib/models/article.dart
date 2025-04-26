import 'package:wordpress_app/config/wp_config.dart';

class Article {
  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final String? author;
  final String? avatar;
  final String? category;
  final DateTime? date;
  final String? link;
  final int? catId;
  final List<int>? tags;
  final int? authorId;
  final bool? featured;
  final bool? videoPost;
  final String? videoUrl;
  final String? youtubeUrl;
  final String? viemoUrl;
  final String? views;

  Article(
      {this.id,
      this.title,
      this.content,
      this.image,
      this.author,
      this.avatar,
      this.category,
      this.date,
      this.link,
      this.catId,
      this.tags,
      this.authorId,
      this.featured,
      this.videoPost,
      this.videoUrl,
      this.youtubeUrl,
      this.viemoUrl,
      this.views,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title']['rendered'] ?? '',
      content: json['content']['rendered'] ?? '',
      image: json['custom']["featured_image"] != false ? json['custom']["featured_image"] : WpConfig.defaultFeatureImage,
      author: json['custom']['author']['name'] ?? '',
      avatar: json['custom']['author']['avatar'] ?? 'https://icon-library.com/images/avatar-icon/avatar-icon-27.jpg',
      date: DateTime.parse("${json['date_gmt']}Z").toLocal(),
      link: json['link'] ?? '',
      category: json["custom"]["categories"][0]["name"] ?? '',
      catId: json["custom"]["categories"][0]["cat_ID"] ?? 0,
      tags: json['tags'] != null ? List<int>.from(json['tags']) : [],
      authorId: json['author']?.toInt() ?? 0,
      featured: _getBool(json['featured']),
      videoPost: _getBool(json['video_post']),
      videoUrl: _getVideoUrl(json['video_url']),
      youtubeUrl: json['youtube_url'] ?? '',
      viemoUrl: json['vimeo_url'] ?? '',
      views:  _getViews(json['custom']['views']?? 0),
    );
  }

  factory Article.fromJsonLocal(Map<dynamic, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      author: json['author'],
      avatar: json['avatar'],
      date: json['date'],
      link: json['link'],
      category: json['category'],
      catId: json['cat_id'],
      tags: json['tags'],
      authorId: json['author_id'],
      featured: json['featured'],
      videoPost: json['video_post'],
      videoUrl: json['video_url'],
      youtubeUrl: json['youtube_url'],
      viemoUrl: json['vimeo_url']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title': title ?? '',
      'content': content ?? '',
      'image': image ?? '',
      'author': author ?? '',
      'avatar': avatar ?? '',
      'date': date,
      'link': link ?? '',
      'category': category ?? '',
      'cat_id': catId ?? 0,
      'tags': tags ?? [],
      'author_id': authorId ?? 0,
      'featured': featured ?? false,
      'video_post': videoPost ?? false,
      'video_url': videoUrl ?? '',
      'youtube_url': youtubeUrl ?? '',
      'vimeo_url' : viemoUrl ?? ''
    };
  }

  static bool _getBool (dynamic value){
    if(value == '1'){
      return true;
    }else{
      return false;
    }
  }

  static String _getVideoUrl (dynamic value){
    if(value == null || value == false){
      return '';
    }else{
      if(value['guid'] == null){
        return '';
      }else{
        return value['guid'];
      }
    }
  }

  static String _getViews (value){
    if(value is String){
      return value;
    }else if(value is int){
      return value.toString();
    }else{
      return '0';
    }
  }
}

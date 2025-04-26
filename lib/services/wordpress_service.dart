import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wordpress_app/config/wp_config.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/toast.dart';
import '../models/author.dart';
import '../models/category.dart';
import '../models/post_tag.dart';

class WordPressService {
  Future<List<Article>> fetchPostsByCategoryIdExceptPostId(int? postId, int? catId, int contentAmount) async {
    List<Article> articles = [];
    final String url = "${WpConfig.baseURL}/wp-json/wp/v2/posts?exclude=$postId&categories[]=$catId&per_page=$contentAmount";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        articles = decodedData.map((m) => Article.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return articles;
  }

  Future<List<Article>> fetchPostsByCategoryId(int? catId, int page, int contentAmount) async {
    List<Article> articles = [];
    final String url = "${WpConfig.baseURL}/wp-json/wp/v2/posts?categories[]=$catId&page=$page&per_page=$contentAmount";
    try {
      var response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        articles = decodedData.map((m) => Article.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return articles;
  }

  Future<List<Article>> fetchAllPosts(int page, int contentAmount, List<int> blockedCategoryIds) async {
    String ids = AppService.getIds(blockedCategoryIds);
    List<Article> articles = [];
    final String url = "${WpConfig.baseURL}/wp-json/wp/v2/posts/?page=$page&per_page=$contentAmount&categories_exclude=$ids";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        articles = decodedData.map((m) => Article.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return articles;
  }

  Future<List<Article>> fetchPostsBySearch(String searchText, List<int> blockedCategoryIds) async {
    List<Article> articles = [];
    String ids = AppService.getIds(blockedCategoryIds);
    final String url = "${WpConfig.baseURL}/wp-json/wp/v2/posts?per_page=30&search=$searchText&categories_exclude=$ids";
    try {
      var response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        articles = decodedData.map((m) => Article.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  Future<Article?> getPostBySlug(String slug) async {
    Article? article;
    try {
      var response = await http.get(Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/posts?slug=$slug"));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        List<Article> articles = decodedData.map((e) => Article.fromJson(e)).toList();
        article = articles.first;
      }
    } catch (error) {
      debugPrint(error.toString());
    }

    return article;
  }

  Future<Article?> fetchPostsById(int postID) async {
    Article? article;
    try {
      var response = await http.get(Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/posts/$postID"));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        article = Article.fromJson(decodedData);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return article;
  }

  Future<List<PostTag>> getTagsById(List<int> ids) async {
    List<PostTag> tags = [];
    if (ids.isEmpty) {
      return tags;
    } else if (ids.length <= 10) {
      final rawTags = ids.join(',');
      final url = '${WpConfig.baseURL}/wp-json/wp/v2/tags/?include=$rawTags';
      try {
        final response = await http.get(Uri.parse(url));
        final decodedList = jsonDecode(response.body) as List;
        tags = decodedList.map((e) => PostTag.fromJson(e)).toList();
        return tags;
      } catch (e) {
        debugPrint(e.toString());
        return tags;
      }
    } else {
      for (var i = 0; i < ids.length; i++) {
        final url = '${WpConfig.baseURL}/wp-json/wp/v2/tags/${ids[i]}';
        try {
          final response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            tags.add(PostTag.fromJson(jsonDecode(response.body)));
          } else {}
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      return tags;
    }
  }

  Future<List<Article>> fetchPostsByTag(int pageNumber, int tagID, int contentAmount) async {
    final String url = '${WpConfig.baseURL}/wp-json/wp/v2/posts/?tags=$tagID&page=$pageNumber&per_page=$contentAmount';
    List<Article> articles = [];
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List;
        articles = decodedData.map((e) => Article.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  Future<List<Article>> fetchFeaturedPosts() async {
    const String url = '${WpConfig.baseURL}/wp-json/wp/v2/posts?featured=1';
    List<Article> articles = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List;
        articles = decodedData.map((e) => Article.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  Future<List<Article>> fetchVideoPosts(int page, int postAmount) async {
    final String url = '${WpConfig.baseURL}/wp-json/wp/v2/posts?video=1&page=$page&per_page=$postAmount';
    List<Article> articles = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List;
        articles = decodedData.map((e) => Article.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  Future<List<Article>> fetchPostsByAuthor(int pageNumber, int authorId, int contentAmount) async {
    final String url = '${WpConfig.baseURL}/wp-json/wp/v2/posts/?page=$pageNumber&author=$authorId&status=publish&per_page=$contentAmount';
    List<Article> articles = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List;
        articles = decodedData.map((e) => Article.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  static Future<List<Author>> fetchAllAuthors(int page) async {
    List<Author> users = [];
    final url = '${WpConfig.baseURL}/wp-json/wp/v2/users/?page=$page';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List decodedData = jsonDecode(response.body);
        users = decodedData.map((e) => Author.fromJson(e)).toList();
        return users;
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return users;
  }

  static Future<Author?> getAuthorData(int authorID) async {
    Author? author;
    final url = '${WpConfig.baseURL}/wp-json/wp/v2/users/$authorID';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        author = Author.fromJson(decodedData);
      }
    } catch (e) {
      openToast('Erorr on getting author data: $e');
    }
    return author;
  }

  Future<List<CommentModel>> fetchCommentsByPostId(int id, int page, int amount) async {
    List<CommentModel> comments = [];
    try {
      var response = await http.get(Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/comments?post=$id&page=$page&per_page=$amount"));

      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        comments = decodedData.map((m) => CommentModel.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return comments;
  }

  Future<bool> postComment(int? id, String? name, String email, String comment) async {
    try {
      var response = await http.post(Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/comments"),
          body: {"author_email": email.trim().toLowerCase(), "author_name": name, "content": comment, "post": id.toString()});

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<ConfigModel?> getConfigsFromAPI() async {
    ConfigModel? configs;
    try {
      var response = await http.get(Uri.parse("${WpConfig.baseURL}/wp-json/newsfreak/configs"))
      .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body) as Map<String, dynamic>;
        configs = ConfigModel.fromJson(decodedData);
      }
    } on TimeoutException catch(_) {
      debugPrint('time out');
    } catch (e) {
      debugPrint('api error: $e');
    } 
    return configs;
  }

  Future<List<Category>> fetchCategoriesByIDs(List ids) async {
    List<Category> categories = [];
    if (ids.isEmpty) {
      return categories;
    } else {
      final categoryIds = ids.join(',');
      final String url = '${WpConfig.baseURL}/wp-json/wp/v2/categories?include=$categoryIds&orderby=include';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List decodedData = jsonDecode(response.body) as List;
          categories = decodedData.map((e) => Category.fromJson(e)).toList();
        } else {
          debugPrint('error on getting categories');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return categories;
  }

  Future<List<Article>> fetchPopularPosts(String timeRange, int contentAmount) async {
    List<Article> articles = [];

    final String url = "${WpConfig.baseURL}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$timeRange&limit=$contentAmount";
    // final String url = WpConfig.blockedCategoryIdsforPopularPosts.isEmpty
    //     ? "${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$timeRange&" + "limit=$contentAmount"
    //     : "${WpConfig.websiteUrl}/wp-json/wordpress-popular-posts/v1/popular-posts?range=$timeRange&" +
    //         "limit=$contentAmount&cat=" +
    //         WpConfig.blockedCategoryIdsforPopularPosts;

    try {
      var response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List decodedData = jsonDecode(response.body);
        articles = decodedData.map((m) => Article.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return articles;
  }

  static Future<bool> addViewsToPost(int postID) async {
    final String url = '${WpConfig.baseURL}/wp-json/wordpress-popular-posts/v1/popular-posts?wpp_id=$postID';
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 201) {
        debugPrint('Post view has been added');
        return true;
      } else {
        debugPrint('Error on adding post view');
        return false;
      }
    } on Exception catch (e) {
      debugPrint('Error on adding post view : $e');
      return false;
    }
  }

  Future<List<Category>> getCategories(List<int> blockedCategoryIds) async {
    String ids = AppService.getIds(blockedCategoryIds);
    List<Category> categories = [];
    final String url = "${WpConfig.baseURL}/wp-json/wp/v2/categories?per_page=100&order=desc&orderby=count&exclude=$ids";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List? decodedData = jsonDecode(response.body);
        categories = decodedData!.map((m) => Category.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return categories;
  }

  Future<bool> postCommentReply(int postId, String userName, String userEmail, String comment, int parentId) async {
    try {
      var response = await http.post(Uri.parse("${WpConfig.baseURL}/wp-json/wp/v2/comments"), body: {
        "author_email": userEmail.trim().toLowerCase(),
        "author_name": userName,
        "content": comment,
        "post": postId.toString(),
        "parent": parentId.toString()
      });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('error: $e');
      return false;
    }
  }
}

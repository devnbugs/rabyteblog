import 'package:flutter/material.dart';

import '../models/category.dart';
import '../pages/category_based_articles.dart';
import '../pages/sub_categories.dart';
import '../utils/cached_image_with_dark.dart';
import '../utils/next_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final List<Category> allCategories;
  final bool? isTitleCenter;
  final double? titleFontSize;
  const CategoryCard({super.key, required this.category, required this.allCategories, this.isTitleCenter, this.titleFontSize});

  @override
  Widget build(BuildContext context) {
    final String heroTag = UniqueKey().toString();
    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Hero(
              tag: heroTag,
              child: CustomCacheImageWithDarkFilterBottom(
                imageUrl: category.categoryThumbnail,
                radius: 5,
              ),
            ),
          ),
          Align(
            alignment: isTitleCenter != null &&  isTitleCenter == true ? Alignment.center: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
              child: Text(
                category.name.toString().toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: titleFontSize ?? 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      onTap: () {
        List<Category> subCategories = allCategories.where((element) => element.parent == category.id).toList();
        if (subCategories.isEmpty) {
          nextScreeniOS(context, CategoryBasedArticles(category: category, heroTag: heroTag));
        } else {
          nextScreeniOS(context, SubCategories(category: category, subCategories: subCategories));
        }
      },
    );
  }
}
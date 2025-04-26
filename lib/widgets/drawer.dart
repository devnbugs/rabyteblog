import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/config/wp_config.dart';
import 'package:wordpress_app/pages/category_based_articles.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/app_logo.dart';
import '../blocs/category_bloc.dart';
import '../models/category.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../pages/sub_categories.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryBloc>().categoryData;
    final configs = context.read<ConfigBloc>().configs!;

    final titleTextStyle = Theme.of(context).textTheme.titleMedium;

    return Drawer(
      backgroundColor: Theme.of(context).canvasColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 250,
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8, top: 20),
                    child: const AppLogo(height: 35),
                  ),
                  Text(
                    'app-version',
                    style: Theme.of(context).textTheme.titleMedium,
                  ).tr(args: [context.read<SettingsBloc>().appVersion])
                ],
              ),
            ),

            // Social Info
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.email_outlined,
                      size: 22,
                    ),
                    horizontalTitleGap: 10,
                    title: Text('contact-us', style: titleTextStyle).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openEmailSupport(context, configs.supportEmail);
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.link_outlined,
                      size: 22,
                    ),
                    horizontalTitleGap: 10,
                    title: Text('our-website', style: titleTextStyle).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openLinkWithCustomTab(context, WpConfig.baseURL);
                    },
                  ),
                  Visibility(
                    visible: configs.fbUrl != '',
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Feather.facebook,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('facebook', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(context, configs.fbUrl);
                      },
                    ),
                  ),
                  Visibility(
                    visible: configs.youtubeUrl != '',
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Feather.youtube,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('youtube', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(context, configs.youtubeUrl);
                      },
                    ),
                  ),
                  Visibility(
                    visible: configs.twitterUrl != '',
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Feather.twitter,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('twitter', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(context, configs.twitterUrl);
                      },
                    ),
                  ),
                  Visibility(
                    visible: configs.instagramUrl != '',
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Feather.instagram,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('instagram', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(context, configs.instagramUrl);
                      },
                    ),
                  ),
                  Visibility(
                    visible: configs.threadsUrl != '',
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Feather.at_sign,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('threads', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(context, configs.threadsUrl);
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[500],
              thickness: 0.6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Text('categories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)).tr(),
            ),

            // Categories
            _Categories(
              categories: categories,
            ),
          ],
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    required this.categories,
  });

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final Category category = categories[index];
        final List<Category> subCategories = categories.where((element) => element.parent == category.id).toList();
        final bool hasSubCategories = subCategories.isEmpty ? false : true;

        //subcategories removed from the category list
        if (category.parent != 0) {
          return const SizedBox.shrink();
        }

        return ExpansionTile(
            tilePadding: const EdgeInsets.only(left: 20, right: 15),
            trailing: hasSubCategories ? null : const SizedBox.shrink(),
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(category.categoryThumbnail!),
            ),
            title: InkWell(
              child: Text(
                category.name.toString().toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),
              ),
              onTap: () {
                Navigator.pop(context);
                if (hasSubCategories) {
                  nextScreeniOS(context, SubCategories(category: category, subCategories: subCategories));
                } else {
                  nextScreeniOS(context, CategoryBasedArticles(category: category));
                }
              },
            ),
            initiallyExpanded: false,
            childrenPadding: const EdgeInsets.only(left: 20, right: 15),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context1, int index1) {
                  Category subCategory = categories[index1];
                  if (subCategory.parent == categories[index].id) {
                    return ListTile(
                      title: Text(
                        subCategory.name!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      horizontalTitleGap: 20,
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundImage: CachedNetworkImageProvider(subCategory.categoryThumbnail!),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context);
                        nextScreen(context, CategoryBasedArticles(category: subCategory));
                      },
                    );
                  }

                  return Container();
                },
              ),
            ]);
      },
    );
  }
}

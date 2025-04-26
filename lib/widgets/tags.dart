import 'package:flutter/material.dart';
import 'package:wordpress_app/models/post_tag.dart';
import 'package:wordpress_app/pages/tag_based_articles.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class Tags extends StatefulWidget {
  const Tags({super.key, required this.tagIds});

  final List<int> tagIds;

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  late Future _tags;

  @override
  void initState() {
    _tags = WordPressService().getTagsById(widget.tagIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tags,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.done:
          if (snapshot.hasError || snapshot.data == null) {
              return Container();
            } else if (snapshot.data.isEmpty) {
              return Container();
            }
            List<PostTag> tags = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: tags
                    .map((e) => ActionChip(
                        onPressed: () => nextScreenPopupiOS(context, TagBasedArticles(tag: e)),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        label: Text(
                          '#${e.name}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500
                          ),
                        )))
                    .toList(),
              ),
            );
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/models/article.dart';

class PostViews extends StatelessWidget {
  const PostViews({super.key, required this.article, this.textColor});
  final Article article;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final configs = context.watch<ConfigBloc>().configs!;

    return Visibility(
      visible: configs.showPostViews && article.views != '',
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.eye,
              size: 20,
              color: textColor ?? Colors.grey.shade500,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              article.views.toString(),
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

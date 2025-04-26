import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocs/config_bloc.dart';
import '../../models/article.dart';
import '../../services/app_service.dart';

class PostDate extends StatelessWidget {
  const PostDate({
    super.key,
    required this.article,
    this.textColor,
  });

  final Article article;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final configs = context.watch<ConfigBloc>().configs!;

    return Visibility(
      visible: configs.showDateTime,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.time_solid,
              color: textColor ?? Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              AppService.getTime(article.date!, context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: textColor ?? Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

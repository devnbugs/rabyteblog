import 'package:flutter/material.dart';
import 'package:wordpress_app/blocs/popular_articles_bloc.dart';
import 'package:wordpress_app/cards/card1.dart';
import 'package:wordpress_app/pages/popular_articles_page.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PopularArticles extends StatelessWidget {
  const PopularArticles({super.key});

  @override
  Widget build(BuildContext context) {
    PopularArticlesBloc pb = context.watch<PopularArticlesBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5, right: 15),
      child: Column(
        children: [
          Row(
            children: [
              verticalLine(context, 22.0),
              const SizedBox(
                width: 5,
              ),
              const Text('popular-contents',
                  style: TextStyle(
                    letterSpacing: -0.7,
                    wordSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  )
              ).tr(),
              const Spacer(),
              TextButton(
                child: const Text(
                  'view-all',
                  style: TextStyle( fontSize: 14),
                ).tr(),
                onPressed: () {
                  nextScreenPopupiOS(context, const PopularArticlesPage());
                },
              )
            ],
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 5, bottom: 15),
            itemCount: pb.articles.isEmpty ? 3 : pb.articles.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (pb.articles.isEmpty) {
                if (pb.hasData) {
                  return const LoadingCard(
                    height: 200,
                  );
                } else {
                  return const _NoContents();
                }
              } else {
                return Card1(
                  article: pb.articles[index],
                  heroTag: UniqueKey().toString(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class _NoContents extends StatelessWidget {
  const _NoContents();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: const Text('No contents found!'),
    );
  }
}

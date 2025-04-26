import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/cards/feature_card.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import '../blocs/featured_bloc.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    final configs = context.watch<ConfigBloc>().configs!;
    final bool isAutoSlidable = configs.featuredPostsAutoSlide;

    return Column(
      children: [
        fb.articles.isEmpty
            ? fb.hasData
                ? const _LoadingWidget()
                : const _NoContentsWidget()
            : CarouselSlider.builder(
                controller: fb.carouselController,
                itemCount: fb.articles.length,
                itemBuilder: (context, index, realIndex) {
                  final String heroTag = UniqueKey().toString();
                  return FeatureCard(article: fb.articles[index], heroTag: heroTag);
                },
                options: CarouselOptions(
                  height: 250,
                  enableInfiniteScroll: true,
                  pageSnapping: true,
                  viewportFraction: 1,
                  autoPlay: isAutoSlidable,
                  enlargeCenterPage: false,
                  initialPage: fb.pageIndex,
                  onPageChanged: (index, reason) => fb.updatePageIndex(index),
                ),
              ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          child: DotsIndicator(
            dotsCount: fb.articles.isEmpty ? 1 : fb.articles.length,
            position: fb.pageIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.secondary,
              spacing: const EdgeInsets.all(3),
              size: const Size.square(5),
              activeSize: const Size(20.0, 3.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoContentsWidget extends StatelessWidget {
  const _NoContentsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(5)),
      child: const Text('no-contents').tr(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: LoadingCard(height: 200),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/services/app_service.dart';

class CustomAdWidget extends StatelessWidget {
  const CustomAdWidget({super.key, required this.assetUrl, required this.targetUrl, this.radius});
  final String assetUrl;
  final String targetUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppService().openLinkWithCustomTab(context, targetUrl),
      child: SizedBox(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: CachedNetworkImage(
            imageUrl: assetUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CountryFlag extends StatelessWidget {
  final String countryCode;

  const CountryFlag({
    super.key,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    final String url = 'https://flagsapi.com/${countryCode.toUpperCase()}/flat/48.png';
    return SizedBox(
      width: 40,
      height: 40,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) => const Icon(Icons.language),
      ),
    );
  }
}

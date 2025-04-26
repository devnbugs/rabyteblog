import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import '../config/config.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.height, this.width});
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().darkTheme ?? false;
    return Image(
      image: AssetImage(
        !isDarkMode ? Config.logo : Config.logoDark,
      ),
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}

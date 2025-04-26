import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingCard extends StatelessWidget {
  final double? height;
  final Color? color;
  const LoadingCard({super.key, required this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: color ?? Theme.of(context).secondaryHeaderColor, 
              borderRadius: BorderRadius.circular(5)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
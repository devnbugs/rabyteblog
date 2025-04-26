import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyPageWithImage extends StatelessWidget {
  const EmptyPageWithImage({
    super.key,
    required this.image,
    required this.title,
    this.description,
  });

  final String image;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      alignment: Alignment.center,
      //height: MediaQuery.of(context).size.height * 0.60,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            height: 180,
            width: 180,
          ),
          const SizedBox(
            height: 30,
          ),
          
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          description == null ? Container() : 
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

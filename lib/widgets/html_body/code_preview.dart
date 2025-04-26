import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/app_service.dart';

class CodePreview extends StatelessWidget {
  const CodePreview({
    super.key, required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        color: Theme.of(context).secondaryHeaderColor,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: SelectableText(AppService.getNormalText(data), style: GoogleFonts.robotoMono(
          fontSize: 16,
          fontWeight: FontWeight.normal
        ),),
      ),
    );
  }
}
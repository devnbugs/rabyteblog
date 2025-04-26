import 'package:flutter/material.dart';
import '../../services/app_service.dart';

class QuoteWidget extends StatelessWidget {
  final String data;
  const QuoteWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            VerticalDivider(color: Theme.of(context).primaryColor, width: 20, thickness: 2),
            Expanded(
                child: Text(
              AppService.getNormalText(data),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

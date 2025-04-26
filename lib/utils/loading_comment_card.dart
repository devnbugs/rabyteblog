import 'package:flutter/material.dart';

import 'loading_card.dart';

class LoadingCommentCard extends StatelessWidget {
  const LoadingCommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                child: LoadingCard(
                  height: 90,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            )
          ],
        ));
  }
}

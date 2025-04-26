import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/services/app_service.dart';

import '../models/comment.dart';
import '../widgets/html_body/html_body.dart';

class CommentReplyCard extends StatelessWidget {
  const CommentReplyCard(
      {super.key,
      required this.comment,
      required this.isCommentFlagged,
      required this.menuPopUp});

  final CommentModel comment;
  final Function(int commentId) isCommentFlagged;
  final Function(CommentModel comment) menuPopUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(
              comment.avatar.toString(),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  left: 8,
                  top: 10,
                  right: 5,
                  bottom: 3,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          comment.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        menuPopUp(comment),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    isCommentFlagged(comment.id)
                        ? Container(
                            child: Text('comment-flagged', style: Theme.of(context).textTheme.bodyLarge,).tr(),
                          )
                        : HtmlBody(
                            content: comment.content.toString(),
                            isVideoEnabled: true,
                            isimageEnabled: true,
                            isIframeVideoEnabled: true,
                            textPadding: 0.0,
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  AppService.getTime(comment.date, context),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

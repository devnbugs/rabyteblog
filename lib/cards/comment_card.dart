import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/cards/comment_reply_card.dart';
import 'package:wordpress_app/services/app_service.dart';

import '../models/comment.dart';
import '../widgets/html_body/html_body.dart';

class CommentCard extends StatelessWidget {
  const CommentCard(
      {super.key,
      required this.allComments,
      required this.comment,
      required this.onReplyButtonPressed,
      required this.menuPopUp,
      required this.isCommentFlagged});

  final List<CommentModel> allComments;
  final CommentModel comment;
  final Function(CommentModel comment) onReplyButtonPressed;
  final Function(CommentModel comment) menuPopUp;
  final Function(int commentId) isCommentFlagged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(comment.avatar.toString()),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 10, right: 5, bottom: 3),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () => onReplyButtonPressed(comment),
                                child: const Icon(
                                  Icons.reply,
                                  size: 20,
                                )),
                            const SizedBox(
                              width: 15,
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: allComments.map((e) {
            if (e.parent == comment.id) {
              return Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  child: CommentReplyCard(
                    comment: e,
                    isCommentFlagged: isCommentFlagged,
                    menuPopUp: menuPopUp,
                  ));
            } else {
              return Container();
            }
          }).toList(),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/comment_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/comment.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/dialog.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_comment_card.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/utils/toast.dart';

import '../cards/comment_card.dart';
import '../widgets/loading_indicator_widget.dart';

class CommentsPage extends StatefulWidget {
  final Article article;
  const CommentsPage({super.key, required this.article});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  var formKey = GlobalKey<FormState>();
  var textFieldCtrl = TextEditingController();
  bool _isSomethingChanging = false;
  bool _replying = false;

  final List<CommentModel> _comments = [];
  List<CommentModel> _filteredComments = [];
  bool? _hasData;
  bool? _loading;
  int _page = 1;
  final int _amount = 15;
  ScrollController? _controller;
  String _replyUserName = '';
  int _parentCommentId = 0;

  Future _getComments() async {
    await WordPressService().fetchCommentsByPostId(widget.article.id!, _page, _amount).then((value) {
      debugPrint(value.length.toString());
      _comments.addAll(value);
      _filteredComments = _comments.where((element) => element.parent == 0).toList();
      if (_comments.isEmpty) {
        _hasData = false;
      }
      setState(() {});
    });
  }

  Future _handlePostComment(int postId) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if (textFieldCtrl.text.isEmpty) {
      openSnacbar(context, "comment-empty".tr());
    } else {
      setState(() {
        _isSomethingChanging = true;
      });
      bool success = await WordPressService().postComment(postId, ub.name, ub.email.toString(), textFieldCtrl.text);
      if (success) {
        textFieldCtrl.clear();
        setState(() {
          _isSomethingChanging = false;
        });
        // ignore: use_build_context_synchronously
        openDialog(context, 'comment-success-title'.tr(), 'comment-success-description'.tr());
        _onRefresh();
      } else {
        textFieldCtrl.clear();
        setState(() {
          _isSomethingChanging = false;
        });
        openToast('comment-failed'.tr());
      }
    }
  }

  Future _handleReplyComment(int postId, int parentCommentID) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if (textFieldCtrl.text.isEmpty) {
      openSnacbar(context, "comment-empty".tr());
    } else {
      setState(() {
        _isSomethingChanging = true;
      });
      bool success = await WordPressService().postCommentReply(postId, ub.name.toString(), ub.email.toString(), textFieldCtrl.text, parentCommentID);
      if (success) {
        textFieldCtrl.clear();
        setState(() {
          _isSomethingChanging = false;
          _replying = false;
        });
        // ignore: use_build_context_synchronously
        openDialog(context, 'comment-success-title'.tr(), 'comment-success-description'.tr());
        _onRefresh();
      } else {
        textFieldCtrl.clear();
        setState(() {
          _isSomethingChanging = false;
          _replying = false;
        });
        openToast('comment-failed'.tr());
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _hasData = true;
    _getComments();
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<CommentsBloc>().getFlagList());
    super.initState();
  }

  _scrollListener() async {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent && !_controller!.position.outOfRange;
    if (isEnd && _comments.isNotEmpty) {
      setState(() {
        _page += 1;
        _loading = true;
      });
      await _getComments().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  _onRefresh() async {
    _comments.clear();
    _filteredComments.clear();
    _hasData = true;
    _loading = null;
    _page = 1;
    setState(() {});
    await _getComments();
  }

  _onReplyButtonPressed(CommentModel comment) {
    final ub = context.read<UserBloc>();
    if (ub.isSignedIn) {
      FocusScope.of(context).requestFocus();
      setState(() {
        _replying = true;
        _replyUserName = comment.author;
        _parentCommentId = comment.id;
      });
    } else {
      openToast('login-to-make-comments'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: const Text('comments').tr(),
        elevation: 1,
        titleSpacing: 0,
        centerTitle: false,
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(
                Feather.refresh_cw,
                size: 20,
              ),
              onPressed: _onRefresh),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        onRefresh: () => _onRefresh(),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: _hasData == false
                      ? EmptyPageWithImage(
                          image: Config.commentImage,
                          title: 'no-comments'.tr(),
                          description: 'make-comment'.tr(),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          controller: _controller,
                          padding: const EdgeInsets.fromLTRB(15, 15, 10, 30),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredComments.isEmpty ? 10 : _filteredComments.length + 1,
                          separatorBuilder: (ctx, idx) => const SizedBox(
                            height: 15,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (_filteredComments.isEmpty && _hasData == true) {
                              return Container(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: const LoadingCommentCard());
                            } else if (index < _filteredComments.length) {
                              final CommentModel comment = _filteredComments[index];
                              return CommentCard(
                                allComments: _comments,
                                comment: comment,
                                onReplyButtonPressed: _onReplyButtonPressed,
                                menuPopUp: _menuPopUp,
                                isCommentFlagged: _isCommentFlagged,
                              );
                            }

                            return Opacity(
                                opacity: _loading == true ? 1.0 : 0.0,
                                child: const LoadingIndicatorWidget());
                          },
                        ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[500],
                ),
                _bottomWidgetToReply(context, _replyUserName)
              ],
            ),
            !_isSomethingChanging
                ? Container()
                : const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      ),
    );
  }

  Widget _bottomWidgetToReply(BuildContext context, replyUserName) {
    if (context.watch<UserBloc>().isSignedIn == false) {
      return InkWell(
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.topCenter,
          height: 70,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: const Text(
            'login-to-make-comments',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ).tr(),
        ),
        onTap: () => nextScreenPopupiOS(
            context,
            const LoginPage(
              popUpScreen: true,
            )),
      );
    } else {
      return SafeArea(
        bottom: true,
        top: false,
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: _replying,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                  child: RichText(
                    text: TextSpan(
                        text: 'replying'.tr(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                        children: [
                          TextSpan(
                              text: '@$_replyUserName',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent))
                        ]),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 10, right: 15, left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 0),
                              contentPadding:
                                  const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              border: InputBorder.none,
                              hintText: 'write-comment'.tr(),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_replying) {
                                      _handleReplyComment(widget.article.id!, _parentCommentId);
                                    } else {
                                      _handlePostComment(widget.article.id!);
                                    }
                                  },
                                  icon: const Icon(Icons.send))),
                          controller: textFieldCtrl,
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                            if (_replying) {
                              setState(() {
                                _replying = false;
                              });
                            }
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            if (_replying) {
                              setState(() {
                                _replying = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  PopupMenuButton<dynamic> _menuPopUp(CommentModel d) {
    return PopupMenuButton(
        padding: const EdgeInsets.all(0),
        color: Theme.of(context).cardColor,
        child: const Icon(
          CupertinoIcons.ellipsis,
          size: 18,
        ),
        itemBuilder: (BuildContext context) {
          return <PopupMenuItem>[
            _isCommentFlagged(d.id)
                ? PopupMenuItem(
                    value: 'unflag',
                    child: Text('unflag-comment', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)).tr(),
                  )
                : PopupMenuItem(
                    value: 'flag',
                    child: Text('flag-comment', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)).tr(),
                  ),
            PopupMenuItem(
              value: 'report',
              child: Text('report', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)).tr(),
            )
          ];
        },
        onSelected: (dynamic value) async {
          if (value == 'flag') {
            await context
                .read<CommentsBloc>()
                .addToFlagList(context, widget.article.catId!, widget.article.id!, d.id);
            _onRefresh();
          } else if (value == 'unflag') {
            await context
                .read<CommentsBloc>()
                .removeFromFlagList(context, widget.article.catId!, widget.article.id!, d.id);
            _onRefresh();
          } else if (value == 'report') {
            final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
            if (ub.isSignedIn == true && ub.name != null) {
              AppService().sendCommentReportEmail(
                context,
                widget.article.title.toString(),
                d.content.toString(),
                widget.article.link.toString(),
                ub.name!,
                context.read<ConfigBloc>().configs!.supportEmail.toString(),
              );
            } else {
              AppService().sendCommentReportEmail(
                context,
                widget.article.title.toString(),
                d.content.toString(),
                widget.article.link.toString(),
                'An Anonymous User',
                context.read<ConfigBloc>().configs!.supportEmail.toString(),
              );
            }
          }
        });
  }

  bool _isCommentFlagged(int? commentId) {
    final cb = context.read<CommentsBloc>();
    final flagId = "${widget.article.catId}-${widget.article.id}-$commentId";
    if (cb.flagList.contains(flagId)) {
      return true;
    } else {
      return false;
    }
  }
}

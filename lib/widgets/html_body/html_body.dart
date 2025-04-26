import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_audio/flutter_html_audio.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/full_image.dart';
import 'package:wordpress_app/widgets/html_body/social_embed.dart';
import 'package:wordpress_app/widgets/video_player_widget.dart';
import 'code_preview.dart';
import '../loading_indicator_widget.dart';
import 'quote_widget.dart';

class HtmlBody extends StatelessWidget {
  final String content;
  final bool isVideoEnabled;
  final bool isimageEnabled;
  final bool isIframeVideoEnabled;
  final double? textPadding;
  const HtmlBody({
    super.key,
    required this.content,
    required this.isVideoEnabled,
    required this.isimageEnabled,
    required this.isIframeVideoEnabled,
    this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    return Html(
      data: content,
      shrinkWrap: true,
      onLinkTap: (url, _, __) {
        AppService().openLinkWithCustomTab(context, url!);
      },
      style: {
        "table": Style(
          padding: HtmlPaddings.symmetric(vertical: 10, horizontal: 10),
        ),
        "tr": Style(padding: HtmlPaddings.symmetric(vertical: 8, horizontal: 8), border: Border.all(color: Colors.grey.shade300, strokeAlign: 0.1)),
        "th": Style(padding: HtmlPaddings.symmetric(vertical: 8, horizontal: 8), border: Border.all(color: Colors.grey.shade300, strokeAlign: 0.1)),
        "td": Style(padding: HtmlPaddings.symmetric(vertical: 8, horizontal: 8), border: Border.all(color: Colors.grey.shade300, strokeAlign: 0.1)),
        "body": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize(17),
            lineHeight: const LineHeight(1.7),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'Open Sans'),
        "p,h1,h2,h3,h4,h5,h6,figcaption": Style(margin: Margins.all(textPadding ?? 20.0)),
        "figure": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      },
      extensions: [
        const TableHtmlExtension(),
        const SvgHtmlExtension(),
        const AudioHtmlExtension(),
        TagExtension(
          tagsToExtend: {"blockquote"},
          builder: (ExtensionContext eContext) {
            if (configs.socialEmbedPostsEnabled) {
              if (eContext.classes.contains('twitter-tweet')) {
                return SocialEmbed(data: eContext.innerHtml, embedPlatform: 'twitter');
              } else if (eContext.classes.contains('instagram-media')) {
                return SocialEmbed(data: eContext.element!.outerHtml, embedPlatform: 'instagram');
              } else if (eContext.classes.contains('wp-block-quote')) {
                return QuoteWidget(data: eContext.innerHtml);
              } else {
                return SocialEmbed(data: eContext.innerHtml, embedPlatform: null);
              }
            } else {
              return Container();
            }
          },
        ),
        TagExtension(
          tagsToExtend: {"iframe"},
          builder: (ExtensionContext eContext) {
            final String source = eContext.attributes['src'].toString();
            if (isIframeVideoEnabled == false) return Container();
            if (source.contains('youtu')) {
              return VideoPlayerWidget(videoUrl: source, videoType: 'youtube');
            } else if (source.contains('vimeo')) {
              final String videoId = AppService.getVimeoId(source);
              return VideoPlayerWidget(videoUrl: videoId, videoType: 'vimeo');
            } else if (configs.socialEmbedPostsEnabled && source.contains('facebook.com')) {
              return SocialEmbed(data: source, embedPlatform: 'facebook');
            }
            return Container();
          },
        ),
        TagExtension(
          tagsToExtend: {"video"},
          builder: (ExtensionContext eContext) {
            final String videoSource = eContext.attributes['src'].toString();
            if (isVideoEnabled == false) return Container();
            return VideoPlayerWidget(videoUrl: videoSource, videoType: 'network');
          },
        ),
        TagExtension(
          tagsToExtend: {"img"},
          builder: (ExtensionContext eContext) {
            String imageUrl = eContext.attributes['src'].toString();
            if (isimageEnabled == false) return Container();
            return InkWell(
                onTap: () => nextScreenPopupiOS(context, FullScreenImage(imageUrl: imageUrl)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => const LoadingIndicatorWidget(),
                ));
          },
        ),
        TagExtension(
          tagsToExtend: {"code"},
          builder: (ExtensionContext eContext) {
            return CodePreview(
              data: eContext.innerHtml,
            );
          },
        ),
        // TagExtension(
        //     tagsToExtend: {"pre"},
        //     builder: (extensionContext) {
        //       return Math.tex(
        //         extensionContext.innerHtml,
        //         mathStyle: MathStyle.display,
        //         textStyle: extensionContext.styledElement?.style.generateTextStyle(),
        //         onErrorFallback: (FlutterMathException e) {
        //           //optionally try and correct the Tex string here
        //           return Text("<tex>i\hbar\frac{\partial}{\partial t}\Psi(\vec x,t) = -\frac{\hbar}{2m}\nabla^2\Psi(\vec x,t)+ V(\vec x)\Psi(\vec x,t)</tex>");
        //         },
        //       );
        //     }),
      ],
    );
  }
}

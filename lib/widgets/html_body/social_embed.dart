import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';

class SocialEmbed extends StatefulWidget {
  const SocialEmbed({super.key, required this.data, this.embedPlatform});
  final String data;
  final String? embedPlatform;

  @override
  State<SocialEmbed> createState() => _SocialEmbedState();
}

class _SocialEmbedState extends State<SocialEmbed> {
  late WebViewController controller;
  double height = 0.0;
  bool loaded = false;

  String _getEmbedData(String? platform, String data) {
    final bool isDarkMode = context.read<ThemeBloc>().darkTheme ?? false;
    if (platform == null) {
      return _othersEmbed(data);
    } else if (platform == 'facebook') {
      return _facebookEmbed(data);
    } else if (platform == 'twitter') {
      return _twitterEmbed(data, isDarkMode);
    } else if (platform == 'instagram'){
      return _instagramEmbed(data);
    } else {
      return _othersEmbed(data);
    }
  }

  @override
  void initState() {
    super.initState();
    Color bgColor = _getBgColor();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(bgColor)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) async {
        var x =
            await controller.runJavaScriptReturningResult("document.documentElement.scrollHeight");
        double h = double.tryParse(x.toString()) ?? 700;
        height = h;
        debugPrint(h.toString());
        loaded = true;
        setState(() {});
      }))
      ..loadRequest(Uri.dataFromString(
        _getEmbedData(widget.embedPlatform, widget.data),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  // static String? getLinksFromString(String text) {
  //   RegExp regex = RegExp(r'<a href="([^"]+)">[^<]+<\/a>');
  //   Iterable<Match> matches = regex.allMatches(text);

  //   if (matches.isNotEmpty) {
  //     Match lastMatch = matches.last;
  //     String? lastLink = lastMatch.group(1);
  //     return lastLink;
  //   } else {
  //     debugPrint('no links');
  //   }
  //   return null;
  // }

  static String? getLinksFromString(String text) {
    RegExp regex = RegExp(r'href="([^"]+)"');
    Iterable<Match> matches = regex.allMatches(text);

    if (matches.isNotEmpty) {
      Match lastMatch = matches.last;
      String? lastLink = lastMatch.group(1);
      return lastLink;
    } else {
      debugPrint('no links');
    }
    return null;
  }

  Color _getBgColor (){
    final bool isDarkMode = context.read<ThemeBloc>().darkTheme ?? false;
    if(isDarkMode){
      return const Color(0xff303030);
    }else{
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const Center(
            child: LoadingIndicatorWidget(),
          )
        : InkWell(
            onTap: () {
              final link = getLinksFromString(widget.data);
              if (link != null) {
                AppService().openLink(context, link);
              }
            },
            child: IgnorePointer(
              child: SizedBox(
                height: height,
                child: WebViewWidget(controller: controller),
              ),
            ),
          );
  }



  String _twitterEmbed(String source, bool isDarkMode) {
    final String theme = isDarkMode ? "dark" : "light";
    return """<!DOCTYPE html>
        
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 0; padding: 0;'>
        <div>
        <blockquote class="twitter-tweet" data-theme=$theme>
          $source
        </blockquote> 
        <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
          
        </div>
      </body>
    </html>""";
  }



  static String _facebookEmbed(String source) {
    return """<!DOCTYPE html>
        
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 0; padding: 0;'>
        <div>
        <blockquote>
        <iframe src="$source" width="device-width" height="450" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
        </blockquote> 
          
        </div>
      </body>
    </html>""";
  }



  static String _othersEmbed(String source) {
    return """<!DOCTYPE html>
        
    <html>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width, viewport-fit=cover">
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 0; padding: 0;'>
        <div>
          $source
        </div>
      </body>
    </html>""";
  }



  static String _instagramEmbed(String source) {
    return """ <!doctype html>
    <html lang="en">

    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width">
    </head>

    <body>
      $source
      <script async src="https://www.instagram.com/embed.js"></script>
    </body>

    </html>""";
  }
}

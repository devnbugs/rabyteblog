import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:last_pod_player/last_pod_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key,
      required this.videoUrl,
      required this.videoType,
      this.thumbnailUrl})
     ;
  final String videoUrl;
  final String videoType;
  final String? thumbnailUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: widget.videoType == 'network'
            ? PlayVideoFrom.network(widget.videoUrl)
            : widget.videoType == 'vimeo'
                ? PlayVideoFrom.vimeo(widget.videoUrl)
                : PlayVideoFrom.youtube(widget.videoUrl),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ))
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
        controller: controller,
        alwaysShowProgressBar: true,
        videoThumbnail: widget.thumbnailUrl == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(widget.thumbnailUrl!)));
  }
}
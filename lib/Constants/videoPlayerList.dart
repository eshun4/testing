// ignore_for_file: file_names

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class CustomPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  late VideoPlayerController videoPlayerController;
  CustomVideoPlayerController customVideoPlayerController =
      CustomVideoPlayerController();

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomVideoPlayer(
      customVideoPlayerController: customVideoPlayerController,
      videoPlayerController: videoPlayerController,
      customVideoPlayerSettings: CustomVideoPlayerSettings(
          exitFullscreenOnEnd: true,
          enterFullscreenOnStart: true,
          showPlayButton: true,
          controlBarAvailable: true),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  final double height;
  final bool autoPlay;
  final bool mute;
  final bool showControls;
  final bool showFullscreenButton;
  final bool loop;

  const VideoScreen({
    super.key,
    required this.videoId,
    this.height = 200,
    this.autoPlay = true,
    this.mute = false,
    this.showControls = true,
    this.showFullscreenButton = true,
    this.loop = true,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: widget.mute,
        showControls: widget.showControls,
        showFullscreenButton: widget.showFullscreenButton,
        enableCaption: false,
        enableKeyboard: false,
        enableJavaScript: true,
        playsInline: false,
        showVideoAnnotations: false,
        strictRelatedVideos: true,
      ),
    )..loadVideoById(videoId: widget.videoId);

    // Listen to player state changes
    _controller.listen((event) {
      if (event.playerState == PlayerState.ended) {
        _controller.loadVideoById(videoId: widget.videoId); // manually restart
      }
    });
  }

  @override
  void didUpdateWidget(VideoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _controller.loadVideoById(videoId: widget.videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        child: YoutubePlayerScaffold(
          controller: _controller,
          builder: (context, player) {
            return SizedBox(height: widget.height.h, child: player);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

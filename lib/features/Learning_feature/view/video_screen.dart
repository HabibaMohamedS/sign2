import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;

  const VideoScreen({
    super.key,
    required this.videoId,
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

  @override
  void didUpdateWidget(VideoScreen oldWidget) {
    if (oldWidget.videoId != widget.videoId) {
      _controller.loadVideoById(videoId: widget.videoId);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initializeController() {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
       // autoPlay: false,
      ),
    )..loadVideoById(videoId: widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return   Container(
                width: double.infinity,
                height: 200.h,
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
        return SizedBox(
          height: 200.h, // Adjust as needed
          child: player,
        );}
                ),
              ),);
      }
   
  

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
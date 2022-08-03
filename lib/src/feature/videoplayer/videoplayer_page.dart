import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videoapp/src/feature/videopicker/bloc/videopicker_bloc.dart';
import 'package:videoapp/src/feature/videopicker/widget/scope/videopicker_scope.dart';
import 'package:videoapp/src/feature/videoplayer/model/video_model.dart';

class VideoViewPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoViewPage({Key? key, required this.videoModel}) : super(key: key);
  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _videoPlayerController;

  Future<void> _initVideoPlayer() async {
    if (widget.videoModel.file != null) {
      _videoPlayerController =
          VideoPlayerController.file(widget.videoModel.file!);
      await _videoPlayerController.initialize();
      await _videoPlayerController.setLooping(true);
      await _videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initVideoPlayer();
    super.initState();
  }

  Future<void> _deleteCurrVideo() async {
    try {
      await PhotoManager.editor.deleteWithIds([widget.videoModel.id]);
      context.router.pop(true);
    } on Object catch (e) {
      context.router.pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
          elevation: 0,
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteCurrVideo,
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: VideoPlayer(_videoPlayerController),
      );
}

import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videoapp/src/core/router/app_router.dart';
import 'package:videoapp/src/feature/videopicker/bloc/videopicker_bloc.dart';
import 'package:videoapp/src/feature/videopicker/widget/scope/videopicker_scope.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Preview'),
          elevation: 0,
          backgroundColor: Colors.black26,
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => context.router.pop(),
            )
          ],
        ),
        body: VideopickerScope(
          child: BlocBuilder<VideopickerBloc, VideopickerState>(
            builder: (context, state) => state.when(
              idle: (data) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: data.videos.length,
                itemBuilder: (context, index) => data.videos[index].file != null
                    ? FutureBuilder<Uint8List?>(
                        future: VideoThumbnail.thumbnailData(
                          video: data.videos[index].file?.path ?? 'error',
                          imageFormat: ImageFormat.JPEG,
                          maxWidth: 128,
                          quality: 25,
                        ),
                        builder: (context, snapshot) => snapshot.hasData
                            ? GestureDetector(
                                onTap: () async {
                                  final isDeleted =
                                      await context.router.push<bool>(
                                    VideoViewRoute(
                                      videoModel: data.videos[index],
                                    ),
                                  );
                                  if (isDeleted ?? false) {
                                    VideopickerScope.reload(context);
                                  }
                                },
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : snapshot.hasError
                                ? const Text('Error')
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      )
                    : const SizedBox(),
              ),
              loading: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => const Center(
                child: Text('errror'),
              ),
            ),
          ),
        ),
      );
}

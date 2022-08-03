import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/src/feature/home/home_page.dart';
import 'package:videoapp/src/feature/videoplayer/model/video_model.dart';
import 'package:videoapp/src/feature/videoplayer/video_page.dart';
import 'package:videoapp/src/feature/videoplayer/videoplayer_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute<void>(
      path: '/home',
      page: HomePage,
      initial: true,
    ),
    AutoRoute<void>(
      fullscreenDialog: true,
      path: '/videoplayer',
      page: VideoPage,
    ),
    AutoRoute<bool>(
      fullscreenDialog: true,
      path: '/videoplayerview',
      page: VideoViewPage,
    )
  ],
)
class AppRouter extends _$AppRouter {}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Placeholder page'),
        ),
      );
}

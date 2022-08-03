import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:videoapp/src/core/widget/bloc_scope.dart';
import 'package:videoapp/src/feature/videopicker/bloc/videopicker_bloc.dart';
import 'package:videoapp/src/feature/videoplayer/model/video_model.dart';

List<VideoModel> _entities(VideopickerState state) => state.data.videos;

class VideopickerScope extends StatelessWidget {
  static const BlocScope<VideopickerEvent, VideopickerState, VideopickerBloc>
      _scope = BlocScope();

  final Widget child;

  const VideopickerScope({
    required this.child,
    Key? key,
  }) : super(key: key);

  // --- Data --- //

  // static ScopeData<ThemeMode> get themeModeOf =>
  //     _themeToThemeMode.dot(_theme).pipe(_scope.select);

  static ScopeData<List<VideoModel>> get entities => _scope.select(_entities);

  // --- Methods --- //

  static NullaryScopeMethod get reload => _scope.nullary(
        (context) => const VideopickerEvent.reload(),
      );

  // --- Build --- //

  @override
  Widget build(BuildContext context) => BlocProvider<VideopickerBloc>(
        create: (context) =>
            VideopickerBloc()..add(const VideopickerEvent.reload()),
        child: child,
      );
}

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoapp/src/core/extension/src/build_context.dart';
import 'package:videoapp/src/core/model/dependencies_storage.dart';
import 'package:videoapp/src/core/router/app_router.dart';
import 'package:videoapp/src/core/widget/dependencies_scope.dart';
import 'package:videoapp/src/feature/home/bloc/camera_bloc.dart';
import 'package:videoapp/src/feature/home/utils/camera_utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData _getRecordIcon(bool isRecord) =>
      isRecord ? Icons.stop : Icons.circle;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => CameraBloc(
          CameraUtils(),
        )..add(const CameraEvent.initialized()),
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) => Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (state.controller == null)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (state.controller != null) CameraPreview(state.controller!),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: FloatingActionButton(
                    heroTag: 'record',
                    backgroundColor: Colors.red,
                    onPressed: () => state.isRecording
                        ? BlocProvider.of<CameraBloc>(context)
                            .add(const CameraEvent.stopped())
                        : BlocProvider.of<CameraBloc>(context)
                            .add(const CameraEvent.recorded()),
                    child: Icon(_getRecordIcon(state.isRecording)),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: FloatingActionButton(
                      heroTag: 'flip',
                      backgroundColor: Colors.white,
                      onPressed: () => state.isRecording
                          ? BlocProvider.of<CameraBloc>(context)
                              .add(const CameraEvent.flipCameraWithRecording())
                          : BlocProvider.of<CameraBloc>(context)
                              .add(const CameraEvent.flipCamera()),
                      child: const Icon(Icons.camera_front),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: FloatingActionButton(
                      heroTag: 'gallery',
                      backgroundColor: Colors.white,
                      onPressed: () => context.router.pushNamed('/videoplayer'),
                      child: const Icon(Icons.browse_gallery),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

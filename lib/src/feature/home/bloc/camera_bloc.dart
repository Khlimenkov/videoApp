import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:videoapp/src/feature/home/utils/camera_utils.dart';

part 'camera_bloc.freezed.dart';
part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final List<XFile> _videos = [];
  final CameraUtils cameraUtils;
  final ResolutionPreset resolutionPreset;
  final CameraLensDirection cameraLensDirection;

  CameraBloc(
    this.cameraUtils, {
    this.resolutionPreset = ResolutionPreset.high,
    this.cameraLensDirection = CameraLensDirection.back,
  }) : super(const CameraState.initial()) {
    on<CameraEvent>(
      (event, emit) => event.map<Future<void>>(
          initialized: (event) => _initializeCamera(event, emit),
          recorded: (event) => _recordedCamera(event, emit),
          stopped: (event) => _stopRecord(event, emit),
          flipCamera: (event) => _flipCamera(event, emit),
          flipCameraWithRecording: (event) =>
              _flipCameraWithRecording(event, emit)),
    );
  }
  late CameraController _controller;

  bool get isInitialized => _controller.value.isInitialized;
  Future<void> _initializeCamera(
    _Initialized event,
    Emitter<CameraState> emit,
  ) async {
    try {
      _controller = await cameraUtils.getCameraController(
          resolutionPreset, cameraLensDirection);
      await _controller.initialize();
      emit(CameraState.cameraReady(_controller));
    } on CameraException catch (error) {
      await _controller.dispose();
      emit(CameraState.cameraFailure(error: error.description ?? 'Error'));
    } on Object catch (error) {
      emit(CameraState.cameraFailure(error: error.toString()));
    }
  }

  Future<void> _recordedCamera(
      _Recorded event, Emitter<CameraState> emit) async {
    emit(CameraState.cameraRecordInProgress(_controller));
    try {
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
    } on CameraException catch (error) {
      emit(CameraState.cameraRecordFailure(_controller));
    }
  }

  Future<void> _stopRecord(_Stopped event, Emitter<CameraState> emit) async {
    try {
      if (_videos.isEmpty) {
        final file = await _controller.stopVideoRecording();
        final isSaved = await GallerySaver.saveVideo(file.path);
        if (isSaved ?? false) {
          emit(CameraState.cameraRecordSuccess(_controller));
        } else {
          emit(CameraState.cameraRecordFailure(_controller));
        }
      } else {
        final file = await _controller.stopVideoRecording();
        _videos.add(file);
        final paths = _videos.map((e) => e.path).toList();
        final path = await _videoMerger(paths);
        final isSaved = await GallerySaver.saveVideo(path);
        _videos.clear();
        if (isSaved ?? false) {
          emit(CameraState.cameraRecordSuccess(_controller));
        } else {
          emit(CameraState.cameraRecordFailure(_controller));
        }
      }
    } on CameraException catch (error) {
      emit(CameraState.cameraRecordFailure(_controller));
    }
  }

  Future<void> _flipCamera(_FlipCamera event, Emitter<CameraState> emit) async {
    try {
      final currentDirection = _controller.description.lensDirection;
      await _controller.dispose();
      _controller = await cameraUtils.getCameraController(
          resolutionPreset,
          currentDirection == CameraLensDirection.back
              ? CameraLensDirection.front
              : CameraLensDirection.back);
      await _controller.initialize();
      emit(CameraState.cameraReady(_controller));
    } on CameraException catch (error) {
      emit(CameraState.cameraFailure(error: error.description ?? 'Error'));
    }
  }

  Future<void> _flipCameraWithRecording(
      _FlipCameraWithRecording event, Emitter<CameraState> emit) async {
    try {
      final file = await _controller.stopVideoRecording();
      _videos.add(file);
      final currentDirection = _controller.description.lensDirection;
      _controller = await cameraUtils.getCameraController(
          resolutionPreset,
          currentDirection == CameraLensDirection.back
              ? CameraLensDirection.front
              : CameraLensDirection.back);
      await _controller.initialize();
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
      emit(CameraState.cameraRecordInProgress(_controller));
    } on CameraException catch (error) {
      emit(CameraState.cameraFailure(error: error.description ?? 'Error'));
    }
  }

  Future<String> _videoMerger(List<String> paths) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final rawDocumentPath = appDir.path;
    final outputPath = '$rawDocumentPath/output.mp4';
    final pathVal = paths.join(' -i ');
    final streams = <String>[];
    for (var i = 0; i < paths.length; i++) {
      streams.add('[$i:v][$i:a]');
    }
    final commandToExecute =
        "-y -i $pathVal -filter_complex '${streams.join()} concat=n=${paths.length}:v=1:a=1 [vv] [aa]' -map '[vv]' -map '[aa]' -r 65535 $outputPath";
    await FFmpegKit.execute(commandToExecute);

    return outputPath;
  }
}

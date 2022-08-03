part of 'camera_bloc.dart';

@freezed
class CameraEvent with _$CameraEvent {
  const factory CameraEvent.initialized() = _Initialized;
  const factory CameraEvent.stopped() = _Stopped;
  const factory CameraEvent.recorded() = _Recorded;
  const factory CameraEvent.flipCamera() = _FlipCamera;
  const factory CameraEvent.flipCameraWithRecording() =
      _FlipCameraWithRecording;
}

part of 'camera_bloc.dart';

@freezed
class CameraState with _$CameraState {
  const CameraState._();
  const factory CameraState.initial() = _Initial;
  const factory CameraState.cameraReady(CameraController controller) =
      _CameraReady;
  const factory CameraState.cameraFailure({required String error}) =
      _CameraFailure;
  const factory CameraState.cameraRecordInProgress(
    CameraController controller,
  ) = _CameraRecordInProgress;
  const factory CameraState.cameraRecordSuccess(
    CameraController controller,
  ) = _CameraRecordSuccess;
  const factory CameraState.cameraRecordFailure(
    CameraController controller,
  ) = _CameraRecordFailure;

  CameraController? get controller => when<CameraController?>(
        cameraFailure: (String error) => null,
        cameraReady: (CameraController controller) => controller,
        cameraRecordFailure: (CameraController controller) => controller,
        cameraRecordInProgress: (CameraController controller) => controller,
        cameraRecordSuccess: (CameraController controller) => controller,
        initial: () => null,
      );

  bool get isRecording => map<bool>(
        cameraFailure: (_) => false,
        cameraReady: (_) => false,
        cameraRecordFailure: (_) => false,
        cameraRecordInProgress: (_) => true,
        cameraRecordSuccess: (_) => false,
        initial: (_) => false,
      );
}

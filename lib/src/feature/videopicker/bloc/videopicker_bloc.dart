import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_bloc/stream_bloc.dart';
import 'package:sum/sum.dart';
import 'package:videoapp/src/feature/videoplayer/model/video_model.dart';

part 'videopicker_bloc.freezed.dart';

// --- States --- //

@freezed
class VideopickerData with _$VideopickerData {
  const factory VideopickerData({
    required List<VideoModel> videos,
  }) = _VideopickerData;
}

typedef VideopickerState = PersistentAsyncData<String, VideopickerData>;

// --- Events --- //

@freezed
class VideopickerEvent with _$VideopickerEvent {
  const factory VideopickerEvent.reload() = _VideopickerEventSetTheme;
}

// --- BLoC --- //

class VideopickerBloc extends StreamBloc<VideopickerEvent, VideopickerState> {
  VideopickerBloc() : super(_initialState());

  static VideopickerState _initialState() => const VideopickerState.loading(
        data: VideopickerData(
          videos: <VideoModel>[],
        ),
      );

  Stream<VideopickerState> _performMutation(
    Future<VideopickerData> Function() body,
  ) async* {
    yield state.toLoading();
    try {
      final newData = await body();
      yield VideopickerState.idle(data: newData);
    } on Object catch (e) {
      yield state.toError(error: e.toString());
      rethrow;
    } finally {
      yield state.toIdle();
    }
  }

  Stream<VideopickerState> _setAssets() => _performMutation(() async {
        final paths = await PhotoManager.getAssetPathList(
          type: RequestType.video,
          onlyAll: true,
        );
        final entities = <AssetEntity>[];
        for (final path in paths) {
          final entityList = await path.getAssetListPaged(
            page: 0,
            size: path.assetCount,
          );
          entities.addAll(entityList);
        }
        final files = await Future.wait(
          entities.map(
              (e) async => VideoModel(e.id, file: await e.fileWithSubtype)),
        );

        return state.data.copyWith(videos: files);
      });

  @override
  Stream<VideopickerState> mapEventToStates(VideopickerEvent event) =>
      event.when(reload: _setAssets);
}

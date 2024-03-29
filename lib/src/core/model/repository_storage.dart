import 'package:shared_preferences/shared_preferences.dart';
import 'package:videoapp/src/core/database/drift/app_database.dart';
import 'package:videoapp/src/feature/settings/database/settings_dao.dart';
import 'package:videoapp/src/feature/settings/repository/settings_repository.dart';

abstract class IRepositoryStorage {
  ISettingsRepository get settings;
}

class RepositoryStorage implements IRepositoryStorage {
  final AppDatabase _appDatabase;
  final SharedPreferences _sharedPreferences;

  RepositoryStorage({
    required AppDatabase appDatabase,
    required SharedPreferences sharedPreferences,
  })  : _appDatabase = appDatabase,
        _sharedPreferences = sharedPreferences;

  @override
  ISettingsRepository get settings => SettingsRepository(
        settingsDao: SettingsDao(_sharedPreferences),
      );
}

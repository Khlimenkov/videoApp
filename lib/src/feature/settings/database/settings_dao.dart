import 'package:shared_preferences/shared_preferences.dart';
import 'package:videoapp/src/core/database/shared_preferences/shared_preferences_dao.dart';

abstract class ISettingsDao {
  String? get themeMode;
  Future<void> setThemeMode(String value);
}

class SettingsDao extends SharedPreferencesDao implements ISettingsDao {
  SettingsDao(SharedPreferences sharedPreferences) : super(sharedPreferences);

  String get _isThemeLightKey => key('is_theme_light');

  @override
  String? get themeMode => getString(_isThemeLightKey);

  @override
  Future<void> setThemeMode(String value) => setString(_isThemeLightKey, value);
}

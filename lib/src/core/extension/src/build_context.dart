import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videoapp/src/core/database/drift/app_database.dart';
import 'package:videoapp/src/core/model/dependencies_storage.dart';
import 'package:videoapp/src/core/model/repository_storage.dart';
import 'package:videoapp/src/core/widget/dependencies_scope.dart';
import 'package:videoapp/src/core/widget/repository_scope.dart';

extension BuildContextX on BuildContext {
  IDependenciesStorage get dependencies => DependenciesScope.of(this);
  Dio get dio => dependencies.dio;
  AppDatabase get database => dependencies.database;
  SharedPreferences get sharedPreferences => dependencies.sharedPreferences;

  IRepositoryStorage get repository => RepositoryScope.of(this);

  AppLocalizations get localized => AppLocalizations.of(this)!;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}

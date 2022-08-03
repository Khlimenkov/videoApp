import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videoapp/src/core/model/dependencies_storage.dart';
import 'package:videoapp/src/core/model/repository_storage.dart';
import 'package:videoapp/src/core/widget/dependencies_scope.dart';
import 'package:videoapp/src/core/widget/repository_scope.dart';
import 'package:videoapp/src/feature/app/logic/sentry_init.dart';
import 'package:videoapp/src/feature/app/widget/app_configuration.dart';
import 'package:videoapp/src/feature/app/widget/app_lifecycle_scope.dart';
import 'package:videoapp/src/feature/settings/widget/scope/settings_scope.dart';

class AppStarter extends StatelessWidget {
  final SentrySubscription sentrySubscription;
  final SharedPreferences sharedPreferences;

  const AppStarter({
    Key? key,
    required this.sentrySubscription,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppLifecycleScope(
        sentrySubscription: sentrySubscription,
        child: DependenciesScope(
          create: (context) => DependenciesStorage(
            databaseName: 'videoapp_database',
            sharedPreferences: sharedPreferences,
          ),
          child: RepositoryScope(
            create: (context) => RepositoryStorage(
              appDatabase: DependenciesScope.of(context).database,
              sharedPreferences: sharedPreferences,
            ),
            child: const SettingsScope(
              child: AppConfiguration(),
            ),
          ),
        ),
      );
}

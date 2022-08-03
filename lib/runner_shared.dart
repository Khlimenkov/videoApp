import 'package:videoapp/src/feature/app/logic/main_runner.dart';
import 'package:videoapp/src/feature/app/model/async_app_dependencies.dart';
import 'package:videoapp/src/feature/app/app_starter.dart';

Future<void> run() => MainRunner.run<AsyncAppDependencies>(
      asyncDependencies: AsyncAppDependencies.obtain,
      appBuilder: (sentrySubscription, dependencies) => AppStarter(
        sentrySubscription: sentrySubscription,
        sharedPreferences: dependencies.sharedPreferences,
      ),
    );

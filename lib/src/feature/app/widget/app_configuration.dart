import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.g.dart';
import 'package:videoapp/src/core/extension/extensions.dart';
import 'package:videoapp/src/core/router/app_router.dart';
import 'package:videoapp/src/feature/app/widget/app_router_builder.dart';
import 'package:videoapp/src/feature/settings/widget/scope/settings_scope.dart';

class AppConfiguration extends StatelessWidget {
  const AppConfiguration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppRouterBuilder(
        createRouter: (context) => AppRouter(),
        builder: (context, parser, delegate) => MaterialApp.router(
          routeInformationParser: parser,
          routerDelegate: delegate,
          onGenerateTitle: (context) => context.localized.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: SettingsScope.themeModeOf(context),
        ),
      );
}

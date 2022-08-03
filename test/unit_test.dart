// ignore_for_file: unnecessary_lambdas, prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:test/test.dart';
import 'package:videoapp/runner_stub.dart' as runner_stub;
import 'package:videoapp/src/core/error/parsing_exception.dart';
import 'package:videoapp/src/core/error/unknown_host_platform_error.dart';
import 'package:videoapp/src/core/router/app_router.dart';

void main() {
  group('Smoke unit test', () {
    test('placeholder', () {
      expectLater(runner_stub.run, throwsA(isA<UnknownHostPlatformError>()));
      expect(() => PlaceholderPage(), returnsNormally);
      expect(PlaceholderPage(), isA<Widget>());
      expect(PlaceholderPage().key, equals(PlaceholderPage().key));
      expect(
        PlaceholderPage(
          key: ValueKey<String>('key'),
        ).key,
        isNot(equals(PlaceholderPage().key)),
      );
      expect(
        PlaceholderPage().runtimeType,
        same(PlaceholderPage().runtimeType),
      );
      expect(ParsingException<int, String>(0).toString(), isA<String>());
      expect(() => ParsingException<int, String>(0), returnsNormally);
    });
  });
}

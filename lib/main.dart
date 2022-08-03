// ignore: unused_import
import 'package:videoapp/runner_stub.dart'
    if (dart.library.io) 'package:videoapp/runner_io.dart'
    if (dart.library.html) 'package:videoapp/runner_web.dart' as runner;

Future<void> main() => runner.run();

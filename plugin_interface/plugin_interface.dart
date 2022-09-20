import 'package:pigeon/pigeon.dart';

// Stub for Pigeon codegen tool to pick up.
// Run with:
// flutter pub run pigeon \
//   --input plugin_interface/plugin_interface.dart \
//   --dart_out lib/pigeon.dart \
//   --java_out ./android/app/src/main/java/dev/flutter/pigeon/Pigeon.java \
//   --java_package "dev.flutter.pigeon"
@HostApi()
abstract class BatteryApi {
  int getCurrentBatteryLevel();
}

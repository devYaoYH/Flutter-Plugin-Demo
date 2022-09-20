import 'dart:async';

import 'package:flutter/material.dart';

import 'pigeon.dart';

// Page to display camera preview and take photos.
class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  // Page to render the current device battery level.

  final String title = 'Battery Level Plugin';

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  int _batteryLevel = 0;
  late Timer _scheduledPollingTimer;
  late BatteryApi batteryApi;

  Future<void> _getBatteryLevelFuture() async {
    final currentBatteryLevel = await batteryApi.getCurrentBatteryLevel();

    setState(() {
      _batteryLevel = currentBatteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    batteryApi = BatteryApi();

    unawaited(_getBatteryLevelFuture());

    // Poll every 10 seconds thereafter for the current battery level.
    const pollInterval = Duration(seconds: 10);
    _scheduledPollingTimer = Timer.periodic(
      pollInterval,
      (Timer t) => _getBatteryLevelFuture(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Remember to cancel the periodic timer.
    _scheduledPollingTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          "Battery: $_batteryLevel%",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

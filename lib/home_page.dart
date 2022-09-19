import 'package:flutter/material.dart';

import 'routes.dart';

class PluginInfo {
  const PluginInfo(this.title, this.description, {required this.buildRoute});
  final String title;
  final String description;
  final Route Function() buildRoute;
}

const plugins = [
  PluginInfo(
    'Camera',
    'Take a photo with the camera!',
    buildRoute: cameraPageBuilder,
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Widget to render a list of Plugins to demo.

  final String title = 'Flutter Plugins Demo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: SizedBox.expand(
        child: ListView.builder(
          padding: const EdgeInsets.all(4.0),
          itemCount: plugins.length,
          itemBuilder: (context, i) {
            //TODO: Render route to new page.
            return const Text('ListTile');
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

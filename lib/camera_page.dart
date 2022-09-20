import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// Page to display camera preview and take photos.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  final String title = 'Camera Demo';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _hasInitialized = false;
  bool _useFrontCamera = false;
  final List<String> _images = [];
  List<CameraDescription> _cameras = [];
  late Future<void> _initializeControllerFuture;
  late CameraController _cameraController;

  // Takes an image and saves it into temporary storage.
  Future<void> _captureImage() async {
    // Take a picture :)
    try {
      final image = await _cameraController.takePicture();
      setState(() {
        _images.add(image.path);
      });
      print('Taking a photo!');
    } catch (e) {
      print(e);
    }
  }

  // Initialize camera controller for camera selected.
  void _initializeCameraController(CameraDescription camera) {
    // Get a new controller.
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();

    setState(() {
      _hasInitialized = true;
    });
  }

  // Flip camera used.
  Future<void> _flipCamera() async {
    // Check if camera has been initialized yet.
    if (!_hasInitialized) {
      await _setupCamera();
      return;
    }

    // Flip the camera.
    _useFrontCamera = !_useFrontCamera;

    // Initialize Camera Controller.
    _initializeCameraController(
        _useFrontCamera ? _cameras.last : _cameras.first);
  }

  // Initialize camera controller.
  Future<void> _setupCamera() async {
    // Get list of cameras.
    _cameras = await availableCameras();

    // Initialize Camera Controller.
    _initializeCameraController(
        _useFrontCamera ? _cameras.last : _cameras.first);
  }

  @override
  void initState() {
    super.initState();

    // Call the function to asynchronously setup camera controller.
    unawaited(_setupCamera());
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  // Builds the widget holding a preview of the camera.
  Widget _cameraPreviewBuilder() {
    if (!_hasInitialized) {
      return const Text('<camera preview placeholder>');
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_cameraController);
        } else {
          // Otherwise, display a loading indicator.
          return const Text('<camera preview placeholder>');
        }
      },
    );
  }

  // Attempts to read a given file path to display in Image widget.
  Widget _renderImageFromPath(String imageFilePath) {
    return Image.file(
      File(imageFilePath),
      // Error fallback when the image fails to load.
      errorBuilder: (_, error, __) {
        print(error);
        return const Icon(Icons.error_outline);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgetMaxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Constrain height and width of camera preview widget.
          SizedBox(
            width: widgetMaxWidth,
            height: widgetMaxWidth * 0.7,
            // Add internal padding.
            child: Padding(
              padding: const EdgeInsets.all(16),
              // Clip overflow edges in child widget.
              child: FittedBox(
                fit: BoxFit.fitWidth,
                clipBehavior: Clip.hardEdge,
                // Fixed size for camera preview based on max width.
                // Height will be automatic based on camera aspect ratio.
                child: SizedBox(
                  width: widgetMaxWidth,
                  child: _cameraPreviewBuilder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _images.length,
              itemBuilder: (context, i) {
                // Renders the file path and displays image thumbnail.
                return ListTile(
                  title: Text(_images[i]),
                  leading: _renderImageFromPath(_images[i]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: _captureImage,
                tooltip: 'Take Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: _flipCamera,
                tooltip: 'Flip Camera',
                child: const Icon(Icons.flip),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

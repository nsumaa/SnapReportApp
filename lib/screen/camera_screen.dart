import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';


List<File> capturedImages = [];

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _initializeControllerFuture = _controller!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera init error: $e')));
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        capturedImages.add(File(image.path));
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Capture error: $e')));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Column(
        children: [
          if (_controller != null)
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: CameraPreview(_controller!));
                } else {
                  return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                }
              },
            )
          else
            const SizedBox(height: 200, child: Center(child: Text('No camera found or permission denied'))),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _takePicture, child: const Text('Capture')),
          const SizedBox(height: 12),
          Text('${capturedImages.length} images captured', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

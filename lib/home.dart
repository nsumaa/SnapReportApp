import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen/camera_screen.dart';
import 'screen/select_images.dart';
import 'screen/reports_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () => _logout(context), icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Open Camera'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Select Images'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectImagesScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('Older Reports'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

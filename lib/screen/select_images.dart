import 'dart:io';
import 'package:flutter/material.dart';
import '/screen/camera_screen.dart';
import '/services/pdf_service.dart';

class SelectImagesScreen extends StatefulWidget {
  const SelectImagesScreen({super.key});

  @override
  State<SelectImagesScreen> createState() => _SelectImagesScreenState();
}

class _SelectImagesScreenState extends State<SelectImagesScreen> {
  final List<TextEditingController> _controllers = [];
  final List<bool> _selected = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  void _syncControllers() {
    _controllers.clear();
    _selected.clear();
    for (int i = 0; i < capturedImages.length; i++) {
      _controllers.add(TextEditingController());
      _selected.add(true); 
    }
  }

  void _deleteImage(int index) {
    setState(() {
      capturedImages.removeAt(index);
      _controllers.removeAt(index);
      _selected.removeAt(index);
    });
  }

  Future<void> _generatePDF() async {
    final selectedImages = <File>[];
    final descriptions = <String>[];
    for (int i = 0; i < capturedImages.length; i++) {
      if (_selected[i]) {
        selectedImages.add(capturedImages[i]);
        descriptions.add(_controllers[i].text);
      }
    }
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one image')));
      return;
    }
    await PdfService.generateReport(selectedImages, descriptions);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF Generated')));

    setState(() {
      capturedImages.clear();
      _controllers.clear();
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controllers.length != capturedImages.length) _syncControllers();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Images')),
      body: ListView.builder(
        itemCount: capturedImages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.file(capturedImages[index]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllers[index],
                    decoration: const InputDecoration(labelText: 'Enter description', border: OutlineInputBorder()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: _selected[index], onChanged: (v) => setState(() => _selected[index] = v ?? false)),
                        const Text('Include'),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteImage(index)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generatePDF,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

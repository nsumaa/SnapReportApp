import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:share_plus/share_plus.dart';
import 'pdf_viewer_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<String> reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() async {
    final files = await StorageService.listReports();
    if (mounted) setState(() => reports = files);
  }

  void _deleteReport(String path) async {
    await StorageService.deleteReport(path);
    _loadReports();
  }

  void _shareReport(String path) {
    Share.shareXFiles([XFile(path)], text: 'Sharing report');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Older Reports')),
      body: reports.isEmpty
          ? const Center(child: Text('No reports yet'))
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final path = reports[index];
                return ListTile(
                  title: Text(path.split('/').last),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(filePath: path),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _shareReport(path),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReport(path),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

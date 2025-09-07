import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

class PdfService {
  static Future<void> generateReport(
      List<File> images, List<String> descriptions) async {
    final pdf = pw.Document();

    for (int i = 0; i < images.length; i++) {
      final img = pw.MemoryImage(await images[i].readAsBytes());
      final text = descriptions[i];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(
                  img,
                  height: PdfPageFormat.a4.availableHeight *
                      0.6, 
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                text,
                style: pw.TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final outFile =
        File('${dir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await outFile.writeAsBytes(await pdf.save());

    await StorageService.saveReport(outFile.path);
  }
}

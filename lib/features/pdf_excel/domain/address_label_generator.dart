import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/database/database.dart';

class AddressLabelGenerator {
  /// Generate A4 PDF with company address labels in a 3×8 grid (Avery-style).
  Future<Uint8List> generateLabels(List<Company> companies) async {
    final pdf = pw.Document();
    const int cols = 3;
    const int rows = 8;
    const int labelsPerPage = cols * rows;

    // Split companies into pages
    for (var pageStart = 0; pageStart < companies.length; pageStart += labelsPerPage) {
      final pageCompanies = companies.skip(pageStart).take(labelsPerPage).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            return pw.GridView(
              crossAxisCount: cols,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: List.generate(labelsPerPage, (index) {
                if (index < pageCompanies.length) {
                  final company = pageCompanies[index];
                  return pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          company.name,
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                          maxLines: 1,
                        ),
                        if (company.address != null)
                          pw.Text(
                            company.address!,
                            style: const pw.TextStyle(fontSize: 7),
                            maxLines: 2,
                          ),
                        if (company.gstin != null)
                          pw.Text(
                            'GSTIN: ${company.gstin}',
                            style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey700),
                          ),
                      ],
                    ),
                  );
                }
                return pw.Container(); // Empty cell
              }),
            );
          },
        ),
      );
    }

    return pdf.save();
  }
}

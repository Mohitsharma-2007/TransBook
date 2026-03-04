import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class InvoicePreviewDialog extends StatelessWidget {
  final Future<Uint8List> pdfBytesFuture;
  final String title;

  const InvoicePreviewDialog({
    super.key,
    required this.pdfBytesFuture,
    this.title = 'Invoice Preview',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 1000,
        height: 800,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineMedium),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close Preview',
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<Uint8List>(
                future: pdfBytesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text('Failed to load PDF preview: ${snapshot.error}'));
                  }
                  
                  return PdfPreview(
                    build: (format) => snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    allowPrinting: true,
                    allowSharing: true,
                    padding: const EdgeInsets.all(24),
                    pdfFileName: 'Preview.pdf',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

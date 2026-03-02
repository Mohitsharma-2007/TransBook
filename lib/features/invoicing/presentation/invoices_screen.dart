import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../core/constants/app_theme.dart';
import '../../pdf_excel/domain/invoice_pdf_generator.dart';
import '../data/invoice_repository.dart';
import 'new_invoice_screen.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceState = ref.watch(invoiceRepositoryProvider);
    final invoicesStream = invoiceState.watchAllInvoices();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invoices',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewInvoiceScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandPrimary,
                  foregroundColor: AppTheme.surfaceWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppTheme.borderLight),
              ),
              child: StreamBuilder<List<InvoiceWithCompany>>(
                stream: invoicesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final invoices = snapshot.data ?? [];

                  if (invoices.isEmpty) {
                    return const Center(child: Text('No invoices found. Create one to get started.'));
                  }

                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 24,
                    minWidth: 800,
                    columns: const [
                      DataColumn2(label: Text('Invoice No'), size: ColumnSize.M),
                      DataColumn2(label: Text('Date'), size: ColumnSize.S),
                      DataColumn2(label: Text('Company'), size: ColumnSize.L),
                      DataColumn2(label: Text('Total Amount'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('Status'), size: ColumnSize.S),
                      DataColumn2(label: Text('Actions'), size: ColumnSize.S),
                    ],
                    rows: invoices.map((invoiceData) {
                      final inv = invoiceData.invoice;
                      final comp = invoiceData.company;

                      return DataRow(
                        cells: [
                          DataCell(Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(inv.invoiceDate)),
                          DataCell(Text(comp?.name ?? 'Unknown Company')),
                          DataCell(Text(
                            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(inv.totalAmount),
                          )),
                          DataCell(_buildStatusBadge(inv.status)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.print, size: 20, color: AppTheme.textSecondary),
                                  onPressed: () async {
                                    final fullInvoice = await ref.read(invoiceRepositoryProvider).getInvoiceWithRows(inv.id);
                                    if (fullInvoice != null) {
                                      final pdfBytes = await InvoicePdfGenerator.generate(fullInvoice);
                                      await Printing.layoutPdf(
                                        onLayout: (PdfPageFormat format) async => pdfBytes,
                                        name: 'Invoice_${inv.invoiceNumber}',
                                      );
                                    }
                                  },
                                  tooltip: 'Print PDF',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'DRAFT':
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        break;
      case 'SUBMITTED':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'PAID':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

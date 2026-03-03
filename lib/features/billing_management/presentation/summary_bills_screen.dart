import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../../core/constants/app_theme.dart';
import '../data/summary_bill_repository.dart';
import '../../pdf_excel/domain/summary_pdf_generator.dart';
import 'new_summary_bill_screen.dart';

class SummaryBillsScreen extends ConsumerWidget {
  const SummaryBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesStream = ref.watch(summaryBillsProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Summary Bills',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewSummaryBillScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Summary Bill'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandSecondary,
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
                side: const BorderSide(color: AppTheme.borderLight),
              ),
              child: summariesStream.when(
                data: (summaries) {
                  if (summaries.isEmpty) {
                    return const Center(child: Text('No summary bills found.'));
                  }

                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 24,
                    minWidth: 800,
                    columns: const [
                      DataColumn2(label: Text('Summary No'), size: ColumnSize.M),
                      DataColumn2(label: Text('Period From'), size: ColumnSize.S),
                      DataColumn2(label: Text('Period To'), size: ColumnSize.S),
                      DataColumn2(label: Text('Total Amount'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('Status'), size: ColumnSize.S),
                      DataColumn2(label: Text('Actions'), size: ColumnSize.S),
                    ],
                    rows: summaries.map((summary) {
                      return DataRow(
                        cells: [
                          DataCell(Text(summary.summaryNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(summary.periodFrom ?? '-')),
                          DataCell(Text(summary.periodTo ?? '-')),
                          DataCell(Text(
                            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(summary.payableAmount ?? 0),
                          )),
                          DataCell(_buildStatusBadge(summary.status)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.print, size: 20, color: AppTheme.textSecondary),
                                  onPressed: () async {
                                    final repo = ref.read(summaryBillRepositoryProvider);
                                    final fullData = await repo.getSummaryBillWithInvoices(summary.id);
                                    if (fullData != null) {
                                      final pdfBytes = await SummaryPdfGenerator.generate(fullData);
                                      await Printing.layoutPdf(
                                        onLayout: (PdfPageFormat format) async => pdfBytes,
                                        name: 'Summary_${summary.summaryNumber ?? summary.id}',
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
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

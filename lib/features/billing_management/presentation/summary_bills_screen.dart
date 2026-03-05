import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/database/database.dart';
import '../../pdf_excel/domain/summary_pdf_generator.dart';
import '../data/summary_bill_repository.dart';
import 'new_summary_bill_screen.dart';
import '../../invoicing/presentation/invoice_preview_dialog.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../../core/services/file_storage_service.dart';
import '../../pdf_excel/domain/pdf_template_config.dart';

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
              ).animate().fadeIn().slideX(begin: -0.1),
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
              ).animate().fadeIn().slideX(begin: 0.1),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: summariesStream.when(
              data: (List<SummaryBill> summaries) {
                // Calculate metrics
                final totalAmount = summaries.fold(0.0, (sum, i) => sum + (i.payableAmount ?? 0));
                final submittedCount = summaries.where((i) => i.status == 'SUBMITTED').length;
                final paidCount = summaries.where((i) => i.status == 'PAID').length;

                return Column(
                  children: [
                    // Metrics Cards
                    Row(
                      children: [
                        Expanded(child: _MetricCard('Total Billing', NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalAmount), Icons.account_balance_wallet_outlined, AppTheme.brandSecondary).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1)),
                        const SizedBox(width: 16),
                        Expanded(child: _MetricCard('Pending Collection', '$submittedCount Summaries', Icons.pending_actions, AppTheme.statusAcknowledged).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1)),
                        const SizedBox(width: 16),
                        Expanded(child: _MetricCard('Paid', '$paidCount Summaries', Icons.check_circle_outline, AppTheme.statusPaid).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Main Table
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppTheme.borderLight),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildTable(context, ref, summaries),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, WidgetRef ref, List<SummaryBill> summaries) {
    if (summaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_state.png',
              width: 250,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.summarize_outlined, size: 80, color: AppTheme.borderLight),
            ),
            const SizedBox(height: 24),
            Text('No summary bills found.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text('Consolidate your invoices into a summary bill here.', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ).animate().fadeIn(delay: 300.ms).scale(),
      );
    }

    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 16,
      minWidth: 800,
      headingRowHeight: 48,
      dataRowHeight: 48,
      dividerThickness: 1,
      headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
      columns: const [
        DataColumn2(label: Text('Summary No'), size: ColumnSize.M),
        DataColumn2(label: Text('Period From'), size: ColumnSize.S),
        DataColumn2(label: Text('Period To'), size: ColumnSize.S),
        DataColumn2(label: Text('Total Amount'), size: ColumnSize.M, numeric: true),
        DataColumn2(label: Text('Status'), size: ColumnSize.S),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: summaries.map<DataRow>((summary) {
        return DataRow(
          cells: [
            DataCell(Text(summary.summaryNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(summary.periodFrom ?? '-', style: const TextStyle(color: AppTheme.textSecondary))),
            DataCell(Text(summary.periodTo ?? '-', style: const TextStyle(color: AppTheme.textSecondary))),
            DataCell(Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(summary.payableAmount ?? 0),
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textAmount),
            )),
            DataCell(_buildStatusBadge(summary.status)),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print_outlined, size: 20, color: AppTheme.brandSecondary),
                    onPressed: () async {
                      final repo = ref.read(summaryBillRepositoryProvider);
                      final fullData = await repo.getSummaryBillWithInvoices(summary.id);
                      if (fullData != null) {
                        final profile = ref.read(userProfileProvider);
                        final pdfBytesFuture = SummaryPdfGenerator.generate(fullData, profile);

                        // Auto-save the file
                        pdfBytesFuture.then((bytes) async {
                          final file = await ref.read(fileStorageServiceProvider).saveInvoiceFile(
                            fileName: 'Summary_${summary.summaryNumber?.replaceAll('/', '_') ?? summary.id}',
                            bytes: bytes,
                            dateStr: summary.createdAt ?? DateTime.now().toIso8601String(),
                          );
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Summary saved to ${file.path}'),
                                action: SnackBarAction(
                                  label: 'OPEN',
                                  onPressed: () => ref.read(fileStorageServiceProvider).openFile(file.path),
                                ),
                              ),
                            );
                          }
                        });

                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => InvoicePreviewDialog(
                              title: 'Preview Summary ${summary.summaryNumber ?? summary.id}',
                              pdfBytesFuture: pdfBytesFuture,
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Print PDF',
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'DRAFT':
        bgColor = AppTheme.statusBgDraft;
        textColor = AppTheme.statusTextDraft;
        break;
      case 'SUBMITTED':
        bgColor = AppTheme.statusBgSubmitted;
        textColor = AppTheme.statusTextSubmitted;
        break;
      case 'PAID':
        bgColor = AppTheme.statusBgPaid;
        textColor = AppTheme.statusTextPaid;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          letterSpacing: 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

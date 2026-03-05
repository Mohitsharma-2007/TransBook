import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_theme.dart';
import '../../pdf_excel/domain/invoice_pdf_generator.dart';
import '../../pdf_excel/domain/excel_generator.dart';
import '../data/invoice_repository.dart';
import 'email_preview_dialog.dart';
import 'invoice_preview_dialog.dart';
import 'new_invoice_screen.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../../core/services/file_storage_service.dart';
import '../../pdf_excel/domain/pdf_template_config.dart';
import '../../pdf_excel/presentation/template_settings_screen.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  final Set<int> _selectedInvoiceIds = {};

  @override
  Widget build(BuildContext context) {
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
              if (_selectedInvoiceIds.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () async {
                    final invoiceState = ref.read(invoiceRepositoryProvider);
                    final allInvoices = await invoiceState.getAllInvoices();
                    final selectedInvoices = allInvoices
                        .where((i) => _selectedInvoiceIds.contains(i.invoice.id))
                        .toList();
                    
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => EmailPreviewDialog(invoices: selectedInvoices),
                      );
                    }
                  },
                  icon: const Icon(Icons.group_work_outlined),
                  label: Text('Batch Email (${_selectedInvoiceIds.length})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ).animate().fadeIn().scale(),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewInvoiceScreen(),
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
              ).animate().fadeIn().slideX(begin: 0.1),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateSettingsScreen())),
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                label: const Text('Templates'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.brandPrimary,
                  side: BorderSide(color: AppTheme.brandPrimary),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          StreamBuilder<List<InvoiceWithCompany>>(
            stream: invoicesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError) {
                return Expanded(child: Center(child: Text('Error: ${snapshot.error}')));
              }

              final invoices = snapshot.data ?? [];
              
              // Calculate simple metrics
              final totalAmount = invoices.fold(0.0, (sum, i) => sum + i.invoice.totalAmount);
              final pendingCount = invoices.where((i) => i.invoice.status == 'SUBMITTED').length;
              final draftCount = invoices.where((i) => i.invoice.status == 'DRAFT').length;

              return Expanded(
                child: Column(
                  children: [
                    // Metrics Cards
                    Row(
                      children: [
                        Expanded(child: _MetricCard('Total Billed', NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalAmount), Icons.account_balance_wallet, AppTheme.brandSecondary).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1)),
                        const SizedBox(width: 16),
                        Expanded(child: _MetricCard('Pending Collection', '$pendingCount Invoices', Icons.pending_actions, AppTheme.statusAcknowledged).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1)),
                        const SizedBox(width: 16),
                        Expanded(child: _MetricCard('Drafts', '$draftCount Invoices', Icons.drafts, AppTheme.statusDraft).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1)),
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
                          child: _buildTable(context, invoices),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<InvoiceWithCompany> invoices) {
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_state.png',
              width: 250,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.receipt_long_outlined, size: 80, color: AppTheme.borderLight),
            ),
            const SizedBox(height: 24),
            Text('No invoices found.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text('Create your first invoice to get started.', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ).animate().fadeIn(delay: 300.ms).scale(),
      );
    }

    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 16,
      minWidth: 850,
      headingRowHeight: 48,
      dataRowHeight: 48,
      dividerThickness: 1,
      headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
      columns: const [
        DataColumn2(label: Text(''), size: ColumnSize.S, fixedWidth: 48),
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
        final isSelected = _selectedInvoiceIds.contains(inv.id);

        return DataRow(
          selected: isSelected,
          onSelectChanged: (val) {
            setState(() {
              if (val == true) {
                _selectedInvoiceIds.add(inv.id);
              } else {
                _selectedInvoiceIds.remove(inv.id);
              }
            });
          },
          cells: [
            DataCell(Checkbox(
              value: isSelected,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedInvoiceIds.add(inv.id);
                  } else {
                    _selectedInvoiceIds.remove(inv.id);
                  }
                });
              },
            )),
            DataCell(Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(inv.invoiceDate, style: const TextStyle(color: AppTheme.textSecondary))),
            DataCell(Text(comp?.name ?? 'Unknown Company', style: const TextStyle(fontWeight: FontWeight.w500))),
            DataCell(Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(inv.totalAmount),
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textAmount),
            )),
            DataCell(_buildStatusBadge(inv.status)),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print_outlined, size: 20, color: AppTheme.brandSecondary),
                    onPressed: () async {
                      final fullInvoice = await ref.read(invoiceRepositoryProvider).getInvoiceWithRows(inv.id);
                      if (fullInvoice != null) {
                        final profile = ref.read(userProfileProvider);
                        final config = ref.read(pdfTemplateConfigProvider);
                        final pdfBytesFuture = InvoicePdfGenerator.generate(fullInvoice, profile, config: config);
                        
                        // Auto-save the file
                        pdfBytesFuture.then((bytes) async {
                          final file = await ref.read(fileStorageServiceProvider).saveInvoiceFile(
                            fileName: inv.invoiceNumber.replaceAll('/', '_'),
                            bytes: bytes,
                            dateStr: inv.invoiceDate,
                          );
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invoice saved to ${file.path}'),
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
                              title: 'Preview Invoice ${inv.invoiceNumber}',
                              pdfBytesFuture: pdfBytesFuture,
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Print PDF',
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.table_view_outlined, size: 20, color: Colors.green),
                    onPressed: () async {
                      final fullInvoice = await ref.read(invoiceRepositoryProvider).getInvoiceWithRows(inv.id);
                      if (fullInvoice != null) {
                        final excelBytes = await ref.read(excelGeneratorProvider).generateInvoiceExcel(
                          fullInvoice.invoice,
                          fullInvoice.rows,
                        );
                        
                        final file = await ref.read(fileStorageServiceProvider).saveInvoiceFile(
                          fileName: inv.invoiceNumber.replaceAll('/', '_'),
                          bytes: excelBytes,
                          dateStr: inv.invoiceDate,
                          extension: 'xlsx',
                        );
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Excel exported to ${file.path}'),
                              action: SnackBarAction(
                                label: 'OPEN',
                                onPressed: () => ref.read(fileStorageServiceProvider).openFile(file.path),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Export Excel',
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.mail_outline, size: 20, color: AppTheme.statusAcknowledged),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EmailPreviewDialog(invoices: [invoiceData]),
                      );
                    },
                    tooltip: 'Email Invoice',
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.brandPrimary),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewInvoiceScreen(existingInvoiceId: inv.id),
                        ),
                      );
                    },
                    tooltip: 'Edit Invoice',
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.errorColor),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Invoice?'),
                          content: Text('Are you sure you want to delete invoice ${inv.invoiceNumber}?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('DELETE', style: TextStyle(color: AppTheme.errorColor)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          await ref.read(invoiceRepositoryProvider).deleteInvoice(inv.id);
                        } catch (e) {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
                    tooltip: 'Delete Invoice',
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

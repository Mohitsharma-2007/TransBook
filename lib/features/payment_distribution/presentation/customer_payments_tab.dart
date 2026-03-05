import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../data/payment_repository.dart';
import 'record_payment_dialog.dart';

class CustomerPaymentsTab extends ConsumerWidget {
  const CustomerPaymentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(allPaymentsProvider);
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Payments',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const RecordPaymentDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Record Payment'),
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
              child: paymentsAsync.when(
                data: (payments) {
                  if (payments.isEmpty) {
                    return const Center(child: Text('No payments recorded yet.'));
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
                      DataColumn2(label: Text('Date'), size: ColumnSize.S),
                      DataColumn2(label: Text('Invoice ID'), size: ColumnSize.S),
                      DataColumn2(label: Text('Amount'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('TDS Deducted'), size: ColumnSize.S, numeric: true),
                      DataColumn2(label: Text('Mode'), size: ColumnSize.S),
                      DataColumn2(label: Text('Reference'), size: ColumnSize.M),
                    ],
                    rows: payments.map((p) {
                      return DataRow(
                        cells: [
                          DataCell(Text(p.paymentDate ?? '-')),
                          DataCell(Text('INV-${p.invoiceId ?? '-'}', style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(currencyFormat.format(p.amount))),
                          DataCell(Text(currencyFormat.format(p.tdsDeducted))),
                          DataCell(_buildModeBadge(p.paymentMode ?? '-')),
                          DataCell(Text(p.referenceNo ?? '-')),
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

  Widget _buildModeBadge(String mode) {
    Color bgColor;
    switch (mode) {
      case 'NEFT':
        bgColor = Colors.blue.shade100;
        break;
      case 'RTGS':
        bgColor = Colors.purple.shade100;
        break;
      case 'CHEQUE':
        bgColor = Colors.orange.shade100;
        break;
      case 'CASH':
        bgColor = Colors.green.shade100;
        break;
      default:
        bgColor = Colors.grey.shade200;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(mode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

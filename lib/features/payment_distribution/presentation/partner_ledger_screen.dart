import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../data/partner_distribution_repository.dart';
import 'record_partner_payment_dialog.dart';

class PartnerLedgerScreen extends ConsumerWidget {
  const PartnerLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distStream = ref.watch(partnerDistributionRepositoryProvider).watchAllDistributions();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partner Ledger',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
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
              child: StreamBuilder(
                stream: distStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final distributions = snapshot.data ?? [];
                  
                  if (distributions.isEmpty) {
                    return const Center(child: Text('No partner distributions recorded.', style: TextStyle(color: AppTheme.textSecondary)));
                  }

                  return DataTable2(
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    minWidth: 1000,
                    headingRowHeight: 48,
                    dataRowHeight: 48,
                    dividerThickness: 1,
                    headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
                    columns: const [
                      DataColumn2(label: Text('Period'), size: ColumnSize.L),
                      DataColumn2(label: Text('Partner ID'), size: ColumnSize.S),
                      DataColumn2(label: Text('Net Payable'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('Paid Amount'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('Pending'), size: ColumnSize.M, numeric: true),
                      DataColumn2(label: Text('Status'), size: ColumnSize.S),
                      DataColumn2(label: Text('Actions'), fixedWidth: 100),
                    ],
                    rows: distributions.map((d) {
                      final pending = d.netAmount - d.paidAmount;
                      final isFullyPaid = pending <= 1; // Tolerance
                      return DataRow(
                        cells: [
                          DataCell(Text('${d.periodFrom} to ${d.periodTo}')),
                          DataCell(Text('PRT-${d.partnerId ?? "Self"}')),
                          DataCell(Text(currencyFormat.format(d.netAmount))),
                          DataCell(Text(currencyFormat.format(d.paidAmount), style: const TextStyle(color: AppTheme.statusPaid))),
                          DataCell(Text(currencyFormat.format(pending), style: TextStyle(color: pending > 1 ? AppTheme.errorColor : AppTheme.textSecondary))),
                          DataCell(isFullyPaid 
                              ? const Text('PAID', style: TextStyle(color: AppTheme.statusPaid, fontWeight: FontWeight.bold))
                              : const Text('PENDING', style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold))),
                          DataCell(
                            isFullyPaid ? const SizedBox() : IconButton(
                              icon: const Icon(Icons.payment, color: AppTheme.brandSecondary, size: 20),
                              tooltip: 'Record Payment',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => RecordPartnerPaymentDialog(distribution: d),
                                );
                              },
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
}

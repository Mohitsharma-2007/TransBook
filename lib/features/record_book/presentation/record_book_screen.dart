import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/di/database_provider.dart';
import '../../../core/database/database.dart';

class RecordBookScreen extends ConsumerStatefulWidget {
  const RecordBookScreen({super.key});

  @override
  ConsumerState<RecordBookScreen> createState() => _RecordBookScreenState();
}

class _RecordBookScreenState extends ConsumerState<RecordBookScreen> {
  String? _statusFilter;
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Record Book',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  DropdownButton<String?>(
                    value: _statusFilter,
                    hint: const Text('All Status'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...['DRAFT', 'SUBMITTED', 'PAID'].map(
                        (s) => DropdownMenuItem(value: s, child: Text(s)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _statusFilter = v),
                  ),
                ],
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
              child: _buildTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final db = ref.watch(appDatabaseProvider);
    var query = db.select(db.invoices);

    return FutureBuilder<List<Invoice>>(
      future: () {
        if (_statusFilter != null) {
          return (db.select(db.invoices)..where((tbl) => tbl.status.equals(_statusFilter!))).get();
        }
        return db.select(db.invoices).get();
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final invoices = snapshot.data ?? [];
        if (invoices.isEmpty) {
          return const Center(child: Text('No invoices found.'));
        }

        return DataTable2(
          columnSpacing: 12,
          horizontalMargin: 24,
          minWidth: 900,
          columns: const [
            DataColumn2(label: Text('Invoice No'), size: ColumnSize.M),
            DataColumn2(label: Text('Date'), size: ColumnSize.S),
            DataColumn2(label: Text('Amount'), size: ColumnSize.M, numeric: true),
            DataColumn2(label: Text('Received'), size: ColumnSize.S, numeric: true),
            DataColumn2(label: Text('Status'), size: ColumnSize.S),
          ],
          rows: invoices.map((inv) {
            return DataRow(
              cells: [
                DataCell(Text(inv.invoiceNumber ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(inv.invoiceDate ?? '-')),
                DataCell(Text(currencyFormat.format(inv.payableAmount))),
                DataCell(Text(currencyFormat.format(inv.paymentReceived))),
                DataCell(_buildStatusBadge(inv.status)),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    switch (status) {
      case 'DRAFT':
        bgColor = Colors.grey.shade200;
        break;
      case 'SUBMITTED':
        bgColor = Colors.blue.shade100;
        break;
      case 'PAID':
        bgColor = Colors.green.shade100;
        break;
      default:
        bgColor = Colors.grey.shade200;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

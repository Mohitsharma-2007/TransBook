import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../invoicing/data/invoice_repository.dart';
import '../domain/payment_distributor.dart';
import '../data/partner_distribution_repository.dart';
import '../../../../core/database/database.dart' as db;
import 'package:drift/drift.dart' as drift;

class PaymentDistributionScreen extends ConsumerStatefulWidget {
  const PaymentDistributionScreen({super.key});

  @override
  ConsumerState<PaymentDistributionScreen> createState() => _PaymentDistributionScreenState();
}

class _PaymentDistributionScreenState extends ConsumerState<PaymentDistributionScreen> {
  DateTimeRange? _selectedDateRange;
  List<PartnerShare> _distributedShares = [];
  bool _isLoading = false;

  Future<void> _runDistribution() async {
    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a date range first.')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final formatter = DateFormat('yyyy-MM-dd');
      final fromStr = formatter.format(_selectedDateRange!.start);
      final toStr = formatter.format(_selectedDateRange!.end);
      
      final invoiceRepo = ref.read(invoiceRepositoryProvider);
      final invoices = await invoiceRepo.getInvoicesByDateRange(fromStr, toStr);
      final invoiceIds = invoices.map((i) => i.id).toList();
      
      final distributor = ref.read(paymentDistributorProvider);
      final shares = await distributor.distribute(invoiceIds);
      
      setState(() {
        _distributedShares = shares;
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initial = _selectedDateRange ?? DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
    
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.brandSecondary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  void _saveDistribution() async {
    if (_distributedShares.isEmpty || _selectedDateRange == null) return;
    
    setState(() => _isLoading = true);
    try {
      final formatter = DateFormat('yyyy-MM-dd');
      final fromStr = formatter.format(_selectedDateRange!.start);
      final toStr = formatter.format(_selectedDateRange!.end);
      
      final repo = ref.read(partnerDistributionRepositoryProvider);
      
      final distributions = _distributedShares.map((share) {
        return db.PartnerDistributionsCompanion.insert(
          periodFrom: drift.Value(fromStr),
          periodTo: drift.Value(toStr),
          partnerId: drift.Value(share.partnerId),
          trips: drift.Value(share.tripCount),
          freightAmount: drift.Value(share.freightTotal),
          tdsShare: drift.Value(share.tdsShare),
          netAmount: drift.Value(share.netPayable),
          paidAmount: const drift.Value(0.0),
        );
      }).toList();
      
      await repo.saveDistributions(distributions);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Distribution saved successfully!')));
        setState(() {
          _distributedShares = [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final dateFormat = DateFormat('dd MMM yyyy');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partner Payment Distribution',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: _distributedShares.isNotEmpty ? _saveDistribution : null,
                icon: const Icon(Icons.save),
                label: const Text('Save Distribution'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandSecondary,
                  foregroundColor: AppTheme.surfaceWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppTheme.borderLight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDateRange,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Select Date Range for Invoices',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        child: Text(
                          _selectedDateRange == null 
                            ? 'Tap to select range' 
                            : '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _runDistribution,
                    icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.calculate),
                    label: const Text('Run Distribution Engine'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.borderLight),
              ),
              child: _distributedShares.isEmpty && !_isLoading
                  ? const Center(child: Text('Select a date range and run the engine to calculate partner shares.', style: TextStyle(color: AppTheme.textSecondary)))
                  : DataTable2(
                      columnSpacing: 16,
                      horizontalMargin: 16,
                      minWidth: 800,
                      headingRowHeight: 48,
                      dataRowHeight: 48,
                      dividerThickness: 1,
                      headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
                      columns: const [
                        DataColumn2(label: Text('Partner Name'), size: ColumnSize.L),
                        DataColumn2(label: Text('Trips/Vehicles'), size: ColumnSize.S, numeric: true),
                        DataColumn2(label: Text('Total Freight'), size: ColumnSize.M, numeric: true),
                        DataColumn2(label: Text('TDS Share (2%)'), size: ColumnSize.M, numeric: true),
                        DataColumn2(label: Text('Net Payable'), size: ColumnSize.M, numeric: true),
                      ],
                      rows: _distributedShares.map((share) {
                        return DataRow(
                          cells: [
                            DataCell(Text(share.partnerName, style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(share.vehicleCount.toString())),
                            DataCell(Text(currencyFormat.format(share.freightTotal))),
                            DataCell(Text(currencyFormat.format(share.tdsShare), style: const TextStyle(color: AppTheme.errorColor))),
                            DataCell(Text(currencyFormat.format(share.netPayable), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.statusPaid))),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

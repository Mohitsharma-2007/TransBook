import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/amount_in_words.dart';
import '../../master_data/data/company_repository.dart';
import '../../invoicing/data/invoice_repository.dart';
import '../data/summary_bill_repository.dart';

class NewSummaryBillScreen extends ConsumerStatefulWidget {
  const NewSummaryBillScreen({super.key});

  @override
  ConsumerState<NewSummaryBillScreen> createState() => _NewSummaryBillScreenState();
}

class _NewSummaryBillScreenState extends ConsumerState<NewSummaryBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _summaryNoController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  Company? _selectedCompany;
  List<Invoice> _fetchedInvoices = [];
  final Set<int> _selectedInvoiceIds = {};
  bool _isFetching = false;

  double get _selectedTotal =>
      _fetchedInvoices
          .where((inv) => _selectedInvoiceIds.contains(inv.id))
          .fold(0.0, (sum, inv) => sum + (inv.payableAmount));

  @override
  void dispose() {
    _summaryNoController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _fetchInvoices() async {
    if (_selectedCompany == null ||
        _fromDateController.text.isEmpty ||
        _toDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select company and date range first')),
      );
      return;
    }

    setState(() => _isFetching = true);

    final repo = ref.read(invoiceRepositoryProvider);
    final results = await repo.getDraftInvoicesForCompany(
      _selectedCompany!.id,
      _fromDateController.text,
      _toDateController.text,
    );

    setState(() {
      _fetchedInvoices = results;
      _selectedInvoiceIds.clear();
      // Select all by default
      for (final inv in results) {
        _selectedInvoiceIds.add(inv.id);
      }
      _isFetching = false;
    });
  }

  Future<void> _generateSummaryBill() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInvoiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one invoice')),
      );
      return;
    }

    final summaryRepo = ref.read(summaryBillRepositoryProvider);
    final total = _selectedTotal;

    final companion = SummaryBillsCompanion(
      summaryNumber: drift.Value(_summaryNoController.text),
      companyId: drift.Value(_selectedCompany!.id),
      periodFrom: drift.Value(_fromDateController.text),
      periodTo: drift.Value(_toDateController.text),
      totalAmount: drift.Value(total),
      tdsAmount: const drift.Value(0),
      payableAmount: drift.Value(total),
      amountInWords: drift.Value(IndianAmountWords.convert(total)),
      status: const drift.Value('DRAFT'),
      createdAt: drift.Value(DateTime.now().toIso8601String()),
    );

    try {
      await summaryRepo.insertSummaryBill(companion, _selectedInvoiceIds.toList());
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Summary Bill created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Summary Bill'),
        actions: [
          TextButton.icon(
            onPressed: _generateSummaryBill,
            icon: const Icon(Icons.check_circle, color: AppTheme.brandSecondary),
            label: const Text('Generate', style: TextStyle(color: AppTheme.brandSecondary)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: companiesAsync.when(
                              data: (companies) => DropdownButtonFormField<Company>(
                                decoration: const InputDecoration(
                                  labelText: 'Company',
                                  border: OutlineInputBorder(),
                                ),
                                value: _selectedCompany,
                                items: companies.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCompany = val;
                                    _fetchedInvoices = [];
                                    _selectedInvoiceIds.clear();
                                  });
                                },
                                validator: (val) => val == null ? 'Required' : null,
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (e, s) => Text('Error: $e'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _summaryNoController,
                              decoration: const InputDecoration(
                                labelText: 'Summary No',
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fromDateController,
                              decoration: const InputDecoration(
                                labelText: 'Period From (YYYY-MM-DD)',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _toDateController,
                              decoration: const InputDecoration(
                                labelText: 'Period To (YYYY-MM-DD)',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _isFetching ? null : _fetchInvoices,
                            icon: _isFetching
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.search),
                            label: const Text('Fetch Invoices'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Results Section
              if (_fetchedInvoices.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Found ${_fetchedInvoices.length} draft invoice(s)',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedInvoiceIds.length == _fetchedInvoices.length) {
                            _selectedInvoiceIds.clear();
                          } else {
                            _selectedInvoiceIds.clear();
                            for (final inv in _fetchedInvoices) {
                              _selectedInvoiceIds.add(inv.id);
                            }
                          }
                        });
                      },
                      child: Text(
                        _selectedInvoiceIds.length == _fetchedInvoices.length
                            ? 'Deselect All'
                            : 'Select All',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...(_fetchedInvoices.map((inv) {
                  final isSelected = _selectedInvoiceIds.contains(inv.id);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.brandPrimary
                            : AppTheme.borderLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: CheckboxListTile(
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
                      title: Text(
                        inv.invoiceNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Date: ${inv.invoiceDate}  |  Freight: ${currencyFormat.format(inv.totalFreight)}  |  Total: ${currencyFormat.format(inv.payableAmount)}',
                      ),
                      secondary: Text(
                        currencyFormat.format(inv.payableAmount),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textAmount,
                          fontSize: 16,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                })),

                const SizedBox(height: 24),
                // Running Total
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Selected Invoices',
                                style: TextStyle(fontSize: 14)),
                            Text('${_selectedInvoiceIds.length}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Payable',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              currencyFormat.format(_selectedTotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.brandPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (_fetchedInvoices.isEmpty && !_isFetching)
                const Padding(
                  padding: EdgeInsets.only(top: 48.0),
                  child: Center(
                    child: Text(
                      'Select a company and date range, then click "Fetch Invoices".',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

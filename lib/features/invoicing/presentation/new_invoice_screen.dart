import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/database.dart';
import '../../master_data/data/company_repository.dart';
import '../data/invoice_repository.dart';
import '../domain/gst_calculator.dart';
import '../../../core/utils/amount_in_words.dart';

class NewInvoiceScreen extends ConsumerStatefulWidget {
  final int? existingInvoiceId;
  const NewInvoiceScreen({super.key, this.existingInvoiceId});

  @override
  ConsumerState<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends ConsumerState<NewInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Header details
  final _invoiceNoController = TextEditingController();
  final _dateController = TextEditingController();
  
  Company? _selectedCompany;
  
  // Rows
  final List<InvoiceRowData> _rows = [];

  // Calculation state
  double _totalFreight = 0;
  double _totalFastag = 0;
  double _baseAmount = 0;
  GSTResult _gstResult = const GSTResult(sgst: 0, cgst: 0, igst: 0, total: 0);
  double _payableAmount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingInvoiceId != null) {
      _loadExistingInvoice();
    } else {
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _addRow();
    }
  }

  Future<void> _loadExistingInvoice() async {
    final repo = ref.read(invoiceRepositoryProvider);
    final data = await repo.getInvoiceWithRows(widget.existingInvoiceId!);
    if (data == null) return;
    
    _invoiceNoController.text = data.invoice.invoiceNumber;
    _dateController.text = data.invoice.invoiceDate;
    
    // Rows
    for (var r in data.rows) {
      final newRow = InvoiceRowData(onAmountChanged: _recalculateTotals);
      newRow.dateController.text = r.tripDate ?? '';
      newRow.grNoController.text = r.grNumber ?? '';
      newRow.vehicleController.text = r.vehicleNoText ?? '';
      newRow.loadingController.text = r.loadingPlace ?? '';
      newRow.unloadingController.text = r.unloadingPlace ?? '';
      newRow.freightController.text = r.freightCharge > 0 ? r.freightCharge.toString() : '';
      newRow.fastagController.text = r.fastagCharge > 0 ? r.fastagCharge.toString() : '';
      _rows.add(newRow);
    }
    
    if (_rows.isEmpty) { _addRow(); }
    
    setState(() {
      _selectedCompany = data.company;
      _recalculateTotals();
    });
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _dateController.dispose();
    for (var row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _rows.add(InvoiceRowData(onAmountChanged: _recalculateTotals));
    });
    _recalculateTotals();
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    setState(() {
      final removed = _rows.removeAt(index);
      removed.dispose();
    });
    _recalculateTotals();
  }

  void _recalculateTotals() {
    double freight = 0;
    double fastag = 0;

    for (var row in _rows) {
      freight += double.tryParse(row.freightController.text) ?? 0;
      fastag += double.tryParse(row.fastagController.text) ?? 0;
    }

    setState(() {
      _totalFreight = freight;
      _totalFastag = fastag;
      _baseAmount = _totalFreight + _totalFastag;

      if (_selectedCompany != null) {
        _gstResult = GSTCalculator.calculate(_baseAmount, _selectedCompany!.invoiceType);
      } else {
        _gstResult = const GSTResult(sgst: 0, cgst: 0, igst: 0, total: 0);
      }
      
      _payableAmount = _baseAmount + _gstResult.total;
    });
  }

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a company')));
      return;
    }

    final repo = ref.read(invoiceRepositoryProvider);

    final invoiceCompanion = InvoicesCompanion(
      id: widget.existingInvoiceId != null ? drift.Value(widget.existingInvoiceId!) : const drift.Value.absent(),
      invoiceNumber: drift.Value(_invoiceNoController.text),
      invoiceDate: drift.Value(_dateController.text),
      companyId: drift.Value(_selectedCompany!.id),
      invoiceType: drift.Value(_selectedCompany!.invoiceType),
      totalFreight: drift.Value(_totalFreight),
      totalFastag: drift.Value(_totalFastag),
      totalAmount: drift.Value(_baseAmount),
      sgstRate: drift.Value(GSTCalculator.stateRate),
      cgstRate: drift.Value(GSTCalculator.stateRate),
      igstRate: drift.Value(GSTCalculator.interStateRate),
      sgstAmount: drift.Value(_gstResult.sgst),
      cgstAmount: drift.Value(_gstResult.cgst),
      igstAmount: drift.Value(_gstResult.igst),
      payableAmount: drift.Value(_payableAmount),
      amountInWords: drift.Value(IndianAmountWords.convert(_payableAmount)),
      status: const drift.Value('DRAFT'),
    );

    // Build row companions
    final rowCompanions = _rows.asMap().entries.map((entry) {
      final idx = entry.key;
      final row = entry.value;
      return InvoiceRowsCompanion(
        rowOrder: drift.Value(idx + 1),
        tripDate: drift.Value(row.dateController.text),
        grNumber: drift.Value(row.grNoController.text),
        vehicleNoText: drift.Value(row.vehicleController.text),
        loadingPlace: drift.Value(row.loadingController.text),
        unloadingPlace: drift.Value(row.unloadingController.text),
        freightCharge: drift.Value(double.tryParse(row.freightController.text) ?? 0),
        fastagCharge: drift.Value(double.tryParse(row.fastagController.text) ?? 0),
        rowAmount: drift.Value((double.tryParse(row.freightController.text) ?? 0) + (double.tryParse(row.fastagController.text) ?? 0)),
      );
    }).toList();

    try {
      if (widget.existingInvoiceId != null) {
        await repo.updateInvoiceWithRows(invoiceCompanion, rowCompanions, widget.existingInvoiceId!);
      } else {
        await repo.insertInvoiceWithRows(invoiceCompanion, rowCompanions);
      }
      
      if (mounted) {
        Navigator.of(context).pop(); // Go back to dashboard on success
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.existingInvoiceId != null ? 'Invoice updated successfully' : 'Invoice created successfully')
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving invoice: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingInvoiceId != null ? 'Edit Invoice' : 'New Invoice'),
        actions: [
          TextButton.icon(
            onPressed: _saveInvoice,
            icon: const Icon(Icons.save, color: AppTheme.brandPrimary),
            label: Text(widget.existingInvoiceId != null ? 'Update Invoice' : 'Save Draft', style: const TextStyle(color: AppTheme.brandPrimary)),
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
              // Header Segment
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: companiesAsync.when(
                          data: (companies) => DropdownButtonFormField<Company>(
                            decoration: const InputDecoration(
                              labelText: 'Company / Bill To',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _selectedCompany,
                            items: companies.map((c) {
                              return DropdownMenuItem(
                                value: c,
                                child: Text('${c.name} (${c.invoiceType})'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCompany = val;
                                _recalculateTotals();
                              });
                            },
                            validator: (val) => val == null ? 'Required' : null,
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (e, s) => Text('Error loading companies: $e'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _invoiceNoController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Invoice Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Invoice Date (YYYY-MM-DD)',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text('Freight Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Rows Segment
              ..._rows.asMap().entries.map((entry) {
                final idx = entry.key;
                final row = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0, right: 8.0),
                          child: Text('${idx + 1}.', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(child: _buildTextField(row.dateController, 'Trip Date')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(row.grNoController, 'GR No')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(row.vehicleController, 'Vehicle')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(row.loadingController, 'Loading Pt')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(row.unloadingController, 'Unloading Pt')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumericField(row.freightController, 'Freight', true)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildNumericField(row.fastagController, 'Fastag', false)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                          onPressed: () => _removeRow(idx),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              TextButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add),
                label: const Text('Add Row'),
              ),

              const SizedBox(height: 32),

              // Totals Segment
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Column(
                    children: [
                      _TotalRow('Total Freight', _totalFreight),
                      _TotalRow('Total Fastag', _totalFastag),
                      const Divider(),
                      _TotalRow('Base Amount', _baseAmount, isBold: true),
                      
                      if (_selectedCompany?.invoiceType == InvoiceType.state) ...[
                        _TotalRow('SGST (${GSTCalculator.stateRate}%)', _gstResult.sgst),
                        _TotalRow('CGST (${GSTCalculator.stateRate}%)', _gstResult.cgst),
                      ] else if (_selectedCompany?.invoiceType == InvoiceType.interState) ...[
                        _TotalRow('IGST (${GSTCalculator.interStateRate}%)', _gstResult.igst),
                      ],
                      
                      const Divider(),
                      _TotalRow('Total Payable', _payableAmount, isBold: true, isHighlight: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNumericField(TextEditingController controller, String label, bool isRequired) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      validator: isRequired ? (val) => val == null || val.isEmpty ? 'Req' : null : null,
    );
  }
}

class InvoiceRowData {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController grNoController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController loadingController = TextEditingController();
  final TextEditingController unloadingController = TextEditingController();
  final TextEditingController freightController = TextEditingController();
  final TextEditingController fastagController = TextEditingController();

  InvoiceRowData({required VoidCallback onAmountChanged}) {
    freightController.addListener(onAmountChanged);
    fastagController.addListener(onAmountChanged);
  }

  void dispose() {
    dateController.dispose();
    grNoController.dispose();
    vehicleController.dispose();
    loadingController.dispose();
    unloadingController.dispose();
    freightController.dispose();
    fastagController.dispose();
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final bool isHighlight;

  const _TotalRow(this.label, this.amount, {this.isBold = false, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
          Text(
            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
              color: isHighlight ? AppTheme.brandPrimary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

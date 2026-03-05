import 'dart:convert';
import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/database.dart';
import '../../master_data/data/company_repository.dart';
import '../../master_data/data/rate_card_repository.dart';
import '../data/invoice_repository.dart';
import '../domain/gst_calculator.dart';
import '../../../core/utils/amount_in_words.dart';
import '../../master_data/data/master_data_repository.dart';
import '../../profile/data/user_profile_repository.dart';
import 'invoice_fast_entry.dart';

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

  // Custom columns
  final List<String> _customColumns = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingInvoiceId != null) {
      _loadExistingInvoice();
    } else {
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // Initialize auto-incrementing invoice number from profile
      final profile = ref.read(userProfileProvider);
      _invoiceNoController.text = '${profile.invoicePrefix}${profile.nextInvoiceNumber}';
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
      final newRow = InvoiceRowData(onAmountChanged: _recalculateTotals, customColumns: _customColumns);
      newRow.dateController.text = r.tripDate ?? '';
      newRow.grNoController.text = r.grNumber ?? '';
      newRow.vehicleController.text = r.vehicleNoText ?? '';
      newRow.loadingController.text = r.loadingPlace ?? '';
      newRow.unloadingController.text = r.unloadingPlace ?? '';
      newRow.freightController.text = r.freightCharge > 0 ? r.freightCharge.toString() : '';
      newRow.fastagController.text = r.fastagCharge > 0 ? r.fastagCharge.toString() : '';
      // Load custom fields
      if (r.customFields != null) {
        final Map<String, dynamic> cf = jsonDecode(r.customFields!);
        for (final key in cf.keys) {
          if (!_customColumns.contains(key)) _customColumns.add(key);
          newRow.customControllers[key] = TextEditingController(text: cf[key] as String? ?? '');
        }
      }
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
      _rows.add(InvoiceRowData(onAmountChanged: _recalculateTotals, customColumns: _customColumns));
    });
    _recalculateTotals();
  }

  Future<void> _addNRows() async {
    final n = await showDialog<int>(
      context: context,
      builder: (_) => const BulkAddDialog(),
    );
    if (n == null) return;
    setState(() {
      for (var i = 0; i < n; i++) {
        _rows.add(InvoiceRowData(onAmountChanged: _recalculateTotals, customColumns: _customColumns));
      }
    });
    _recalculateTotals();
  }

  void _sortByDate() {
    setState(() {
      _rows.sort((a, b) {
        final da = DateTime.tryParse(a.dateController.text) ?? DateTime(2000);
        final db = DateTime.tryParse(b.dateController.text) ?? DateTime(2000);
        return da.compareTo(db);
      });
    });
  }

  void _sortByGrNo() {
    setState(() {
      _rows.sort((a, b) => a.grNoController.text.compareTo(b.grNoController.text));
    });
  }

  Future<void> _showQuickEntry() async {
    final loading = ref.read(loadingPlaceSuggestionsProvider).value ?? [];
    final unloading = ref.read(unloadingPlaceSuggestionsProvider).value ?? [];
    final vehicles = ref.read(vehicleSuggestionsProvider).value ?? [];
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QuickEntryDialog(
        rows: _rows,
        customColumns: _customColumns,
        loadingSuggestions: loading,
        unloadingSuggestions: unloading,
        vehicleSuggestions: vehicles,
        onChanged: _recalculateTotals,
      ),
    );
    setState(() {});
  }

  Future<void> _showFillAll() async {
    await showFillAllSheet(
      context,
      rows: _rows,
      customColumns: _customColumns,
      onChanged: () => setState(_recalculateTotals),
    );
  }

  Future<void> _tryAutoFillFreight(InvoiceRowData row) async {
    if (_selectedCompany == null) return;
    final loading = row.loadingController.text.trim();
    final unloading = row.unloadingController.text.trim();
    if (loading.isEmpty || unloading.isEmpty) return;
    try {
      final rates = await ref.read(rateCardRepositoryProvider).getRatesForCompany(_selectedCompany!.id);
      final match = rates.where((r) =>
        (r.loadingPlace?.toLowerCase() ?? '') == loading.toLowerCase() &&
        r.unloadingPlace.toLowerCase() == unloading.toLowerCase()).firstOrNull;
      if (match != null && row.freightController.text.isEmpty) {
        setState(() => row.freightController.text = match.rateAmount.toString());
        _recalculateTotals();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Auto-filled freight: ₹${match.rateAmount} for $loading → $unloading'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(label: 'Undo', onPressed: () => setState(() => row.freightController.text = '')),
          ));
        }
      }
    } catch (_) {}
  }

  void _addCustomColumn() async {
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Column'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Column Name', hintText: 'e.g. Weight, Truck Type...', border: OutlineInputBorder()),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(nameController.text.trim()), child: const Text('Add')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && !_customColumns.contains(name)) {
      setState(() {
        _customColumns.add(name);
        for (final row in _rows) {
          row.customControllers[name] = TextEditingController();
        }
      });
    }
    nameController.dispose();
  }

  void _removeCustomColumn(String name) {
    setState(() {
      _customColumns.remove(name);
      for (final row in _rows) {
        row.customControllers[name]?.dispose();
        row.customControllers.remove(name);
      }
    });
  }

  void _renameCustomColumn(String oldName) async {
    final nameController = TextEditingController(text: oldName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Column'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'New Column Name', border: OutlineInputBorder()),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(nameController.text.trim()), child: const Text('Rename')),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty && newName != oldName && !_customColumns.contains(newName)) {
      setState(() {
        final idx = _customColumns.indexOf(oldName);
        _customColumns[idx] = newName;
        for (final row in _rows) {
          final ctrl = row.customControllers.remove(oldName);
          if (ctrl != null) row.customControllers[newName] = ctrl;
        }
      });
    }
    nameController.dispose();
  }

  void _showColumnMenu(String colName) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: Text('Rename "$colName"'),
              onTap: () {
                Navigator.of(ctx).pop();
                _renameCustomColumn(colName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text('Delete "$colName"', style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(ctx).pop();
                _removeCustomColumn(colName);
              },
            ),
          ],
        ),
      ),
    );
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
        customFields: drift.Value(
          row.customControllers.isEmpty ? null : jsonEncode({
            for (final e in row.customControllers.entries) e.key: e.value.text,
          }),
        ),
      );
    }).toList();

    try {
      if (widget.existingInvoiceId != null) {
        await repo.updateInvoiceWithRows(invoiceCompanion, rowCompanions, widget.existingInvoiceId!);
      } else {
        await repo.insertInvoiceWithRows(invoiceCompanion, rowCompanions);
        
        // Auto-increment the invoice number for the next time
        final userProfileRepo = ref.read(userProfileRepositoryProvider);
        final profile = ref.read(userProfileProvider);
        if (_invoiceNoController.text == '${profile.invoicePrefix}${profile.nextInvoiceNumber}') {
          final newProfile = profile.copyWith(nextInvoiceNumber: profile.nextInvoiceNumber + 1);
          await userProfileRepo.saveProfile(newProfile);
          ref.read(userProfileProvider.notifier).state = newProfile;
        }
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
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): _saveInvoice,
        const SingleActivator(LogicalKeyboardKey.enter, control: true): _addRow,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.existingInvoiceId != null ? 'Edit Invoice' : 'New Invoice',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              // Quick action buttons
              Tooltip(
                message: 'Quick Entry (keyboard speed)',
                child: TextButton.icon(
                  onPressed: _showQuickEntry,
                  icon: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
                  label: const Text('Quick Entry', style: TextStyle(color: Colors.amber)),
                ),
              ),
              Tooltip(
                message: 'Add multiple rows at once',
                child: TextButton.icon(
                  onPressed: _addNRows,
                  icon: const Icon(Icons.add_box_outlined, size: 16, color: AppTheme.brandSecondary),
                  label: const Text('+ N Rows', style: TextStyle(color: AppTheme.brandSecondary)),
                ),
              ),
              TextButton.icon(
                onPressed: _saveInvoice,
                icon: const Icon(Icons.save, color: AppTheme.brandPrimary),
                label: Text(widget.existingInvoiceId != null ? 'Update' : 'Save Draft',
                    style: const TextStyle(color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
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
                        child: ref.watch(companiesProvider).when(
                          data: (companies) => RawAutocomplete<String>(
                            optionsBuilder: (textEditingValue) {
                              if (textEditingValue.text == '') return const Iterable<String>.empty();
                              return companies.map((e) => e.name).where((name) => name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                            },
                            onSelected: (selection) {
                              final company = companies.firstWhere((e) => e.name == selection);
                              setState(() {
                                _selectedCompany = company;
                                _recalculateTotals();
                              });
                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: const InputDecoration(labelText: 'Company / Bill To', border: OutlineInputBorder()),
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4,
                                  child: SizedBox(
                                    width: 300,
                                    height: 200,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (context, idx) {
                                        final opt = options.elementAt(idx);
                                        return ListTile(
                                          title: Text(opt),
                                          onTap: () => onSelected(opt),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (e, s) => const Text('Error'),
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
              // ── Data table toolbar ───────────────────────────────
              Row(children: [
                const Text('Freight Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                _ToolbarBtn(icon: Icons.sort, label: 'By Date', onTap: _sortByDate, tooltip: 'Sort rows by Trip Date'),
                const SizedBox(width: 4),
                _ToolbarBtn(icon: Icons.format_list_numbered, label: 'By GR No', onTap: _sortByGrNo, tooltip: 'Sort rows by GR Number'),
                const SizedBox(width: 4),
                _ToolbarBtn(icon: Icons.done_all, label: 'Fill All', onTap: _showFillAll, tooltip: 'Set same value for a field on all rows'),
              ]),
              const SizedBox(height: 8),

              // Rows Table (Excel-like)
              Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DataTable2(
                  columnSpacing: 16,
                  horizontalMargin: 12,
                  minWidth: 1000 + (_customColumns.length * 140.0),
                  headingRowHeight: 48,
                  dataRowHeight: 48,
                  dividerThickness: 1,
                  headingRowColor: WidgetStateProperty.all(AppTheme.brandPrimary.withOpacity(0.06)),
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brandPrimary, fontSize: 13),
                  columns: [
                    const DataColumn2(label: Text('S.No'), fixedWidth: 50),
                    const DataColumn2(label: Text('Trip Date'), size: ColumnSize.L),
                    const DataColumn2(label: Text('GR No'), size: ColumnSize.M),
                    const DataColumn2(label: Text('Vehicle'), size: ColumnSize.L),
                    const DataColumn2(label: Text('Loading Pt'), size: ColumnSize.L),
                    const DataColumn2(label: Text('Unloading Pt'), size: ColumnSize.L),
                    const DataColumn2(label: Text('Freight'), size: ColumnSize.M, numeric: true),
                    const DataColumn2(label: Text('Fastag'), size: ColumnSize.M, numeric: true),
                    // Dynamic custom columns
                    ..._customColumns.map((colName) => DataColumn2(
                      fixedWidth: 140,
                      label: GestureDetector(
                        onLongPress: () => _showColumnMenu(colName),
                        child: Row(
                          children: [
                            Expanded(child: Text(colName, overflow: TextOverflow.ellipsis)),
                            InkWell(
                              onTap: () => _showColumnMenu(colName),
                              child: const Icon(Icons.more_vert, size: 14, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )),
                    // Add column button as last column
                    DataColumn2(
                      fixedWidth: 60,
                      label: InkWell(
                        onTap: _addCustomColumn,
                        borderRadius: BorderRadius.circular(20),
                        child: const Tooltip(
                          message: 'Add custom column',
                          child: Icon(Icons.add_circle_outline, color: AppTheme.brandPrimary, size: 22),
                        ),
                      ),
                    ),
                    const DataColumn2(label: Text(''), fixedWidth: 50),
                  ],
                  rows: _rows.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final row = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text('${idx + 1}', style: const TextStyle(color: AppTheme.textSecondary))),
                        DataCell(_buildCellEntry(row.dateController)),
                        DataCell(_buildCellEntry(row.grNoController)),
                        DataCell(_buildCellEntry(row.vehicleController, suggestions: ref.watch(vehicleSuggestionsProvider).value ?? [])),
                        DataCell(_buildCellEntry(
                          row.loadingController,
                          suggestions: ref.watch(loadingPlaceSuggestionsProvider).value ?? [],
                          onEditingComplete: () => _tryAutoFillFreight(row),
                        )),
                        DataCell(_buildCellEntry(
                          row.unloadingController,
                          suggestions: ref.watch(unloadingPlaceSuggestionsProvider).value ?? [],
                          onEditingComplete: () => _tryAutoFillFreight(row),
                        )),
                        DataCell(_buildCellEntry(row.freightController, isNumeric: true)),
                        DataCell(_buildCellEntry(row.fastagController, isNumeric: true)),
                        // Custom column cells
                        ..._customColumns.map((colName) {
                          final ctrl = row.customControllers.putIfAbsent(colName, TextEditingController.new);
                          return DataCell(_buildCellEntry(ctrl));
                        }),
                        // Add column placeholder cell
                        const DataCell(SizedBox.shrink()),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor, size: 18),
                            onPressed: () => _removeRow(idx),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              Row(children: [
                TextButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Row'),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: _addNRows,
                  icon: const Icon(Icons.add_box_outlined, size: 18),
                  label: const Text('+ N Rows'),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.brandSecondary),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: _showQuickEntry,
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text('Quick Entry'),
                  style: TextButton.styleFrom(foregroundColor: Colors.amber.shade700),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: _addCustomColumn,
                  icon: const Icon(Icons.view_column_outlined, size: 18),
                  label: const Text('Add Column'),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
                ),
                const Spacer(),
                const Text('Ctrl+Enter = add row  ·  Ctrl+S = save', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ]),

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
    )));
  }

  Widget _buildCellEntry(TextEditingController controller, {
    bool isNumeric = false,
    List<String> suggestions = const [],
    VoidCallback? onEditingComplete,
  }) {
    if (suggestions.isEmpty) {
      return TextFormField(
        controller: controller,
        keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        style: const TextStyle(fontSize: 13),
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditingComplete,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.brandPrimary, width: 1.5)),
        ),
      );
    }
    return RawAutocomplete<String>(
      optionsBuilder: (tv) {
        if (tv.text.isEmpty) return const [];
        return suggestions.where((s) => s.toLowerCase().contains(tv.text.toLowerCase()));
      },
      textEditingController: controller,
      onSelected: (s) {
        controller.text = s;
        onEditingComplete?.call();
      },
      fieldViewBuilder: (context, ctrl, fn, onSubmitted) => TextFormField(
        controller: ctrl,
        focusNode: fn,
        style: const TextStyle(fontSize: 13),
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.brandPrimary, width: 1.5)),
        ),
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 220, height: min(options.length * 44.0, 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (_, idx) {
                final opt = options.elementAt(idx);
                return ListTile(
                  dense: true,
                  title: Text(opt, style: const TextStyle(fontSize: 12)),
                  onTap: () => onSelected(opt),
                );
              },
            ),
          ),
        ),
      ),
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
  final Map<String, TextEditingController> customControllers = {};

  InvoiceRowData({required VoidCallback onAmountChanged, List<String> customColumns = const []}) {
    freightController.addListener(onAmountChanged);
    fastagController.addListener(onAmountChanged);
    // Pre-initialize controllers for all current custom columns
    for (final col in customColumns) {
      customControllers[col] = TextEditingController();
    }
  }

  void dispose() {
    dateController.dispose();
    grNoController.dispose();
    vehicleController.dispose();
    loadingController.dispose();
    unloadingController.dispose();
    freightController.dispose();
    fastagController.dispose();
    for (final ctrl in customControllers.values) {
      ctrl.dispose();
    }
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

class _ToolbarBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String tooltip;

  const _ToolbarBtn({required this.icon, required this.label, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderLight),
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey.shade50,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: AppTheme.brandPrimary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.brandPrimary, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }
}

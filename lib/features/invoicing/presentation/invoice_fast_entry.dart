import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_theme.dart';
import 'new_invoice_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Bulk Add N Rows Dialog
// ─────────────────────────────────────────────────────────────────────────────

class BulkAddDialog extends StatefulWidget {
  const BulkAddDialog({super.key});

  @override
  State<BulkAddDialog> createState() => _BulkAddDialogState();
}

class _BulkAddDialogState extends State<BulkAddDialog> {
  final _ctrl = TextEditingController(text: '5');

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(children: [
        Icon(Icons.add_circle_outline, color: AppTheme.brandPrimary),
        SizedBox(width: 8),
        Text('Add Multiple Rows'),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('How many rows do you want to add?', style: TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        SizedBox(
          width: 120,
          child: TextField(
            controller: _ctrl,
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '5'),
            onSubmitted: (_) => _submit(),
          ),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
          child: const Text('Add Rows'),
        ),
      ],
    );
  }

  void _submit() {
    final n = int.tryParse(_ctrl.text);
    if (n != null && n > 0 && n <= 200) {
      Navigator.pop(context, n);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fill-All Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

Future<void> showFillAllSheet(
  BuildContext context, {
  required List<InvoiceRowData> rows,
  required List<String> customColumns,
  required VoidCallback onChanged,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => _FillAllSheet(rows: rows, customColumns: customColumns, onChanged: onChanged),
  );
}

class _FillAllSheet extends StatefulWidget {
  final List<InvoiceRowData> rows;
  final List<String> customColumns;
  final VoidCallback onChanged;
  const _FillAllSheet({required this.rows, required this.customColumns, required this.onChanged});

  @override
  State<_FillAllSheet> createState() => _FillAllSheetState();
}

class _FillAllSheetState extends State<_FillAllSheet> {
  final _ctrl = TextEditingController();
  String _field = 'Loading Place';
  static const _stdFields = ['Loading Place', 'Unloading Place', 'Vehicle No', 'Trip Date', 'Fastag Charge'];

  List<String> get _allFields => [..._stdFields, ...widget.customColumns];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _apply() {
    final val = _ctrl.text.trim();
    if (val.isEmpty) return;
    for (final row in widget.rows) {
      switch (_field) {
        case 'Loading Place':  row.loadingController.text   = val; break;
        case 'Unloading Place': row.unloadingController.text = val; break;
        case 'Vehicle No':     row.vehicleController.text   = val; break;
        case 'Trip Date':      row.dateController.text      = val; break;
        case 'Fastag Charge':  row.fastagController.text    = val; break;
        default:
          row.customControllers[_field]?.text = val;
      }
    }
    widget.onChanged();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Set "$_field" = "$val" on all ${widget.rows.length} rows'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Fill All Rows', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Set the same value for a field across all ${widget.rows.length} rows', style: const TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _field,
          decoration: const InputDecoration(labelText: 'Field to fill', border: OutlineInputBorder()),
          items: _allFields.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
          onChanged: (v) => setState(() => _field = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: 'Value for all rows', hintText: 'e.g. Mumbai', border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: const Icon(Icons.check), onPressed: _apply),
          ),
          onSubmitted: (_) => _apply(),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _apply,
            icon: const Icon(Icons.done_all, size: 16),
            label: const Text('Apply to All Rows'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
          ),
        ]),
        const SizedBox(height: 16),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Entry Dialog — keyboard only, tab→field, Enter→next row
// ─────────────────────────────────────────────────────────────────────────────

class QuickEntryDialog extends StatefulWidget {
  final List<InvoiceRowData> rows;
  final List<String> customColumns;
  final int startRowIndex;
  final List<String>? loadingSuggestions;
  final List<String>? unloadingSuggestions;
  final List<String>? vehicleSuggestions;
  final VoidCallback onChanged;

  const QuickEntryDialog({
    super.key,
    required this.rows,
    required this.customColumns,
    this.startRowIndex = 0,
    this.loadingSuggestions,
    this.unloadingSuggestions,
    this.vehicleSuggestions,
    required this.onChanged,
  });

  @override
  State<QuickEntryDialog> createState() => _QuickEntryDialogState();
}

class _QuickEntryDialogState extends State<QuickEntryDialog> {
  // Which fields are active
  final Map<String, bool> _fieldEnabled = {
    'Date': true, 'GR No': true, 'Vehicle': false,
    'Loading': false, 'Unloading': false, 'Freight': true, 'Fastag': false,
  };
  bool _fieldSelected = false;
  int _currentRow = 0;
  int _currentFieldIdx = 0;
  final _tempCtrl = TextEditingController();
  final _focusNode = FocusNode();
  late List<String> _activeFields;

  @override
  void initState() {
    super.initState();
    _currentRow = widget.startRowIndex;
    _activeFields = _computeActiveFields();
  }

  @override
  void dispose() { _tempCtrl.dispose(); _focusNode.dispose(); super.dispose(); }

  List<String> _computeActiveFields() {
    final fields = <String>[];
    for (final k in _fieldEnabled.keys) if (_fieldEnabled[k]!) fields.add(k);
    for (final c in widget.customColumns) fields.add(c);
    return fields;
  }

  String get _currentFieldName => _currentFieldIdx < _activeFields.length ? _activeFields[_currentFieldIdx] : '';

  String _hintFor(String field) {
    switch (field) {
      case 'Date': return DateHint.today();
      case 'GR No': return 'e.g. GR12345';
      case 'Vehicle': return 'e.g. MH12AB1234';
      case 'Loading': return 'Loading city…';
      case 'Unloading': return 'Unloading city…';
      case 'Freight': return '0.00';
      case 'Fastag': return '0.00';
      default: return field;
    }
  }

  void _writeValue(String value) {
    if (_currentRow >= widget.rows.length) return;
    final row = widget.rows[_currentRow];
    switch (_currentFieldName) {
      case 'Date':        row.dateController.text      = value; break;
      case 'GR No':       row.grNoController.text      = value; break;
      case 'Vehicle':     row.vehicleController.text   = value; break;
      case 'Loading':     row.loadingController.text   = value; break;
      case 'Unloading':   row.unloadingController.text = value; break;
      case 'Freight':     row.freightController.text   = value; break;
      case 'Fastag':      row.fastagController.text    = value; break;
      default:            row.customControllers[_currentFieldName]?.text = value;
    }
  }

  void _nextField() {
    _writeValue(_tempCtrl.text);
    _tempCtrl.clear();
    if (_currentFieldIdx < _activeFields.length - 1) {
      setState(() => _currentFieldIdx++);
    } else {
      // Move to next row
      if (_currentRow < widget.rows.length - 1) {
        setState(() { _currentRow++; _currentFieldIdx = 0; });
      } else {
        _finish();
        return;
      }
    }
    widget.onChanged();
    _focusNode.requestFocus();
  }

  void _prevField() {
    _writeValue(_tempCtrl.text);
    _tempCtrl.clear();
    if (_currentFieldIdx > 0) {
      setState(() => _currentFieldIdx--);
    } else if (_currentRow > 0) {
      setState(() { _currentRow--; _currentFieldIdx = _activeFields.length - 1; });
    }
    widget.onChanged();
    _focusNode.requestFocus();
  }

  void _finish() {
    _writeValue(_tempCtrl.text);
    widget.onChanged();
    Navigator.pop(context);
  }

  void _startEntry() {
    setState(() {
      _fieldSelected = true;
      _activeFields = _computeActiveFields();
      _currentFieldIdx = 0;
    });
    Future.delayed(const Duration(milliseconds: 100), () => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    if (!_fieldSelected) return _buildFieldSelector();
    return _buildEntryForm();
  }

  Widget _buildFieldSelector() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 420,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.brandPrimary, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: Row(children: [
              const Icon(Icons.flash_on, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Quick Entry — Select Fields', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Choose which fields to enter per row:', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              ..._fieldEnabled.keys.map((f) => CheckboxListTile(
                dense: true,
                value: _fieldEnabled[f],
                onChanged: (v) => setState(() => _fieldEnabled[f] = v!),
                title: Text(f),
                activeColor: AppTheme.brandPrimary,
              )),
              const Divider(),
              Text('Starting from row ${_currentRow + 1} of ${widget.rows.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _startEntry,
                  icon: const Icon(Icons.keyboard_tab, size: 16),
                  label: const Text('Start Entering'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildEntryForm() {
    final total = widget.rows.length;
    final progress = (_currentRow * _activeFields.length + _currentFieldIdx) / (total * _activeFields.length);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 440,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: AppTheme.brandPrimary, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.flash_on, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('Row ${_currentRow + 1} / $total  ·  Field: $_currentFieldName',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 18), onPressed: _finish),
              ]),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: progress, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              // Field chips
              Wrap(spacing: 6, runSpacing: 4, children: _activeFields.asMap().entries.map((e) {
                final isActive = e.key == _currentFieldIdx;
                return Chip(
                  label: Text(e.value, style: TextStyle(fontSize: 11, color: isActive ? Colors.white : AppTheme.textSecondary, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                  backgroundColor: isActive ? AppTheme.brandPrimary : Colors.grey.shade100,
                  padding: EdgeInsets.zero,
                );
              }).toList()),
              const SizedBox(height: 16),
              // Input field
              KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.tab) _nextField();
                    if (event.logicalKey == LogicalKeyboardKey.enter) _nextField();
                    if (event.logicalKey == LogicalKeyboardKey.escape) _finish();
                  }
                },
                child: TextField(
                  controller: _tempCtrl,
                  focusNode: _focusNode,
                  autofocus: true,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: _currentFieldName,
                    hintText: _hintFor(_currentFieldName),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.grey.shade50,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _nextField(),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Tab or Enter = Next  ·  Esc = Done', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton.icon(
                  onPressed: _prevField,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Back'),
                ),
                ElevatedButton.icon(
                  onPressed: _nextField,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(_currentFieldIdx < _activeFields.length - 1 || _currentRow < widget.rows.length - 1 ? 'Next' : 'Done'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

class DateHint {
  static String today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

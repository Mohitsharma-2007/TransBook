import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/database/database.dart';
import '../data/payment_repository.dart';

class RecordPaymentDialog extends ConsumerStatefulWidget {
  const RecordPaymentDialog({super.key});

  @override
  ConsumerState<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends ConsumerState<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _tdsController = TextEditingController(text: '0');
  final _referenceController = TextEditingController();
  final _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String _selectedMode = 'NEFT';

  final _modes = ['NEFT', 'RTGS', 'CHEQUE', 'CASH'];

  @override
  void dispose() {
    _invoiceIdController.dispose();
    _amountController.dispose();
    _tdsController.dispose();
    _referenceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(paymentRepositoryProvider);
    final companion = PaymentsCompanion(
      invoiceId: drift.Value(int.tryParse(_invoiceIdController.text)),
      amount: drift.Value(double.tryParse(_amountController.text) ?? 0),
      tdsDeducted: drift.Value(double.tryParse(_tdsController.text) ?? 0),
      paymentMode: drift.Value(_selectedMode),
      referenceNo: drift.Value(_referenceController.text),
      paymentDate: drift.Value(_dateController.text),
      createdAt: drift.Value(DateTime.now().toIso8601String()),
    );

    try {
      await repo.insertPayment(companion);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Payment'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _invoiceIdController,
                decoration: const InputDecoration(labelText: 'Invoice ID', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tdsController,
                decoration: const InputDecoration(labelText: 'TDS Deducted (₹)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedMode,
                decoration: const InputDecoration(labelText: 'Payment Mode', border: OutlineInputBorder()),
                items: _modes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) => setState(() => _selectedMode = v ?? 'NEFT'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(labelText: 'Reference No', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [MaskTextInputFormatter(mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')})],
                decoration: InputDecoration(
                  labelText: 'Payment Date (YYYY-MM-DD)',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final dt = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (dt != null) _dateController.text = DateFormat('yyyy-MM-dd').format(dt);
                    },
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.brandSecondary,
            foregroundColor: AppTheme.surfaceWhite,
          ),
          child: const Text('Save Payment'),
        ),
      ],
    );
  }
}

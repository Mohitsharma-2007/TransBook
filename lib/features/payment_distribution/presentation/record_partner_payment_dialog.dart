import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/database/database.dart';
import '../data/partner_distribution_repository.dart';

class RecordPartnerPaymentDialog extends ConsumerStatefulWidget {
  final PartnerDistribution distribution;

  const RecordPartnerPaymentDialog({super.key, required this.distribution});

  @override
  ConsumerState<RecordPartnerPaymentDialog> createState() => _RecordPartnerPaymentDialogState();
}

class _RecordPartnerPaymentDialogState extends ConsumerState<RecordPartnerPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final pending = widget.distribution.netAmount - widget.distribution.paidAmount;
    _amountController = TextEditingController(text: pending > 0 ? pending.toStringAsFixed(2) : '');
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final dateStr = _dateController.text;
      
      final success = await ref.read(partnerDistributionRepositoryProvider).recordPayment(
        widget.distribution.id,
        amount,
        dateStr,
      );
      
      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to record payment.')));
        }
        Navigator.pop(context);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pay Partner', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Text('Pending Amount: ₹${(widget.distribution.netAmount - widget.distribution.paidAmount).toStringAsFixed(2)}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount to Pay *', prefixText: '₹ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return 'Valid amount required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (dt != null) _dateController.text = DateFormat('yyyy-MM-dd').format(dt);
                    },
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Record Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/database.dart';
import '../data/rate_card_repository.dart';

class AddEditRateCardDialog extends ConsumerStatefulWidget {
  final Company company;
  final FreightRateCard? rateCard;

  const AddEditRateCardDialog({super.key, required this.company, this.rateCard});

  @override
  ConsumerState<AddEditRateCardDialog> createState() => _AddEditRateCardDialogState();
}

class _AddEditRateCardDialogState extends ConsumerState<AddEditRateCardDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _loadingPlaceController;
  late TextEditingController _unloadingPlaceController;
  late TextEditingController _rateAmountController;

  @override
  void initState() {
    super.initState();
    final r = widget.rateCard;
    _loadingPlaceController = TextEditingController(text: r?.loadingPlace ?? widget.company.defaultLoadingPlace ?? '');
    _unloadingPlaceController = TextEditingController(text: r?.unloadingPlace ?? '');
    _rateAmountController = TextEditingController(text: r != null ? r.rateAmount.toStringAsFixed(2) : '');
  }

  @override
  void dispose() {
    _loadingPlaceController.dispose();
    _unloadingPlaceController.dispose();
    _rateAmountController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(rateCardRepositoryProvider);
      final amount = double.tryParse(_rateAmountController.text.trim()) ?? 0.0;
      
      final companion = FreightRateCardsCompanion.insert(
        companyId: widget.company.id,
        loadingPlace: drift.Value(_loadingPlaceController.text.trim()),
        unloadingPlace: _unloadingPlaceController.text.trim(),
        rateAmount: amount,
      );

      if (widget.rateCard == null) {
        await repo.insertRate(companion);
      } else {
        await repo.updateRate(companion.copyWith(id: drift.Value(widget.rateCard!.id)));
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.rateCard == null ? 'Add Rate to ${widget.company.name}' : 'Edit Rate', 
                    style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _loadingPlaceController,
                decoration: const InputDecoration(labelText: 'Loading Place'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unloadingPlaceController,
                decoration: const InputDecoration(labelText: 'Unloading Place *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rateAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Freight Amount (₹) *'),
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Rate'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

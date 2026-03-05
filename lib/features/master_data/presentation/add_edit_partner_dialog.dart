import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database.dart';
import '../../../../core/constants/app_theme.dart';
import '../data/partner_repository.dart';
import 'package:drift/drift.dart' as drift;

class AddEditPartnerDialog extends ConsumerStatefulWidget {
  final Partner? partner;

  const AddEditPartnerDialog({super.key, this.partner});

  @override
  ConsumerState<AddEditPartnerDialog> createState() => _AddEditPartnerDialogState();
}

class _AddEditPartnerDialogState extends ConsumerState<AddEditPartnerDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _panController;
  late TextEditingController _bankNameController;
  late TextEditingController _bankAccountController;
  late TextEditingController _bankIfscController;
  late TextEditingController _sharePercentController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.partner?.name ?? '');
    _phoneController = TextEditingController(text: widget.partner?.phone ?? '');
    _panController = TextEditingController(text: widget.partner?.pan ?? '');
    _bankNameController = TextEditingController(text: widget.partner?.bankName ?? '');
    _bankAccountController = TextEditingController(text: widget.partner?.bankAccount ?? '');
    _bankIfscController = TextEditingController(text: widget.partner?.bankIfsc ?? '');
    _sharePercentController = TextEditingController(text: widget.partner?.sharePercent?.toString() ?? '');
    _isActive = widget.partner?.isActive == 1 || widget.partner == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _panController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _bankIfscController.dispose();
    _sharePercentController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(partnerRepositoryProvider);
      final double? share = double.tryParse(_sharePercentController.text);

      final companion = PartnersCompanion(
        id: widget.partner != null ? drift.Value(widget.partner!.id) : const drift.Value.absent(),
        name: drift.Value(_nameController.text.trim()),
        phone: drift.Value(_phoneController.text.trim()),
        pan: drift.Value(_panController.text.trim()),
        bankName: drift.Value(_bankNameController.text.trim()),
        bankAccount: drift.Value(_bankAccountController.text.trim()),
        bankIfsc: drift.Value(_bankIfscController.text.trim()),
        sharePercent: drift.Value(share),
        isActive: drift.Value(_isActive ? 1 : 0),
      );

      if (widget.partner == null) {
        await repo.insertPartner(companion);
      } else {
        await repo.updatePartner(companion);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.partner == null ? 'Add Partner' : 'Edit Partner',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Partner Name *', prefixIcon: Icon(Icons.person_outline)),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _panController,
                        decoration: const InputDecoration(labelText: 'PAN Number', prefixIcon: Icon(Icons.credit_card)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sharePercentController,
                        decoration: const InputDecoration(labelText: 'Default TDS Share %', prefixIcon: Icon(Icons.percent)),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Active Status'),
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Bank Details', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(labelText: 'Bank Name', prefixIcon: Icon(Icons.account_balance_outlined)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bankAccountController,
                        decoration: const InputDecoration(labelText: 'Account Number'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _bankIfscController,
                        decoration: const InputDecoration(labelText: 'IFSC Code'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(widget.partner == null ? 'Save Partner' : 'Update Partner'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

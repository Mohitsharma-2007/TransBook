import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/constants/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database.dart';
import '../data/company_repository.dart';

class AddEditCompanyDialog extends ConsumerStatefulWidget {
  final Company? company;
  const AddEditCompanyDialog({super.key, this.company});

  @override
  ConsumerState<AddEditCompanyDialog> createState() => _AddEditCompanyDialogState();
}

class _AddEditCompanyDialogState extends ConsumerState<AddEditCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _panController;
  late TextEditingController _gstinController;
  late TextEditingController _stateController;
  late TextEditingController _stateCodeController;
  late TextEditingController _hsnController;
  late TextEditingController _loadingPlaceController;

  String _invoiceType = InvoiceType.state;

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    _nameController = TextEditingController(text: c?.name ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _panController = TextEditingController(text: c?.pan ?? '');
    _gstinController = TextEditingController(text: c?.gstin ?? '');
    _stateController = TextEditingController(text: c?.state ?? '');
    _stateCodeController = TextEditingController(text: c?.stateCode ?? '');
    _hsnController = TextEditingController(text: c?.hsnSac ?? '996791');
    _loadingPlaceController = TextEditingController(text: c?.defaultLoadingPlace ?? '');
    _invoiceType = c?.invoiceType ?? InvoiceType.state;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _panController.dispose();
    _gstinController.dispose();
    _stateController.dispose();
    _stateCodeController.dispose();
    _hsnController.dispose();
    _loadingPlaceController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(companyRepositoryProvider);
      final companion = CompaniesCompanion.insert(
        name: _nameController.text.trim(),
        invoiceType: _invoiceType,
        address: drift.Value(_addressController.text.trim()),
        pan: drift.Value(_panController.text.trim().toUpperCase()),
        gstin: drift.Value(_gstinController.text.trim().toUpperCase()),
        state: drift.Value(_stateController.text.trim()),
        stateCode: drift.Value(_stateCodeController.text.trim()),
        hsnSac: drift.Value(_hsnController.text.trim()),
        defaultLoadingPlace: drift.Value(_loadingPlaceController.text.trim()),
      );

      if (widget.company == null) {
        await repo.insertCompany(companion);
      } else {
        await repo.updateCompany(companion.copyWith(id: drift.Value(widget.company!.id)));
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
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
                  Text(widget.company == null ? 'Add New Company' : 'Edit Company', 
                    style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Company Name *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(child: TextFormField(
                     controller: _panController,
                     decoration: const InputDecoration(labelText: 'PAN'),
                   )),
                   const SizedBox(width: 16),
                   Expanded(child: TextFormField(
                     controller: _gstinController,
                     decoration: const InputDecoration(labelText: 'GSTIN'),
                   )),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(child: TextFormField(
                     controller: _stateController,
                     decoration: const InputDecoration(labelText: 'State (e.g. Uttar Pradesh)'),
                   )),
                   const SizedBox(width: 16),
                   Expanded(child: TextFormField(
                     controller: _stateCodeController,
                     decoration: const InputDecoration(labelText: 'State Code (e.g. 09)'),
                   )),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(child: TextFormField(
                     controller: _hsnController,
                     decoration: const InputDecoration(labelText: 'HSN/SAC Code (Default: 996791)'),
                   )),
                   const SizedBox(width: 16),
                   Expanded(child: TextFormField(
                     controller: _loadingPlaceController,
                     decoration: const InputDecoration(labelText: 'Default Loading Place'),
                   )),
                ],
              ),
              const SizedBox(height: 16),
              Text('Invoice Type *', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('State (SGST+CGST)'),
                      value: InvoiceType.state,
                      groupValue: _invoiceType,
                      onChanged: (v) => setState(() => _invoiceType = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Inter-State (IGST)'),
                      value: InvoiceType.interState,
                      groupValue: _invoiceType,
                      onChanged: (v) => setState(() => _invoiceType = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                ],
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
                    child: const Text('Save Company'),
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

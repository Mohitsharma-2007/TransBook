import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/database.dart';
import '../data/vehicle_repository.dart';
import '../data/partner_repository.dart';

class AddEditVehicleDialog extends ConsumerStatefulWidget {
  final Vehicle? vehicle;
  const AddEditVehicleDialog({super.key, this.vehicle});

  @override
  ConsumerState<AddEditVehicleDialog> createState() => _AddEditVehicleDialogState();
}

class _AddEditVehicleDialogState extends ConsumerState<AddEditVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _vehicleNoController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _notesController;
  int? _selectedPartnerId;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _vehicleNoController = TextEditingController(text: v?.vehicleNo ?? '');
    _vehicleTypeController = TextEditingController(text: v?.vehicleType ?? '');
    _notesController = TextEditingController(text: v?.notes ?? '');
    _selectedPartnerId = v?.partnerId;
  }

  @override
  void dispose() {
    _vehicleNoController.dispose();
    _vehicleTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(vehicleRepositoryProvider);
      final companion = VehiclesCompanion.insert(
        vehicleNo: _vehicleNoController.text.trim().toUpperCase(),
        vehicleType: drift.Value(_vehicleTypeController.text.trim()),
        partnerId: drift.Value(_selectedPartnerId),
        notes: drift.Value(_notesController.text.trim()),
      );

      if (widget.vehicle == null) {
        await repo.insertVehicle(companion);
      } else {
        await repo.updateVehicle(companion.copyWith(id: drift.Value(widget.vehicle!.id)));
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
                  Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle', 
                    style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _vehicleNoController,
                decoration: const InputDecoration(labelText: 'Vehicle Number * (e.g. UP14AT1234)'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleTypeController,
                decoration: const InputDecoration(labelText: 'Vehicle Type (e.g. 10 Tyre)'),
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<Partner>>(
                stream: ref.watch(partnerRepositoryProvider).watchAllPartners(),
                builder: (context, snapshot) {
                  final partners = snapshot.data ?? [];
                  return DropdownButtonFormField<int>(
                    value: _selectedPartnerId,
                    decoration: const InputDecoration(labelText: 'Assign Partner (Optional)', prefixIcon: Icon(Icons.handshake_outlined)),
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('Self Owned / None'),
                      ),
                      ...partners.map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text('${p.name} ${p.phone != null ? '(${p.phone})' : ''}'),
                      )),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedPartnerId = val;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
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
                    child: const Text('Save Vehicle'),
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

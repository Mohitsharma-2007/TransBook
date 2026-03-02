import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_theme.dart';
import '../data/vehicle_repository.dart';
import 'add_edit_vehicle_dialog.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleStream = ref.watch(vehicleRepositoryProvider).watchAllVehicles();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vehicles', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddEditVehicleDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Vehicle'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: vehicleStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final vehicles = snapshot.data ?? [];
                  
                  if (vehicles.isEmpty) {
                    return const Center(child: Text('No vehicles found.', style: TextStyle(color: AppTheme.textSecondary)));
                  }

                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    headingRowColor: MaterialStateProperty.all(AppTheme.brandPrimary),
                    headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    columns: const [
                      DataColumn2(label: Text('VEHICLE NO.'), size: ColumnSize.L),
                      DataColumn2(label: Text('TYPE'), size: ColumnSize.M),
                      DataColumn2(label: Text('STATUS'), size: ColumnSize.S),
                      DataColumn2(label: Text('ACTIONS'), fixedWidth: 100),
                    ],
                    rows: List<DataRow>.generate(vehicles.length, (index) {
                      final vehicle = vehicles[index];
                      return DataRow(
                        color: MaterialStateProperty.all(
                          index % 2 == 1 ? AppTheme.surfaceLight : Colors.white,
                        ),
                        cells: [
                          DataCell(Text(vehicle.vehicleNo, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(vehicle.vehicleType ?? '-')),
                          DataCell(Text(vehicle.isActive == 1 ? 'Active' : 'Inactive')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: AppTheme.textSecondary),
                              onPressed: () {},
                              tooltip: 'Edit',
                              splashRadius: 20,
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_theme.dart';
import '../data/partner_repository.dart';
import 'add_edit_partner_dialog.dart';

class PartnersScreen extends ConsumerWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(partnerRepositoryProvider).watchAllPartners();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Partners', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddEditPartnerDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Partner'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final items = snapshot.data ?? [];
                  
                  if (items.isEmpty) {
                    return const Center(child: Text('No partners found.', style: TextStyle(color: AppTheme.textSecondary)));
                  }

                  return DataTable2(
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    minWidth: 800,
                    headingRowHeight: 48,
                    dataRowHeight: 48,
                    dividerThickness: 1,
                    headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
                    columns: const [
                      DataColumn2(label: Text('PARTNER NAME'), size: ColumnSize.L),
                      DataColumn2(label: Text('PHONE'), size: ColumnSize.M),
                      DataColumn2(label: Text('PAN'), size: ColumnSize.M),
                      DataColumn2(label: Text('STATUS'), size: ColumnSize.S),
                      DataColumn2(label: Text('ACTIONS'), fixedWidth: 100),
                    ],
                    rows: List<DataRow>.generate(items.length, (index) {
                      final item = items[index];
                      return DataRow(
                        color: WidgetStateProperty.all(
                          index % 2 == 1 ? AppTheme.surfaceLight : Colors.white,
                        ),
                        cells: [
                          DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(item.phone ?? '-')),
                          DataCell(Text(item.pan ?? '-')),
                          DataCell(Text(item.isActive == 1 ? 'Active' : 'Inactive')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: AppTheme.textSecondary),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AddEditPartnerDialog(partner: item),
                                    );
                                  },
                                  tooltip: 'Edit',
                                  splashRadius: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.errorColor),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Partner?'),
                                        content: Text('Are you sure you want to delete ${item.name}?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, true), 
                                            child: const Text('Delete', style: TextStyle(color: AppTheme.errorColor))
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      ref.read(partnerRepositoryProvider).deletePartner(item.id);
                                    }
                                  },
                                  tooltip: 'Delete',
                                  splashRadius: 20,
                                ),
                              ],
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

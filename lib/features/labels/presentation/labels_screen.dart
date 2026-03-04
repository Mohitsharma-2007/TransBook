import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_theme.dart';
import '../data/label_repository.dart';

class LabelsScreen extends ConsumerWidget {
  const LabelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelsAsync = ref.watch(labelsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Labels'),
      ),
      body: labelsAsync.when(
        data: (labels) {
          if (labels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.label_outline, size: 64, color: AppTheme.brandSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('No labels found', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Create labels to categorize your invoices and companies.', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: labels.length,
            itemBuilder: (context, index) {
              final label = labels[index];
              final color = Color(int.tryParse(label.colorHex, radix: 16) ?? 0xFFEEEEEE);
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: color.withOpacity(0.5)),
                ),
                color: color.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.label, color: color),
                      const SizedBox(width: 12),
                      Expanded(child: Text(label.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          ref.read(labelRepositoryProvider).deleteLabel(label.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddLabelDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Label'),
        backgroundColor: AppTheme.brandPrimary,
      ),
    );
  }

  void _showAddLabelDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedHex = 'FFF44336'; // Red default

    final colors = [
      'FFF44336', 'FFE91E63', 'FF9C27B0', 'FF673AB7', 
      'FF3F51B5', 'FF2196F3', 'FF03A9F4', 'FF00BCD4',
      'FF009688', 'FF4CAF50', 'FF8BC34A', 'FFCDDC39',
      'FFFFEB3B', 'FFFFC107', 'FFFF9800', 'FFFF5722'
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create New Label'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Label Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Color', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colors.map((hex) {
                      final isSelected = hex == selectedHex;
                      return GestureDetector(
                        onTap: () => setState(() => selectedHex = hex),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse(hex, radix: 16)),
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(labelRepositoryProvider).addLabel(name, selectedHex, 'INVOICE');
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('CREATE'),
              ),
            ],
          );
        }
      ),
    );
  }
}

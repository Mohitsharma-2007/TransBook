import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../core/constants/app_theme.dart';
import '../../../core/database/database.dart';
import '../data/reminder_repository.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(pendingRemindersProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reminders',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.add_alert),
                label: const Text('Add Reminder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brandSecondary,
                  foregroundColor: AppTheme.surfaceWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: remindersAsync.when(
              data: (reminders) {
                if (reminders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade300),
                        const SizedBox(height: 12),
                        Text('All caught up!', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) => _ReminderCard(reminder: reminders[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final typeCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedType = 'PAYMENT';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Reminder'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                  items: ['PAYMENT', 'SUBMISSION', 'GST', 'TDS_CERT']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedType = v ?? 'PAYMENT'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dateCtrl,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [MaskTextInputFormatter(mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')})],
                  decoration: InputDecoration(
                    labelText: 'Due Date (YYYY-MM-DD)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final dt = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime.tryParse(dateCtrl.text) ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (dt != null) dateCtrl.text = DateFormat('yyyy-MM-dd').format(dt);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(reminderRepositoryProvider);
                await repo.insertReminder(RemindersCompanion(
                  type: drift.Value(selectedType),
                  dueDate: drift.Value(dateCtrl.text),
                  notes: drift.Value(notesCtrl.text.isEmpty ? null : notesCtrl.text),
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandSecondary, foregroundColor: AppTheme.surfaceWhite),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    typeCtrl.dispose();
    dateCtrl.dispose();
    notesCtrl.dispose();
  }
}

class _ReminderCard extends ConsumerWidget {
  final Reminder reminder;
  const _ReminderCard({required this.reminder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color typeColor;
    IconData typeIcon;
    switch (reminder.type) {
      case 'PAYMENT':
        typeColor = Colors.red.shade100;
        typeIcon = Icons.payments;
        break;
      case 'SUBMISSION':
        typeColor = Colors.blue.shade100;
        typeIcon = Icons.send;
        break;
      case 'GST':
        typeColor = Colors.orange.shade100;
        typeIcon = Icons.receipt_long;
        break;
      case 'TDS_CERT':
        typeColor = Colors.purple.shade100;
        typeIcon = Icons.verified;
        break;
      default:
        typeColor = Colors.grey.shade200;
        typeIcon = Icons.notifications;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.borderLight),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: typeColor,
          child: Icon(typeIcon, color: Colors.black87, size: 20),
        ),
        title: Text(
          reminder.type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Due: ${reminder.dueDate}${reminder.notes != null ? '\n${reminder.notes}' : ''}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reminder.escalationLevel > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('Esc ${reminder.escalationLevel}', style: TextStyle(color: Colors.red.shade700, fontSize: 11)),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              tooltip: 'Resolve',
              onPressed: () async {
                final repo = ref.read(reminderRepositoryProvider);
                await repo.resolveReminder(reminder.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

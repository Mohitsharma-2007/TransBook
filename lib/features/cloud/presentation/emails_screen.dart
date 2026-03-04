import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../core/constants/app_theme.dart';
import '../data/email_thread_repository.dart';
import '../data/gmail_sync_service.dart';
import '../../../core/database/database.dart';
import 'email_thread_detail_screen.dart';

final isSyncingProvider = StateProvider<bool>((ref) => false);

class EmailsScreen extends ConsumerWidget {
  const EmailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsStream = ref.watch(emailThreadRepositoryProvider).watchAllThreads();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Hub'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isSyncing = ref.watch(isSyncingProvider);
              return IconButton(
                icon: isSyncing 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync),
                onPressed: isSyncing ? null : () async {
                  ref.read(isSyncingProvider.notifier).state = true;
                  try {
                    await ref.read(gmailSyncServiceProvider).syncRecentThreads();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inbox updated successfully.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sync failed: $e')),
                      );
                    }
                  } finally {
                    ref.read(isSyncingProvider.notifier).state = false;
                  }
                },
                tooltip: 'Sync Emails',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<EmailThread>>(
        stream: threadsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final threads = snapshot.data ?? [];
          
          if (threads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mark_email_unread_outlined, size: 64, color: AppTheme.brandSecondary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text('No emails found', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Invoices dispatched via Gmail will appear here.', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 24,
                minWidth: 800,
                columns: const [
                  DataColumn2(label: Text('DATE'), size: ColumnSize.S),
                  DataColumn2(label: Text('TO / FROM'), size: ColumnSize.L),
                  DataColumn2(label: Text('SUBJECT'), size: ColumnSize.L),
                  DataColumn2(label: Text('STATUS'), size: ColumnSize.S),
                ],
                rows: threads.map((thread) {
                  final date = thread.lastMessageDate != null ? DateTime.tryParse(thread.lastMessageDate!) : null;
                  final dateStr = date != null ? DateFormat('dd MMM yyyy, HH:mm').format(date) : '-';

                  return DataRow(
                    onSelectChanged: (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailThreadDetailScreen(
                            threadId: thread.threadId,
                            subject: thread.subject,
                          ),
                        ),
                      );
                    },
                    cells: [
                      DataCell(Text(dateStr)),
                      DataCell(Text(thread.participantEmail ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500))),
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(thread.subject, overflow: TextOverflow.ellipsis),
                          if (thread.lastSnippet != null)
                            Text(thread.lastSnippet!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted), overflow: TextOverflow.ellipsis),
                        ],
                      )),
                      DataCell(_buildStatusBadge(thread.status)),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    
    switch (status.toUpperCase()) {
      case 'SENT':
        bg = AppTheme.statusBgSubmitted;
        text = AppTheme.statusTextSubmitted;
        break;
      case 'REPLIED':
        bg = AppTheme.statusBgPaid;
        text = AppTheme.statusTextPaid;
        break;
      case 'ERROR':
        bg = AppTheme.statusBgDraft;
        text = AppTheme.statusOverdue;
        break;
      default:
        bg = AppTheme.statusBgDraft;
        text = AppTheme.statusTextDraft;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(status.toUpperCase(), style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

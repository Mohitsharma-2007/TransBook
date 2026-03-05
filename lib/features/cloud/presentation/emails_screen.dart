import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_theme.dart';
import '../data/email_thread_repository.dart';
import '../data/gmail_sync_service.dart';
import '../data/gmail_service.dart';
import '../data/email_contact_repository.dart';
import '../../../core/database/database.dart';
import '../../master_data/data/company_repository.dart';
import 'email_thread_detail_screen.dart';

final _showContactsProvider = StateProvider<bool>((ref) => false);

final isSyncingProvider = StateProvider<bool>((ref) => false);
final _selectedThreadIdProvider = StateProvider<String?>((ref) => null);
final _selectedFolderProvider = StateProvider<String>((ref) => 'Inbox');
final _searchQueryProvider = StateProvider<String>((ref) => '');

class EmailsScreen extends ConsumerStatefulWidget {
  const EmailsScreen({super.key});
  @override
  ConsumerState<EmailsScreen> createState() => _EmailsScreenState();
}

class _EmailsScreenState extends ConsumerState<EmailsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _syncEmails() async {
    ref.read(isSyncingProvider.notifier).state = true;
    try {
      await ref.read(gmailSyncServiceProvider).syncRecentThreads();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Inbox updated'), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e'), behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      ref.read(isSyncingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showContacts = ref.watch(_showContactsProvider);
    return Scaffold(
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: Row(
              children: [
                _FolderSidebar(),
                const VerticalDivider(width: 1),
                Expanded(flex: 2, child: _EmailList()),
                const VerticalDivider(width: 1),
                Expanded(flex: 3, child: _EmailPreviewPane()),
                if (showContacts) ...[
                  const VerticalDivider(width: 1),
                  SizedBox(width: 240, child: _ContactsPanel()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    final isSyncing = ref.watch(isSyncingProvider);
    final showContacts = ref.watch(_showContactsProvider);
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.email_outlined, color: AppTheme.brandPrimary, size: 22),
          const SizedBox(width: 12),
          const Text('Email Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextField(
                controller: _searchController,
                onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Search emails, contacts…',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true, fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Contacts toggle
          Tooltip(
            message: showContacts ? 'Hide contacts' : 'Show contacts',
            child: IconButton(
              icon: Icon(Icons.contacts_outlined, color: showContacts ? AppTheme.brandPrimary : AppTheme.textSecondary),
              onPressed: _toggleContacts,
            ),
          ),
          const SizedBox(width: 4),
          ElevatedButton.icon(
            onPressed: () => _showComposeDialog(context),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Compose'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 36),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: isSyncing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync),
            onPressed: isSyncing ? null : _syncEmails,
            tooltip: 'Sync with Gmail',
          ),
        ],
      ),
    );
  }

  void _showComposeDialog(BuildContext ctx, {String? toEmail, String? toName}) {
    showDialog(
      context: ctx,
      builder: (ctx) => _ComposeDialog(initialTo: toEmail, initialToName: toName),
    );
  }

  void _toggleContacts() {
    ref.read(_showContactsProvider.notifier).state = !ref.read(_showContactsProvider);
  }
}

// ── Folder Sidebar ──────────────────────────────────────────────────────────
class _FolderSidebar extends ConsumerWidget {
  final _folders = const [
    ('Inbox', Icons.inbox_outlined),
    ('Sent', Icons.send_outlined),
    ('Starred', Icons.star_outline),
    ('Drafts', Icons.drafts_outlined),
    ('Archived', Icons.archive_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(_selectedFolderProvider);
    return SizedBox(
      width: 180,
      child: Container(
        color: Colors.grey.shade50,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('FOLDERS', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2, color: AppTheme.textMuted)),
            ),
            ..._folders.map((f) {
              final isSelected = f.$1 == selected;
              return ListTile(
                dense: true,
                leading: Icon(f.$2, size: 18, color: isSelected ? AppTheme.brandPrimary : AppTheme.textSecondary),
                title: Text(f.$1, style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppTheme.brandPrimary : AppTheme.textPrimary)),
                selected: isSelected,
                selectedTileColor: AppTheme.brandPrimary.withAlpha(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () => ref.read(_selectedFolderProvider.notifier).state = f.$1,
              );
            }),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('LABELS', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2, color: AppTheme.textMuted)),
            ),
            _labelTile(context, 'Invoiced', Colors.blue),
            _labelTile(context, 'Paid', Colors.green),
            _labelTile(context, 'Overdue', Colors.red),
            _labelTile(context, 'Follow-up', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _labelTile(BuildContext ctx, String label, Color color) {
    return ListTile(
      dense: true,
      leading: Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: () {},
    );
  }
}

// ── Email List Panel ────────────────────────────────────────────────────────
class _EmailList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsStream = ref.watch(emailThreadRepositoryProvider).watchAllThreads();
    final searchQuery = ref.watch(_searchQueryProvider).toLowerCase();
    final selectedId = ref.watch(_selectedThreadIdProvider);

    return StreamBuilder<List<EmailThread>>(
      stream: threadsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        var threads = snapshot.data ?? [];

        // Filter by search
        if (searchQuery.isNotEmpty) {
          threads = threads.where((t) =>
              (t.subject.toLowerCase().contains(searchQuery)) ||
              (t.participantEmail?.toLowerCase().contains(searchQuery) ?? false) ||
              (t.lastSnippet?.toLowerCase().contains(searchQuery) ?? false)).toList();
        }

        if (threads.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.mark_email_unread_outlined, size: 56, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(searchQuery.isEmpty ? 'No emails yet' : 'No results', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary)),
              if (searchQuery.isEmpty) ...[
                const SizedBox(height: 8),
                const Text('Sync your Gmail or send an invoice email', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ],
            ]),
          );
        }

        // Group by date
        final grouped = _groupByDate(threads);

        return ListView.builder(
          itemCount: grouped.length,
          itemBuilder: (ctx, i) {
            final item = grouped[i];
            if (item is String) {
              // Date header
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                color: Colors.grey.shade50,
                child: Text(item, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 0.8)),
              );
            }
            final thread = item as EmailThread;
            final isSelected = thread.threadId == selectedId;
            final date = thread.lastMessageDate != null ? DateTime.tryParse(thread.lastMessageDate!) : null;
            final timeStr = date != null ? _formatTime(date) : '';

            return InkWell(
              onTap: () => ref.read(_selectedThreadIdProvider.notifier).state = thread.threadId,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.brandPrimary.withAlpha(12) : null,
                  border: Border(
                    left: BorderSide(color: isSelected ? AppTheme.brandPrimary : Colors.transparent, width: 3),
                    bottom: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(thread.participantEmail ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(timeStr, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  ]),
                  const SizedBox(height: 2),
                  Text(thread.subject,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: thread.status == 'UNREAD' ? FontWeight.bold : FontWeight.w500,
                      color: thread.status == 'UNREAD' ? AppTheme.textPrimary : AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis),
                  if (thread.lastSnippet != null)
                    Text(thread.lastSnippet!, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted), overflow: TextOverflow.ellipsis, maxLines: 1),
                  const SizedBox(height: 4),
                  Row(children: [
                    _StatusBadge(thread.status),
                    const Spacer(),
                    if (thread.status == 'SENT') const Icon(Icons.attach_file, size: 12, color: AppTheme.textMuted),
                  ]),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) return DateFormat('HH:mm').format(date);
    if (now.difference(date).inDays == 1) return 'Yesterday';
    if (now.difference(date).inDays < 7) return DateFormat('EEE').format(date);
    return DateFormat('dd MMM').format(date);
  }

  List<dynamic> _groupByDate(List<EmailThread> threads) {
    final result = <dynamic>[];
    String? lastGroup;
    for (final t in threads) {
      final date = t.lastMessageDate != null ? DateTime.tryParse(t.lastMessageDate!) : null;
      final group = _dateGroup(date);
      if (group != lastGroup) {
        result.add(group);
        lastGroup = group;
      }
      result.add(t);
    }
    return result;
  }

  String _dateGroup(DateTime? date) {
    if (date == null) return 'Older';
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This Week';
    if (diff < 30) return 'This Month';
    return DateFormat('MMMM yyyy').format(date);
  }
}

// ── Email Preview Pane ───────────────────────────────────────────────────────
class _EmailPreviewPane extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(_selectedThreadIdProvider);

    if (selectedId == null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.mail_outline, size: 64, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text('Select an email to preview', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
        ]),
      );
    }

    // Push to detail screen for full view
    return EmailThreadDetailScreen(
      threadId: selectedId,
      subject: '',
      isEmbedded: true,
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color bg; Color text;
    switch (status.toUpperCase()) {
      case 'SENT': bg = AppTheme.statusBgSubmitted; text = AppTheme.statusTextSubmitted; break;
      case 'REPLIED': bg = AppTheme.statusBgPaid; text = AppTheme.statusTextPaid; break;
      case 'ERROR': bg = AppTheme.statusBgDraft; text = AppTheme.statusOverdue; break;
      default: bg = AppTheme.statusBgDraft; text = AppTheme.statusTextDraft;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(status.toUpperCase(), style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}

// ── Contacts Panel ────────────────────────────────────────────────────────────
class _ContactsPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ContactsPanel> createState() => _ContactsPanelState();
}

class _ContactsPanelState extends ConsumerState<_ContactsPanel> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Auto-import companies as contacts
    WidgetsBinding.instance.addPostFrameCallback((_) => _importCompanies());
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _importCompanies() async {
    try {
      final companies = await ref.read(companiesProvider.future);
      final imported = companies
          .where((c) => c.contactEmail != null && c.contactEmail!.isNotEmpty)
          .map((c) => EmailContact(
            id: 'company_${c.id}',
            name: c.contactName ?? c.name,
            email: c.contactEmail!,
            company: c.name,
            phone: c.contactPhone,
            isAutoImported: true,
          )).toList();
      if (imported.isNotEmpty) {
        await ref.read(emailContactsProvider.notifier).mergeAutoImported(imported);
      }
    } catch (_) {}
  }

  void _addContact() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final compCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), autofocus: true),
          const SizedBox(height: 8),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          TextField(controller: compCtrl, decoration: const InputDecoration(labelText: 'Company (optional)', border: OutlineInputBorder())),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () async {
            if (emailCtrl.text.trim().isEmpty) return;
            await ref.read(emailContactsProvider.notifier).add(EmailContact(
              id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
              name: nameCtrl.text.trim().isEmpty ? emailCtrl.text.trim() : nameCtrl.text.trim(),
              email: emailCtrl.text.trim(),
              company: compCtrl.text.trim().isEmpty ? null : compCtrl.text.trim(),
            ));
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Add')),
        ],
      ),
    );
    nameCtrl.dispose(); emailCtrl.dispose(); compCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(emailContactsProvider);
    final filtered = _query.isEmpty ? contacts
        : contacts.where((c) => c.name.toLowerCase().contains(_query) || c.email.toLowerCase().contains(_query)).toList();

    return Column(children: [
      // Header
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade50, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
        child: Row(children: [
          const Icon(Icons.contacts_outlined, size: 16, color: AppTheme.brandPrimary),
          const SizedBox(width: 8),
          const Expanded(child: Text('Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          IconButton(icon: const Icon(Icons.person_add_outlined, size: 16), onPressed: _addContact, tooltip: 'Add Contact', padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ]),
      ),
      // Search
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search contacts…', hintStyle: const TextStyle(fontSize: 12),
            prefixIcon: const Icon(Icons.search, size: 14),
            isDense: true, filled: true, fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ),
      // List
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Text(contacts.isEmpty ? 'No contacts\nSync or add manually' : 'No results',
                textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)))
            : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.brandPrimary.withAlpha(30),
                      child: Text(c.name.isEmpty ? '?' : c.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 13, color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(c.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                    subtitle: Text(c.email, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted), overflow: TextOverflow.ellipsis),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      // Compose to this contact
                      InkWell(
                        onTap: () {
                          ref.read(_showContactsProvider.notifier).state = false;
                          showDialog(context: context, builder: (_) => _ComposeDialog(initialTo: c.email, initialToName: c.name));
                        },
                        child: const Icon(Icons.send_outlined, size: 14, color: AppTheme.brandPrimary),
                      ),
                      if (!c.isAutoImported) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => ref.read(emailContactsProvider.notifier).delete(c.id),
                          child: const Icon(Icons.delete_outline, size: 14, color: AppTheme.errorColor),
                        ),
                      ],
                    ]),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  );
                },
              ),
      ),
    ]);
  }
}

// ── Compose Dialog ────────────────────────────────────────────────────────────
class _ComposeDialog extends ConsumerStatefulWidget {
  final String? initialTo;
  final String? initialToName;
  const _ComposeDialog({this.initialTo, this.initialToName});
  @override
  ConsumerState<_ComposeDialog> createState() => _ComposeDialogState();
}

class _ComposeDialogState extends ConsumerState<_ComposeDialog> {
  late final TextEditingController _toCtrl;
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _sending = false;

  // Email templates
  static const _templates = [
    ('Invoice Dispatch', 'Invoice Attached — Please Review', 'Dear Sir/Madam,\n\nPlease find the invoice attached for your kind perusal. Kindly arrange payment at the earliest.\n\nThank you for your business.\n\nRegards,'),
    ('Payment Reminder', 'Payment Reminder — Invoice Due', 'Dear Sir/Madam,\n\nThis is a gentle reminder that payment for the attached invoice is now due. Please arrange payment at the earliest convenience.\n\nThank you.\n\nRegards,'),
    ('Follow-Up', 'Following Up on Invoice', 'Dear Sir/Madam,\n\nWe are writing to follow up on our previous invoice. We request you to clear the outstanding amount at the earliest.\n\nPlease contact us if you have any queries.\n\nThank you.\n\nRegards,'),
    ('Custom', '', ''),
  ];

  @override
  void initState() {
    super.initState();
    _toCtrl = TextEditingController(text: widget.initialTo ?? '');
  }

  @override
  void dispose() {
    _toCtrl.dispose(); _subjectCtrl.dispose(); _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_toCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a recipient email')));
      return;
    }
    setState(() => _sending = true);
    try {
      final gmail = ref.read(gmailServiceProvider);
      final ok = await gmail.sendEmail(
        to: _toCtrl.text.trim(),
        subject: _subjectCtrl.text.trim().isNotEmpty ? _subjectCtrl.text.trim() : '(no subject)',
        htmlBody: '<p>${_bodyCtrl.text.replaceAll('\n', '<br>')}</p>',
        attachments: [],
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ok ? '✅ Email sent!' : '❌ Failed to send email'),
            behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 600,
        height: 460,
        child: Column(children: [
          // Title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(children: [
              const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              const Text('New Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context), iconSize: 18),
            ]),
          ),
          // Fields
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              // Template picker
              Row(children: [
                const SizedBox(width: 56, child: Text('Template', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppTheme.textSecondary))),
                Expanded(child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: _templates.map((t) =>
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(t.$1, style: const TextStyle(fontSize: 11)),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        onPressed: () {
                          if (t.$3.isNotEmpty) {
                            _subjectCtrl.text = t.$2;
                            _bodyCtrl.text = t.$3;
                            setState(() {});
                          }
                        },
                      ),
                    )
                  ).toList()),
                )),
              ]),
              const SizedBox(height: 8),
              _field('To', _toCtrl, 'recipient@example.com'),
              const SizedBox(height: 8),
              _field('Subject', _subjectCtrl, 'Email subject'),
              const SizedBox(height: 8),
              TextField(
                controller: _bodyCtrl,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'Write your message…',
                  filled: true, fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _sending ? null : _send,
                icon: _sending
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send, size: 16),
                label: Text(_sending ? 'Sending…' : 'Send Email'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint) {
    return Row(children: [
      SizedBox(width: 56, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textSecondary))),
      Expanded(child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      )),
    ]);
  }
}

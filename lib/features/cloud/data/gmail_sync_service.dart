import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'gmail_service.dart';
import 'email_thread_repository.dart';

final gmailSyncServiceProvider = Provider((ref) {
  final gmailService = ref.watch(gmailServiceProvider);
  final repository = ref.watch(emailThreadRepositoryProvider);
  return GmailSyncService(gmailService, repository);
});

class GmailSyncService {
  final GmailService _gmailService;
  final EmailThreadRepository _repository;

  GmailSyncService(this._gmailService, this._repository);

  Future<void> syncRecentThreads() async {
    final threads = await _gmailService.fetchThreads(maxResults: 20);
    
    for (final threadSummary in threads) {
      if (threadSummary.id == null) continue;
      
      final thread = await _gmailService.getThreadDetail(threadSummary.id!);
      if (thread == null || thread.messages == null || thread.messages!.isEmpty) continue;

      // Use the last message to update the thread summary in our DB
      final lastMessage = thread.messages!.last;
      final headers = _gmailService.parseHeaders(lastMessage);
      
      final subject = headers['subject'] ?? 'No Subject';
      final from = headers['from'] ?? 'Unknown';
      final dateStr = headers['date'] ?? DateTime.now().toIso8601String();
      final snippet = thread.messages!.last.snippet ?? '';

      await _repository.createThread(
        threadId: thread.id!,
        subject: subject,
        snippet: snippet,
        participantEmail: from,
        status: _determineStatus(from),
        lastMessageDate: dateStr,
      );
    }
  }

  String _determineStatus(String from) {
    if (from.contains('me')) return 'SENT';
    return 'REPLIED';
  }
}

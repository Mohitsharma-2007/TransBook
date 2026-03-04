import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

// part 'email_thread_repository.g.dart';

class EmailThreadRepository {
  final AppDatabase _db;

  EmailThreadRepository(this._db);

  Stream<List<EmailThread>> watchAllThreads() {
    return (_db.select(_db.emailThreads)
          ..orderBy([(t) => OrderingTerm.desc(t.lastMessageDate)]))
        .watch();
  }

  Future<void> createThread({
    required String threadId,
    required String subject,
    required String snippet,
    int? invoiceId,
    String? participantEmail,
    String status = 'SENT',
    String? lastMessageDate,
  }) async {
    await _db.into(_db.emailThreads).insert(
      EmailThreadsCompanion(
        threadId: Value(threadId),
        subject: Value(subject),
        lastSnippet: Value(snippet),
        invoiceId: Value(invoiceId),
        participantEmail: Value(participantEmail),
        status: Value(status),
        lastMessageDate: Value(lastMessageDate ?? DateTime.now().toIso8601String()),
      ),
      mode: InsertMode.replace, // Upsert if threadId already exists
    );
  }

  Future<void> updateThreadStatus(String threadId, String newStatus) async {
    await (_db.update(_db.emailThreads)..where((t) => t.threadId.equals(threadId)))
        .write(EmailThreadsCompanion(status: Value(newStatus)));
  }
}

final emailThreadRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return EmailThreadRepository(db);
});

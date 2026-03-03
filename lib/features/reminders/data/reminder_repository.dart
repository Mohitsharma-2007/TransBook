import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

part 'reminder_repository.g.dart';

class ReminderRepository {
  final AppDatabase _db;

  ReminderRepository(this._db);

  /// Watch all pending (unresolved) reminders, ordered by due date.
  Stream<List<Reminder>> watchPendingReminders() {
    return (_db.select(_db.reminders)
          ..where((tbl) => tbl.isResolved.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.dueDate)]))
        .watch();
  }

  /// Get all reminders.
  Future<List<Reminder>> getAllReminders() {
    return _db.select(_db.reminders).get();
  }

  /// Insert a new reminder.
  Future<int> insertReminder(RemindersCompanion companion) {
    return _db.into(_db.reminders).insert(companion);
  }

  /// Mark a reminder as resolved.
  Future<void> resolveReminder(int id) async {
    await (_db.update(_db.reminders)..where((tbl) => tbl.id.equals(id))).write(
      const RemindersCompanion(isResolved: Value(true)),
    );
  }

  /// Escalate reminder level.
  Future<void> escalate(int id) async {
    final reminder = await (_db.select(_db.reminders)..where((tbl) => tbl.id.equals(id))).getSingle();
    await (_db.update(_db.reminders)..where((tbl) => tbl.id.equals(id))).write(
      RemindersCompanion(
        escalationLevel: Value(reminder.escalationLevel + 1),
        lastNotified: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  /// Delete a reminder.
  Future<void> deleteReminder(int id) async {
    await (_db.delete(_db.reminders)..where((tbl) => tbl.id.equals(id))).go();
  }
}

@riverpod
ReminderRepository reminderRepository(ReminderRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReminderRepository(db);
}

@riverpod
Stream<List<Reminder>> pendingReminders(PendingRemindersRef ref) {
  final repo = ref.watch(reminderRepositoryProvider);
  return repo.watchPendingReminders();
}

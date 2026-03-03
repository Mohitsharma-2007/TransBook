---
phase: 6
plan: 1
wave: 1
---

# Plan 6.1: Reminders & Audit Log Data Layer

## Objective
Add `Reminders`, `EmailLogs`, and `AuditLog` Drift tables and create their repositories.

## Context
- `e:\TransBook\TRD.md` -> Sections reminders, email_logs, audit_log tables
- `e:\TransBook\lib\core\database\tables.dart`
- `e:\TransBook\lib\core\database\database.dart`

## Tasks

<task type="auto">
  <name>Add Tables</name>
  <files>
    - `e:\TransBook\lib\core\database\tables.dart`
    - `e:\TransBook\lib\core\database\database.dart`
  </files>
  <action>
    - Add `Reminders` table: id, type (PAYMENT|SUBMISSION|GST|TDS_CERT), referenceId, referenceType, dueDate, escalationLevel, isResolved, lastNotified, notes.
    - Add `EmailLogs` table: id, invoiceId, direction, subject, body, sentAt, gmailMessageId, status.
    - Add `AuditLog` table: id, entityType, entityId, action, oldValue, newValue, userNote, createdAt.
    - Register all in `@DriftDatabase`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/core/database/</verify>
  <done>Tables exist and code generation succeeds.</done>
</task>

<task type="auto">
  <name>Reminder Repository</name>
  <files>
    - `e:\TransBook\lib\features\reminders\data\reminder_repository.dart`
  </files>
  <action>
    - Create `ReminderRepository` with: `watchPendingReminders()`, `insertReminder()`, `resolveReminder(int id)`, `escalate(int id)`.
    - Create riverpod providers.
  </action>
  <verify>dart analyze lib/features/reminders/data/</verify>
  <done>Repository has CRUD + escalation + resolve methods.</done>
</task>

## Success Criteria
- [ ] Reminders, EmailLogs, AuditLog tables in Drift schema.
- [ ] ReminderRepository with pending/resolve/escalation logic.
- [ ] Passes static analysis.

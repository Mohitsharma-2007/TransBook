---
phase: 5
plan: 2
wave: 2
---

# Plan 5.2: Google Drive Sync

## Objective
Implement Google Drive sync with a sync queue table, OAuth sign-in flow, and background upload of PDFs organized into FY/Company folders.

## Context
- `e:\TransBook\TRD.md` -> Section 7.1, 7.2
- `e:\TransBook\lib\core\database\tables.dart`

## Tasks

<task type="auto">
  <name>Sync Queue Table + Google Drive Service</name>
  <files>
    - `e:\TransBook\lib\core\database\tables.dart`
    - `e:\TransBook\lib\core\database\database.dart`
    - `e:\TransBook\lib\features\cloud\data\google_drive_service.dart`
  </files>
  <action>
    - Add `SyncQueue` Drift table: id, entityType, entityId, action (UPLOAD|UPDATE|DELETE), attempts, lastAttempt, createdAt.
    - Register in `@DriftDatabase`.
    - Create `GoogleDriveService` class (stubbed for now — full OAuth will need user credentials).
    - Implement `Future<void> syncInvoice(Invoice invoice, Uint8List pdfBytes)`:
      - Creates folder path: TransBook/FY-{year}/CompanyName/
      - Uploads PDF
      - Marks invoice as cloudSynced
    - Implement `Future<void> processQueue()` — pulls from sync_queue and retries.
    - Since full Google OAuth requires client secrets and user interaction, this will be a skeleton with `dio` calls stubbed behind an `isAuthenticated` check.
    - Create riverpod `googleDriveServiceProvider`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/features/cloud/</verify>
  <done>SyncQueue table exists, GoogleDriveService has upload skeleton.</done>
</task>

## Success Criteria
- [ ] `SyncQueue` table registered in Drift.
- [ ] `GoogleDriveService` has `syncInvoice` and `processQueue` methods.
- [ ] Code passes static analysis.

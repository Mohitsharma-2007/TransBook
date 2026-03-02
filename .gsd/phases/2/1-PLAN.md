---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Invoice Data Layer

## Objective
Set up the Drift repository layer to handle creating invoices with their associated freight rows in a single exact transaction.

## Context
- .gsd/SPEC.md
- TRD.md (Section 3.1)
- lib/core/database/tables.dart
- lib/features/master_data/data/company_repository.dart (as reference for Riverpod)

## Tasks

<task type="auto">
  <name>Create Invoice Repository</name>
  <files>lib/features/invoicing/data/invoice_repository.dart</files>
  <action>
    - Implement `InvoiceRepository` taking `AppDatabase`.
    - Create `insertInvoiceWithRows(InvoicesCompanion invoice, List<InvoiceRowsCompanion> rows)` combining both inserts into `_db.transaction()`.
    - Create `watchAllInvoices()` to get all invoices ordered by date descending.
    - Create `getInvoiceWithRows(int invoiceId)` which fetches the invoice and joins/fetches its `InvoiceRow`s.
    - Create a `@riverpod` provider for `invoiceRepository`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs</verify>
  <done>Riverpod generator runs successfully and Repository is available.</done>
</task>

## Success Criteria
- [ ] `InvoiceRepository` allows transactional insert of an Invoice and its Rows.
- [ ] Riverpod `invoiceRepositoryProvider` is cleanly generated.

---
phase: 4
plan: 1
wave: 1
---

# Plan 4.1: Payments & Distributions Data Layer

## Objective
Add the `Payments` and `PartnerDistributions` Drift tables to the database schema and create their respective repositories with Riverpod providers.

## Context
- `e:\TransBook\TRD.md` -> Section 3.1 (payments, partner_distributions tables)
- `e:\TransBook\lib\core\database\tables.dart`
- `e:\TransBook\lib\core\database\database.dart`

## Tasks

<task type="auto">
  <name>Add Payments & PartnerDistributions Tables</name>
  <files>
    - `e:\TransBook\lib\core\database\tables.dart`
    - `e:\TransBook\lib\core\database\database.dart`
  </files>
  <action>
    - Add `Payments` table to `tables.dart` with columns: id, invoiceId (FK), paymentDate, amount, paymentMode, referenceNo, tdsDeducted, notes, createdAt.
    - Add `PartnerDistributions` table with columns: id, periodFrom, periodTo, partnerId (FK), vehicleId (FK), trips, freightAmount, tdsShare, netAmount, paidAmount, paidDate, createdAt.
    - Register both in `@DriftDatabase` annotation in `database.dart`.
    - Run `dart run build_runner build --delete-conflicting-outputs`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/core/database/</verify>
  <done>New tables exist in generated code and pass static analysis.</done>
</task>

<task type="auto">
  <name>Payment Repository</name>
  <files>
    - `e:\TransBook\lib\features\payment_distribution\data\payment_repository.dart`
  </files>
  <action>
    - Create `PaymentRepository` injected with `AppDatabase`.
    - `insertPayment(PaymentsCompanion)` — insert payment, then update the parent Invoice's `paymentReceived` (additive) and `paymentDate`.
    - `watchPaymentsForInvoice(int invoiceId)` — stream of payments for an invoice.
    - `watchAllPayments()` — all payments ordered by paymentDate desc.
    - Create riverpod `paymentRepositoryProvider` and `allPaymentsProvider`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/features/payment_distribution/data/</verify>
  <done>PaymentRepository builds and passes static analysis with working providers.</done>
</task>

## Success Criteria
- [ ] `Payments` and `PartnerDistributions` tables registered in Drift.
- [ ] `PaymentRepository` supports insert with parent invoice update.
- [ ] Code passes static analysis.

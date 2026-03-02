---
phase: 3
plan: 1
wave: 1
---

# Plan 3.1: Summary Bills Data Layer

## Objective
Implement the Drift repository and Riverpod providers to support creating, updating, and querying `SummaryBills` and their associated `Invoices` (`summary_bill_invoices` junction table). Includes status transitions for Invoices (e.g., Draft -> Submitted).

## Context
- `.gsd/SPEC.md`
- `e:\TransBook\TRD.md` -> Section 3.1 Core Tables (summary_bills, summary_bill_invoices)
- `e:\TransBook\lib\core\database\tables.dart`
- `e:\TransBook\lib\features\invoicing\data\invoice_repository.dart`

## Tasks

<task type="auto">
  <name>Summary Bill Repository</name>
  <files>
    - `e:\TransBook\lib\features\billing_management\data\summary_bill_repository.dart`
    - `e:\TransBook\lib\features\billing_management\domain\summary_bill_models.dart`
  </files>
  <action>
    - Create `SummaryBillWithInvoices` model in `summary_bill_models.dart` that holds a `SummaryBill` and a `List<Invoice>`.
    - Implement `SummaryBillRepository` injected with `AppDatabase`.
    - Create a method `insertSummaryBill(SummaryBillsCompanion bill, List<int> invoiceIds)` that runs in a transaction.
      - It should insert the Summary Bill.
      - It should insert records into the `SummaryBillInvoices` junction table.
      - It should update the status of the linked `Invoices` (e.g., from 'DRAFT' to 'SUBMITTED').
    - Create a method `watchAllSummaryBills()` returning a `Stream<List<SummaryBill>>` ordered by creation date descending.
    - Create a method `getSummaryBillWithInvoices(int summaryId)` returning a `Future<SummaryBillWithInvoices?>`.
    - Create a riverpod provider `summaryBillRepositoryProvider`.
    - Create a riverpod stream provider `summaryBillsProvider` wrapping `watchAllSummaryBills()`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/features/billing_management/data</verify>
  <done>Riverpod generator succeeds, repository provides transactional insert for summary bills and invoice status updates.</done>
</task>

## Success Criteria
- [ ] `SummaryBillRepository` exists and supports transactional creation of Summary Bills and linking Invoices.
- [ ] Invoice statuses are updated correctly when attached to a Summary Bill.
- [ ] Code passes static analysis.

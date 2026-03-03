---
phase: 4
plan: 3
wave: 3
---

# Plan 4.3: Payments UI & Ledger

## Objective
Build the user-facing Payments screen with a ledger view and the ability to record new payments against invoices.

## Context
- `e:\TransBook\lib\features\payment_distribution\data\payment_repository.dart`
- `e:\TransBook\lib\features\payment_distribution\domain\tds_distributor.dart`
- `e:\TransBook\lib\main.dart`

## Tasks

<task type="auto">
  <name>Payments Ledger Screen</name>
  <files>
    - `e:\TransBook\lib\features\payment_distribution\presentation\payments_screen.dart`
  </files>
  <action>
    - Create `PaymentsScreen` extending `ConsumerWidget`.
    - Use `DataTable2` to show all payments from `allPaymentsProvider`.
    - Columns: Date, Invoice No, Amount, TDS Deducted, Mode, Reference.
    - Add a "Record Payment" button in the header.
  </action>
  <verify>dart analyze lib/features/payment_distribution/presentation/payments_screen.dart</verify>
  <done>Payments ledger screen renders all recorded payments.</done>
</task>

<task type="auto">
  <name>Record Payment Dialog</name>
  <files>
    - `e:\TransBook\lib\features\payment_distribution\presentation\record_payment_dialog.dart`
  </files>
  <action>
    - Create `RecordPaymentDialog` as a `ConsumerStatefulWidget`.
    - Fields: Invoice selector (dropdown of outstanding invoices), Amount, TDS Deducted, Payment Mode (NEFT/RTGS/CHEQUE/CASH dropdown), Reference No, Date.
    - On save: call `PaymentRepository.insertPayment`.
    - Pop dialog on success.
  </action>
  <verify>dart analyze lib/features/payment_distribution/presentation/</verify>
  <done>Dialog allows recording payments and updating invoice balances.</done>
</task>

<task type="auto">
  <name>Integrate into Main Shell</name>
  <files>
    - `e:\TransBook\lib\main.dart`
  </files>
  <action>
    - Import `PaymentsScreen`.
    - Add as a new item in `_screens` array and sidebar navigation under BILLING section.
  </action>
  <verify>dart analyze lib/main.dart</verify>
  <done>Users can navigate to Payments from sidebar.</done>
</task>

## Success Criteria
- [ ] Payments ledger view is operational.
- [ ] Users can record payments against invoices.
- [ ] Main shell navigation includes Payments.

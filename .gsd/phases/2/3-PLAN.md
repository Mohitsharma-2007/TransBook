---
phase: 2
plan: 3
wave: 3
---

# Plan 2.3: Invoices Dashboard & New Invoice UI

## Objective
Create the main interface for maintaining Invoices, including the Dashboard and the complex New Invoice form.

## Context
- TRD.md
- lib/features/invoicing/data/invoice_repository.dart
- lib/features/invoicing/domain/gst_calculator.dart
- lib/main.dart

## Tasks

<task type="auto">
  <name>Build Invoices Dashboard Screen</name>
  <files>
    lib/features/invoicing/presentation/invoices_screen.dart
    lib/main.dart
  </files>
  <action>
    - Create `InvoicesScreen` with `DataTable2` showing Invoice No, Date, Company, Total, Status.
    - Wire it to `invoiceRepositoryProvider.watchAllInvoices()`.
    - Register it in `main.dart`'s sidebar navigation under Invoicing.
  </action>
  <verify>dart analyze lib/features/invoicing/presentation/invoices_screen.dart</verify>
  <done>Dashboard renders the invoice list stream from Drift.</done>
</task>

<task type="auto">
  <name>Build New Invoice Form UI</name>
  <files>
    lib/features/invoicing/presentation/new_invoice_screen.dart
    lib/features/invoicing/presentation/invoices_screen.dart
  </files>
  <action>
    - Setup `NewInvoiceScreen` (a new full-page Scaffold, pushed via Navigator from `InvoicesScreen`).
    - Top segment: Select Company (dropdown populated from CompanyRepository), Invoice No, and Date.
    - Middle segment: Dynamic List of Rows (Trip Date, GR No, Vehicle No, Loading, Unloading, Freight, Fastag). Allow Add/Remove rows.
    - Bottom segment: Show calculated Totals (Base, SGST, CGST, IGST, Payable) reacting actively to row changes using `GSTCalculator`.
    - Add "Save Invoice" button triggering Drift `insertInvoiceWithRows`.
  </action>
  <verify>dart analyze lib/features/invoicing/presentation/new_invoice_screen.dart</verify>
  <done>Form UI handles dynamic rows and complex state interactions.</done>
</task>

## Success Criteria
- [ ] User can see all invoices.
- [ ] User can create a new invoice with multiple freight rows.
- [ ] GST is actively previewed before saving.

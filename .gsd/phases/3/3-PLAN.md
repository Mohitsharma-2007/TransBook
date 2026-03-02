---
phase: 3
plan: 3
wave: 3
---

# Plan 3.3: Summary Bill Builder Engine

## Objective
Build the complex UI form that allows users to select a Company, define a Date Range, and automatically pull in all 'DRAFT' invoices matching those criteria to generate a unified Summary Bill.

## Context
- `e:\TransBook\lib\features\billing_management\presentation\new_summary_bill_screen.dart`
- `e:\TransBook\lib\features\billing_management\data\summary_bill_repository.dart`
- `e:\TransBook\lib\features\invoicing\data\invoice_repository.dart`

## Tasks

<task type="auto">
  <name>Query Draft Invoices by Company & Date</name>
  <files>
    - `e:\TransBook\lib\features\invoicing\data\invoice_repository.dart`
  </files>
  <action>
    - Add a method to `InvoiceRepository`: `Future<List<Invoice>> getDraftInvoicesForCompany(int companyId, String fromDate, String toDate)`
    - It should query drift for invoices where company_id = companyId, status = 'DRAFT', and invoice_date is between fromDate and toDate.
  </action>
  <verify>dart analyze lib/features/invoicing/data/invoice_repository.dart</verify>
  <done>Method exists to query eligible invoices for summary buffering.</done>
</task>

<task type="auto">
  <name>Build New Summary Bill Screen</name>
  <files>
    - `e:\TransBook\lib\features\billing_management\presentation\new_summary_bill_screen.dart`
    - `e:\TransBook\lib\features\billing_management\presentation\summary_bills_screen.dart`
  </files>
  <action>
    - Create `NewSummaryBillScreen`.
    - Provide dropdown for `Company` (using `companies` provider).
    - Provide Date Range pickers (`fromDate`, `toDate`).
    - Add a "Fetch Invoices" button that calls the new `getDraftInvoicesForCompany` method.
    - Display fetched invoices in a selectable list (Checkbox list).
    - Keep a running total of `payableAmount` for all selected invoices.
    - Add a "Generate Summary Bill" action button.
    - On generate: Build `SummaryBillsCompanion`, pass selected invoice IDs to `SummaryBillRepository.insertSummaryBill`, and pop the screen.
    - Update `SummaryBillsScreen` to navigate to `NewSummaryBillScreen` on "New Summary Bill" tap.
  </action>
  <verify>dart analyze lib/features/billing_management/presentation/</verify>
  <done>UI flows from selecting company to generating a compiled summary bill.</done>
</task>

## Success Criteria
- [ ] Users can query pending invoices for a specific company and date range.
- [ ] Users can select specific invoices to include in the summary.
- [ ] Generator saves the Summary Bill and marks the selected invoices as 'SUBMITTED'.

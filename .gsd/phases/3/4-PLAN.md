---
phase: 3
plan: 4
wave: 4
---

# Plan 3.4: Summary PDF Generation

## Objective
Implement `SummaryPdfGenerator` to create a unified PDF for a Summary Bill and its attached Invoices, showing a consolidated breakdown.

## Context
- `e:\TransBook\lib\features\pdf_excel\domain\summary_pdf_generator.dart`
- `e:\TransBook\lib\features\pdf_excel\domain\invoice_pdf_generator.dart` (for reference)
- `e:\TransBook\lib\features\billing_management\presentation\summary_bills_screen.dart`

## Tasks

<task type="auto">
  <name>Summary PDF Generator</name>
  <files>
    - `e:\TransBook\lib\features\pdf_excel\domain\summary_pdf_generator.dart`
  </files>
  <action>
    - Create `SummaryPdfGenerator` class with `generate(SummaryBillWithInvoices summaryData)` method.
    - Format a multi-page PDF.
    - Page 1: Cover letter / Summary Table.
      - Header: Firm Details.
      - Billed To: Company Details.
      - Table: List of attached invoices (Date, Invoice No, Total Freight, Total Fastag, GST, Total Amount).
      - Grand Totals (Base Amount, SGST, CGST/IGST, Total Payable).
      - Amount in words.
    - Subsequent pages: (Optional/Future: Attach individual invoice PDFs, but for now just the summary page is enough).
  </action>
  <verify>dart analyze lib/features/pdf_excel/domain/summary_pdf_generator.dart</verify>
  <done>Generator produces bytes for a formatted Summary Bill PDF.</done>
</task>

<task type="auto">
  <name>Hook Printing into Dashboard</name>
  <files>
    - `e:\TransBook\lib\features\billing_management\presentation\summary_bills_screen.dart`
  </files>
  <action>
    - Update the "Actions" column in `SummaryBillsScreen` `DataTable2` to include a Print icon.
    - On pressed: retrieve the full `SummaryBillWithInvoices` via repository, pass it to `SummaryPdfGenerator`, and call `Printing.layoutPdf`.
  </action>
  <verify>dart analyze lib/features/billing_management/presentation/summary_bills_screen.dart</verify>
  <done>Print icon handles generating and invoking Windows print dialogue for Summary Bills.</done>
</task>

## Success Criteria
- [ ] Users can print a consolidated Summary Bill reflecting all attached invoices.
- [ ] Code passes static analysis.

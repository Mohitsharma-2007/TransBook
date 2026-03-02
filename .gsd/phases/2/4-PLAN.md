---
phase: 2
plan: 4
wave: 4
---

# Plan 2.4: Invoice PDF Generation

## Objective
Implement native PDF rendering using the Dart `pdf` package to generate the physical invoice document.

## Context
- TRD.md (Section 6.1)
- lib/features/invoicing/data/invoice_repository.dart
- lib/core/utils/amount_in_words.dart

## Tasks

<task type="auto">
  <name>Implement PDF Generator Service</name>
  <files>
    lib/features/pdf_excel/domain/invoice_pdf_generator.dart
  </files>
  <action>
    - Use `pdf` package to construct an A4 page.
    - Create a generic Layout encompassing: 
      1. Hardcoded Firm Header (JSV Technologies). 
      2. Bill To (Company data). 
      3. A table iterating through `InvoiceRows`.
      4. Summary block at bottom right with GST split and Total Payable.
      5. "Amount In Words" output from our Util class.
    - Return `Uint8List` representing the PDF document.
  </action>
  <verify>dart analyze lib/features/pdf_excel/domain/invoice_pdf_generator.dart</verify>
  <done>PDF engine compiles and resolves elements successfully.</done>
</task>

<task type="auto">
  <name>Hook PDF Generator to Invoices Screen</name>
  <files>
    lib/features/invoicing/presentation/invoices_screen.dart
  </files>
  <action>
    - Add a Print/Export action button to each data row on the Dashboard.
    - Upon click, call `InvoicePdfGenerator` and pipe it to `printing` package's `Printing.layoutPdf` block to trigger native OS print dialiog.
  </action>
  <verify>dart analyze lib/features/invoicing/presentation/invoices_screen.dart</verify>
  <done>PDFs can be printed from the Dashboard view.</done>
</task>

## Success Criteria
- [ ] Standard invoice prints with correct GST mapping.
- [ ] User can trigger native Print OS dialogue directly from app.

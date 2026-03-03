---
phase: 6
plan: 3
wave: 3
---

# Plan 6.3: Record Book & Address Labels

## Objective
Build a Record Book screen (historical log of all invoices with filters/export) and an Address Labels generator.

## Context
- `e:\TransBook\lib\features\invoicing\data\invoice_repository.dart`

## Tasks

<task type="auto">
  <name>Record Book Screen</name>
  <files>
    - `e:\TransBook\lib\features\record_book\presentation\record_book_screen.dart`
    - `e:\TransBook\lib\main.dart`
  </files>
  <action>
    - Build `RecordBookScreen` showing a paginated DataTable2 of all invoices.
    - Filters: date range, company, status.
    - Columns: Invoice No, Date, Company, Amount, Status, Payment Received.
    - Add "Record Book" entry in sidebar.
  </action>
  <verify>dart analyze lib/features/record_book/presentation/ lib/main.dart</verify>
  <done>Record book shows filtered, paginated invoice history.</done>
</task>

<task type="auto">
  <name>Address Labels Generator</name>
  <files>
    - `e:\TransBook\lib\features\pdf_excel\domain\address_label_generator.dart`
  </files>
  <action>
    - Create `AddressLabelGenerator` using the `pdf` package.
    - Implement `Future<Uint8List> generateLabels(List<Company> companies)`.
    - Lay out labels on A4 in a 3×8 grid format (standard Avery labels).
    - Each label: Company name, address, GSTIN.
  </action>
  <verify>dart analyze lib/features/pdf_excel/domain/address_label_generator.dart</verify>
  <done>Label generator produces A4 PDF with company address labels.</done>
</task>

## Success Criteria
- [ ] Record Book screen in sidebar with date/company/status filters.
- [ ] Address label generator outputs A4 label sheets.
- [ ] Passes static analysis.

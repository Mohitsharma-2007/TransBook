---
phase: 6
plan: 2
wave: 2
---

# Plan 6.2: Reminders UI & Excel Generator

## Objective
Build the Reminders dashboard screen and the Excel invoice generator.

## Context
- `e:\TransBook\TRD.md` -> Section 11 (Excel Generator)
- `e:\TransBook\lib\features\reminders\data\reminder_repository.dart`

## Tasks

<task type="auto">
  <name>Reminders Screen</name>
  <files>
    - `e:\TransBook\lib\features\reminders\presentation\reminders_screen.dart`
    - `e:\TransBook\lib\main.dart`
  </files>
  <action>
    - Build `RemindersScreen` with a list/card view of pending reminders.
    - Show type badge, due date, escalation level, and resolve button.
    - Add "Reminders" entry in sidebar navigation.
  </action>
  <verify>dart analyze lib/features/reminders/presentation/ lib/main.dart</verify>
  <done>Reminders screen renders pending items and allows resolving.</done>
</task>

<task type="auto">
  <name>Excel Invoice Generator</name>
  <files>
    - `e:\TransBook\lib\features\pdf_excel\domain\excel_generator.dart`
  </files>
  <action>
    - Create `ExcelGenerator` using the `excel` package.
    - Implement `Future<Uint8List> generateInvoiceExcel(Invoice invoice)`.
    - Build a sheet matching the invoice layout: header row, freight rows, GST footer, totals.
    - Apply column widths, bold headers, and currency formatting.
    - Create riverpod `excelGeneratorProvider`.
  </action>
  <verify>dart analyze lib/features/pdf_excel/domain/excel_generator.dart</verify>
  <done>Excel generator produces .xlsx bytes from invoice data.</done>
</task>

## Success Criteria
- [ ] Reminders screen accessible from sidebar.
- [ ] Excel generator compiles and produces formatted spreadsheets.
- [ ] Passes static analysis.

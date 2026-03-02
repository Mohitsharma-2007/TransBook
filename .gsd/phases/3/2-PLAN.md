---
phase: 3
plan: 2
wave: 2
---

# Plan 3.2: Summary Bills Dashboard

## Objective
Create the main dashboard UI for viewing all Summary Bills, similar to the Invoices dashboard, and wire it into the main navigation shell.

## Context
- `e:\TransBook\lib\main.dart`
- `e:\TransBook\lib\features\billing_management\presentation\summary_bills_screen.dart`
- `e:\TransBook\lib\features\billing_management\data\summary_bill_repository.dart`
- `e:\TransBook\lib\core\constants\app_theme.dart`

## Tasks

<task type="auto">
  <name>Build Summary Bills UI</name>
  <files>
    - `e:\TransBook\lib\features\billing_management\presentation\summary_bills_screen.dart`
  </files>
  <action>
    - Create `SummaryBillsScreen` extending `ConsumerWidget`.
    - Use `DataTable2` to display the list of summary bills fetched from `summaryBillsProvider`.
    - Columns: Summary No, Period (From - To), Total Amount, Status, Actions (View/Print icon).
    - Add a "New Summary Bill" button in the header (which will navigate to an empty placeholder for now).
    - Include a status badge builder for 'DRAFT', 'SUBMITTED', 'PAID'.
  </action>
  <verify>dart analyze lib/features/billing_management/presentation/summary_bills_screen.dart</verify>
  <done>SummaryBillsScreen renders a data table of summary bills.</done>
</task>

<task type="auto">
  <name>Integrate into Main Shell</name>
  <files>
    - `e:\TransBook\lib\main.dart`
  </files>
  <action>
    - Import `SummaryBillsScreen`.
    - Add `SummaryBillsScreen()` as the 2nd item in the `_screens` list (index 1).
    - Map the navigation rail index 1 to "Summary Bills".
    - Adjust existing indices (Company, Vehicle, Rate Card) accordingly.
  </action>
  <verify>dart analyze lib/main.dart</verify>
  <done>Main shell navigation correctly routes to the new Summary Bills dashboard.</done>
</task>

## Success Criteria
- [ ] `SummaryBillsScreen` is built using `DataTable2`.
- [ ] Users can navigate to the Summary Bills dashboard from the sidebar.
- [ ] Passes static analysis.

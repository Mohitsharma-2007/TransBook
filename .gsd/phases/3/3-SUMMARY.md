# Plan 3.3 Summary
- Added `getDraftInvoicesForCompany(int, String, String)` to `InvoiceRepository` for filtering DRAFT invoices by company and date range.
- Built full `NewSummaryBillScreen` with company dropdown, date range pickers, invoice fetching, selectable invoice list, running total, and summary bill generation via `SummaryBillRepository`.
- Passes static analysis.

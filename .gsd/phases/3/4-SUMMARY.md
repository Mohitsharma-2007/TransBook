# Plan 3.4 Summary
- Created `SummaryPdfGenerator` producing A4 PDF with firm header, bill-to, consolidated invoice table, totals, amount in words, and footer.
- Wired Print button in `SummaryBillsScreen` to fetch full summary data and invoke `Printing.layoutPdf`.
- Passes static analysis.

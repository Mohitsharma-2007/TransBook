# Plan 3.1 Summary
- Modified `tables.dart` to introduce `SummaryBills` and the relational `SummaryBillInvoices` many-to-many junction table to map individual `Invoices` to `SummaryBills`.
- Generated `AppDatabase` extensions successfully.
- Created `SummaryBillWithInvoices` domain model wrapper.
- Implemented `SummaryBillRepository` utilizing `.transaction()` to ensure atomicity across Summary insert, relations insert, and Invoice state transition (`DRAFT` -> `SUBMITTED`).
- Wired up Riverpod providers for `watchAllSummaryBills`.
- Code passed static verification.

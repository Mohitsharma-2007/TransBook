---
phase: 2
plan: 2
wave: 2
---

# Plan 2.2: GST & Business Logic Utilities

## Objective
Implement standalone business logic units for calculating complex Indian GST/TDS tax models and converting numbers into words for printing.

## Context
- TRD.md (Sections 4.1 and 4.3)
- lib/features/invoicing/data/invoice_repository.dart

## Tasks

<task type="auto">
  <name>Implement GST Calculator</name>
  <files>lib/features/invoicing/domain/gst_calculator.dart</files>
  <action>
    - Construct `GSTCalculator` class exactly as described in TRD.md 4.1.
    - It must accept a baseAmount and `InvoiceType` (string constant matching STATE or INTER_STATE).
    - It must return a `GSTResult` object holding sgst, cgst, igst, and total.
  </action>
  <verify>dart analyze lib/features/invoicing/domain/gst_calculator.dart</verify>
  <done>GSTCalculator class is complete and type-safe.</done>
</task>

<task type="auto">
  <name>Implement Indian Amount in Words</name>
  <files>lib/core/utils/amount_in_words.dart</files>
  <action>
    - Create `IndianAmountWords.convert(double amount)` returning Indian numbering system words (Lakhs, Crores, Rupees).
    - Ensure it handles decimal (paise) safely.
  </action>
  <verify>dart analyze lib/core/utils/amount_in_words.dart</verify>
  <done>Utility class is ready for PDF usage.</done>
</task>

## Success Criteria
- [ ] Tax calculations mirror the logic laid out in the TRD.
- [ ] Amount to words generates valid Indian strings.

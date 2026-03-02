# Plan 2.4 Summary
- Implemented `InvoicePdfGenerator` using `pdf` dart package.
- Formatted A4 layout mapping to physical PDF requirements, integrating Company bill-to data, dynamic invoice freight rows, and automated GST splitting.
- Hooked `printing` package into `InvoicesScreen` actions to trigger the native OS print dialogue dynamically.

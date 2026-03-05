import '../../../core/database/database.dart';

class SummaryBillWithInvoices {
  final SummaryBill summaryBill;
  final List<Invoice> invoices;
  final List<InvoiceRow> invoiceRows;
  final Company? company;

  SummaryBillWithInvoices({
    required this.summaryBill,
    required this.invoices,
    required this.invoiceRows,
    this.company,
  });
}

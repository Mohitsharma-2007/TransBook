import '../../../core/database/database.dart';

class SummaryBillWithInvoices {
  final SummaryBill summaryBill;
  final List<Invoice> invoices;
  final Company? company;

  SummaryBillWithInvoices({
    required this.summaryBill,
    required this.invoices,
    this.company,
  });
}

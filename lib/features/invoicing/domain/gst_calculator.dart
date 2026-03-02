import '../../../../core/constants/app_constants.dart';

class GSTResult {
  final double sgst;
  final double cgst;
  final double igst;
  final double total;

  const GSTResult({
    required this.sgst,
    required this.cgst,
    required this.igst,
    required this.total,
  });
}

class GSTCalculator {
  static const double stateRate = 2.5;     // Each: SGST + CGST
  static const double interStateRate = 5.0; // IGST

  static GSTResult calculate(double baseAmount, String invoiceType) {
    if (invoiceType == InvoiceType.state) {
      final sgst = baseAmount * stateRate / 100;
      final cgst = baseAmount * stateRate / 100;
      return GSTResult(sgst: sgst, cgst: cgst, igst: 0, total: sgst + cgst);
    } else {
      final igst = baseAmount * interStateRate / 100;
      return GSTResult(sgst: 0, cgst: 0, igst: igst, total: igst);
    }
  }
}

import '../../../core/database/database.dart';

class AIContextBuilder {
  /// Build context string from a specific invoice and its company.
  String buildInvoiceContext(Invoice invoice, Company company) {
    return '''
You are a billing assistant for a transportation logistics firm.

CURRENT CONTEXT:
- Invoice Number: ${invoice.invoiceNumber ?? 'N/A'}
- Invoice Date: ${invoice.invoiceDate ?? 'N/A'}
- Company: ${company.name}
- GSTIN: ${company.gstin ?? 'N/A'}
- Total Freight: ₹${invoice.totalFreight}
- Total Fastag: ₹${invoice.totalFastag}
- SGST: ₹${invoice.sgstAmount}, CGST: ₹${invoice.cgstAmount}, IGST: ₹${invoice.igstAmount}
- Payable Amount: ₹${invoice.payableAmount}
- TDS Deducted: ₹${invoice.tdsAmount}
- Status: ${invoice.status}

Answer questions clearly and concisely with reference to the data above.
''';
  }

  /// Build a global summary context for general queries.
  String buildGlobalContext(List<Invoice> recentInvoices) {
    final totalRevenue = recentInvoices.fold<double>(0, (sum, i) => sum + i.payableAmount);
    final draftCount = recentInvoices.where((i) => i.status == 'DRAFT').length;
    final submittedCount = recentInvoices.where((i) => i.status == 'SUBMITTED').length;
    final paidCount = recentInvoices.where((i) => i.status == 'PAID').length;

    return '''
You are a billing assistant for a transportation logistics firm.

BUSINESS OVERVIEW:
- Total invoices: ${recentInvoices.length}
- Draft: $draftCount | Submitted: $submittedCount | Paid: $paidCount
- Total Revenue: ₹${totalRevenue.toStringAsFixed(2)}

RECENT INVOICES:
${recentInvoices.take(10).map((i) => '  • ${i.invoiceNumber ?? 'N/A'} — ₹${i.payableAmount} — ${i.status}').join('\n')}

Answer questions about billing, invoices, payments, and logistics clearly and concisely.
''';
  }
}

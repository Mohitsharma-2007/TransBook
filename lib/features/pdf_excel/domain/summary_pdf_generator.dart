import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../billing_management/domain/summary_bill_models.dart';
import '../../../core/utils/amount_in_words.dart';

class SummaryPdfGenerator {
  static Future<Uint8List> generate(SummaryBillWithInvoices data) async {
    final pdf = pw.Document();
    final summary = data.summaryBill;
    final company = data.company;
    final invoices = data.invoices;

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(summary),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildBillTo(company),
          pw.SizedBox(height: 10),
          pw.Text('Period: ${summary.periodFrom ?? ''} to ${summary.periodTo ?? ''}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          _buildInvoiceTable(invoices, currencyFormat),
          pw.SizedBox(height: 20),
          _buildTotals(summary, currencyFormat),
          pw.SizedBox(height: 20),
          _buildAmountInWords(summary),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(dynamic summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'JSV TECHNOLOGIES',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
        ),
        pw.Text('123 Logistics Park, Highway Road, India'),
        pw.Text('GSTIN: 07AAXCSXXXX1Z5 | Phone: +91 9876543210'),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SUMMARY BILL',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Summary No: ${summary.summaryNumber ?? '-'}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Date: ${summary.createdAt?.substring(0, 10) ?? '-'}'),
              ],
            ),
          ],
        ),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildBillTo(dynamic company) {
    if (company == null) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Billed To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(company.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        if (company.address != null && company.address!.isNotEmpty) pw.Text(company.address!),
        if (company.gstin != null) pw.Text('GSTIN: ${company.gstin}'),
      ],
    );
  }

  static pw.Widget _buildInvoiceTable(List<dynamic> invoices, NumberFormat currencyFormat) {
    return pw.TableHelper.fromTextArray(
      headers: ['S.No', 'Invoice No', 'Date', 'Freight', 'Fastag', 'GST', 'Total Payable'],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
      },
      data: List<List<String>>.generate(
        invoices.length,
        (index) {
          final inv = invoices[index];
          final gst = (inv.sgstAmount ?? 0) + (inv.cgstAmount ?? 0) + (inv.igstAmount ?? 0);
          return [
            '${index + 1}',
            inv.invoiceNumber ?? '-',
            inv.invoiceDate ?? '-',
            currencyFormat.format(inv.totalFreight ?? 0),
            currencyFormat.format(inv.totalFastag ?? 0),
            currencyFormat.format(gst),
            currencyFormat.format(inv.payableAmount ?? 0),
          ];
        },
      ),
    );
  }

  static pw.Widget _buildTotals(dynamic summary, NumberFormat currencyFormat) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildTotalRow('Total Amount', summary.totalAmount, currencyFormat),
            _buildTotalRow('TDS Deducted', summary.tdsAmount, currencyFormat),
            pw.Divider(),
            _buildTotalRow('Net Payable', summary.payableAmount, currencyFormat, isBold: true),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, dynamic amount, NumberFormat currencyFormat, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.Text(currencyFormat.format(amount ?? 0), style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }

  static pw.Widget _buildAmountInWords(dynamic summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
      child: pw.Row(
        children: [
          pw.Text('Amount in Words: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Expanded(
            child: pw.Text(summary.amountInWords ?? IndianAmountWords.convert((summary.payableAmount ?? 0).toDouble())),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Bank Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Bank: HDFC Bank'),
            pw.Text('A/C No: 12345678901234'),
            pw.Text('IFSC: HDFC0001234'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('For JSV TECHNOLOGIES', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
            pw.Text('Authorised Signatory'),
          ],
        ),
      ],
    );
  }
}

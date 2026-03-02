import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../invoicing/data/invoice_repository.dart';
import '../../../core/utils/amount_in_words.dart';

class InvoicePdfGenerator {
  static Future<Uint8List> generate(InvoiceWithRows invoiceData) async {
    final pdf = pw.Document();
    
    final invoice = invoiceData.invoice;
    final rows = invoiceData.rows;

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '');
    
    // Sort rows by rowOrder
    rows.sort((a, b) => (a.rowOrder ?? 0).compareTo(b.rowOrder ?? 0));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(invoiceData),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildBillTo(invoiceData),
          pw.SizedBox(height: 20),
          _buildDataTable(rows, currencyFormat),
          pw.SizedBox(height: 10),
          _buildTotals(invoice, currencyFormat),
          pw.SizedBox(height: 20),
          _buildAmountInWords(invoice),
          pw.SizedBox(height: 30),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(InvoiceWithRows invoiceData) {
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
              'TAX INVOICE',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Invoice No: ${invoiceData.invoice.invoiceNumber}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Date: ${invoiceData.invoice.invoiceDate}'),
              ],
            ),
          ],
        ),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _buildBillTo(InvoiceWithRows invoiceData) {
    final company = invoiceData.company;
    if (company == null) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Billed To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(company.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        if (company.address != null && company.address!.isNotEmpty) pw.Text(company.address!),
        if (company.state != null) pw.Text('State: ${company.state} (Code: ${company.stateCode ?? ''})'),
        if (company.gstin != null) pw.Text('GSTIN: ${company.gstin}'),
      ],
    );
  }

  static pw.Widget _buildDataTable(List<dynamic> rows, NumberFormat currencyFormat) {
    return pw.TableHelper.fromTextArray(
      headers: ['S.No', 'Date', 'GR No', 'Vehicle', 'From', 'To', 'Freight', 'Fastag', 'Total'],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
      },
      data: List<List<String>>.generate(
        rows.length,
        (index) {
          final row = rows[index];
          return [
            '${index + 1}',
            row.tripDate ?? '',
            row.grNumber ?? '',
            row.vehicleNoText ?? '',
            row.loadingPlace ?? '',
            row.unloadingPlace ?? '',
            currencyFormat.format(row.freightCharge),
            currencyFormat.format(row.fastagCharge),
            currencyFormat.format(row.rowAmount),
          ];
        },
      ),
    );
  }

  static pw.Widget _buildTotals(dynamic invoice, NumberFormat currencyFormat) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildTotalRow('Base Amount', invoice.totalAmount, currencyFormat),
            if (invoice.invoiceType == 'STATE') ...[
              _buildTotalRow('SGST (${invoice.sgstRate}%)', invoice.sgstAmount, currencyFormat),
              _buildTotalRow('CGST (${invoice.cgstRate}%)', invoice.cgstAmount, currencyFormat),
            ] else ...[
              _buildTotalRow('IGST (${invoice.igstRate}%)', invoice.igstAmount, currencyFormat),
            ],
            pw.Divider(),
            _buildTotalRow('Total Payable', invoice.payableAmount, currencyFormat, isBold: true),
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

  static pw.Widget _buildAmountInWords(dynamic invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        children: [
          pw.Text('Amount in Words: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Expanded(
            child: pw.Text(invoice.amountInWords ?? IndianAmountWords.convert(invoice.payableAmount ?? 0)),
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
            pw.SizedBox(height: 10),
            pw.Text('Declaration:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.Text('We declare that this invoice shows the actual price of the goods', style: pw.TextStyle(fontSize: 10)),
            pw.Text('described and that all particulars are true and correct.', style: pw.TextStyle(fontSize: 10)),
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

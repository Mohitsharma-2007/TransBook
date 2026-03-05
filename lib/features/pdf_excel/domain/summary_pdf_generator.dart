import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../billing_management/domain/summary_bill_models.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../../core/utils/amount_in_words.dart';
import './pdf_template_config.dart';

class SummaryPdfGenerator {
  static Future<Uint8List> generate(
    SummaryBillWithInvoices data, 
    UserProfile profile, {
    PdfTemplateConfig? config,
  }) async {
    final pdf = pw.Document();
    final cfg = config ?? PdfTemplateConfig.defaultConfig();
    final primaryColor = PdfColor.fromInt(cfg.primaryColorHex);
    final summary = data.summaryBill;
    final invoices = data.invoices;

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildHeaderBox(data, profile, cfg, primaryColor),
          pw.SizedBox(height: 8),
          pw.Text('Billing Period: ${summary.periodFrom ?? ''} to ${summary.periodTo ?? ''}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.SizedBox(height: 8),
          _buildInvoiceTable(invoices, currencyFormat, cfg, primaryColor),
          _buildTotals(summary, currencyFormat, cfg, primaryColor),
          pw.SizedBox(height: 10),
          _buildFooter(profile, cfg, primaryColor),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeaderBox(SummaryBillWithInvoices data, UserProfile profile, PdfTemplateConfig config, PdfColor primaryColor) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            alignment: pw.Alignment.center,
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1)),
            ),
            child: pw.Text('SUMMARY BILL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(profile.companyName.isNotEmpty ? profile.companyName : 'YOUR COMPANY NAME', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                      if (profile.address.isNotEmpty) pw.Text(profile.address, style: pw.TextStyle(fontSize: 10)),
                      pw.Text([
                        if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
                        if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
                      ].join(' | '), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      if (profile.phone.isNotEmpty || profile.email.isNotEmpty) 
                        pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join(' | '), style: const pw.TextStyle(fontSize: 10)),
                      if (profile.website.isNotEmpty) pw.Text('Web: ${profile.website}', style: const pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              pw.Container(width: 1, color: PdfColors.black, height: 100),
              pw.Expanded(
                flex: 2,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Summary No:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          pw.Text(data.summaryBill.summaryNumber ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Date:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          pw.Text(data.summaryBill.createdAt?.substring(0, 10) ?? '-', style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
          // Billed To
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Billed To / Party Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 2),
                pw.Text(data.company?.name ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                if (data.company?.address != null && data.company!.address!.isNotEmpty)
                  pw.Text(data.company!.address!, style: pw.TextStyle(fontSize: 10)),
                pw.Text('State Component: ${data.company?.state ?? ''} (${data.company?.stateCode ?? ''})', style: pw.TextStyle(fontSize: 10)),
                pw.Text('GSTIN: ${data.company?.gstin ?? 'Unregistered'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceTable(List<dynamic> invoices, NumberFormat currencyFormat, PdfTemplateConfig config, PdfColor primaryColor) {
    return pw.TableHelper.fromTextArray(
      headers: ['S.NO', 'INVOICE NO.', 'DATE', 'FREIGHT', 'FASTAG', 'GST', 'TOTAL PAYABLE'],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 25,
      border: pw.TableBorder.all(color: PdfColors.black, width: 1),
      cellAlignments: {
        0: pw.Alignment.center,
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

  static pw.Widget _buildTotals(dynamic summary, NumberFormat currencyFormat, PdfTemplateConfig config, PdfColor primaryColor) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor, width: 1),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 6,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text('Amount in Words:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                  pw.Text(
                    summary.amountInWords ?? IndianAmountWords.convert((summary.payableAmount ?? 0).toDouble()),
                    style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          pw.Container(width: 1, color: PdfColors.black, height: 75),
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              child: pw.Column(
                children: [
                  _buildTotalRow('Total Amount', summary.totalAmount, currencyFormat),
                  pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
                  _buildTotalRow('TDS Deducted', summary.tdsAmount, currencyFormat),
                  pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
                  _buildTotalRow('Net Payable', summary.payableAmount, currencyFormat, isBold: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, dynamic amount, NumberFormat currencyFormat, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9)),
          pw.Text(currencyFormat.format(amount ?? 0), style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 9)),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(UserProfile profile, PdfTemplateConfig config, PdfColor primaryColor) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor, width: 1),
      ),
      child: pw.Row(
        children: [
          // Bank Details
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bank Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.SizedBox(height: 2),
                  if (profile.bankDetails.isNotEmpty) pw.Text(profile.bankDetails, style: pw.TextStyle(fontSize: 10)) else pw.Text('Please configure bank details in Profile Settings', style: pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
          pw.Container(width: 1, color: PdfColors.black, height: 100),
          // Signature
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('For ${profile.companyName.isNotEmpty ? profile.companyName.toUpperCase() : 'YOUR COMPANY'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.SizedBox(height: 50),
                  pw.Text('Authorised Signatory', style: pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../invoicing/data/invoice_repository.dart';
import '../../profile/data/user_profile_repository.dart';
import './pdf_template_config.dart';
import '../../../core/utils/amount_in_words.dart';
import '../../../core/constants/app_constants.dart';

class InvoicePdfGenerator {
  static Future<Uint8List> generate(
    InvoiceWithRows invoiceData, 
    UserProfile profile, {
    PdfTemplateConfig? config,
  }) async {
    final pdf = pw.Document();
    final cfg = config ?? PdfTemplateConfig.defaultConfig();
    final primaryColor = PdfColor.fromInt(cfg.primaryColorHex);
    
    final invoice = invoiceData.invoice;
    final rows = invoiceData.rows;

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '');
    
    rows.sort((a, b) => (a.rowOrder ?? 0).compareTo(b.rowOrder ?? 0));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildHeaderBox(invoiceData, profile, cfg, primaryColor),
          pw.SizedBox(height: 8),
          _buildDataTable(rows, currencyFormat, cfg, primaryColor),
          _buildTotals(invoice, currencyFormat, cfg, primaryColor),
          pw.SizedBox(height: 10),
          _buildFooter(profile, cfg, primaryColor),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeaderBox(InvoiceWithRows invoiceData, UserProfile profile, PdfTemplateConfig config, PdfColor primaryColor) {
    // Luxury style uses a different header layout
    if (config.style == InvoiceTemplateStyle.luxury) {
       return _buildLuxuryHeader(invoiceData, profile, primaryColor);
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // Top Title
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            alignment: pw.Alignment.center,
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1)),
            ),
            child: pw.Text('TAX INVOICE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          ),
          // Company Info & JSV Logo Placeholder
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
                      if (profile.gstin.isNotEmpty) pw.Text('GSTIN: ${profile.gstin}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
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
                          pw.Text('Invoice No:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          pw.Text(invoiceData.invoice.invoiceNumber, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Date:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          pw.Text(invoiceData.invoice.invoiceDate, style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Reverse Charge:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          pw.Text('N', style: pw.TextStyle(fontSize: 10)),
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
                pw.Text(invoiceData.company?.name ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                if (invoiceData.company?.address != null && invoiceData.company!.address!.isNotEmpty)
                  pw.Text(invoiceData.company!.address!, style: pw.TextStyle(fontSize: 10)),
                pw.Text('State Component: ${invoiceData.company?.state ?? ''} (${invoiceData.company?.stateCode ?? ''})', style: pw.TextStyle(fontSize: 10)),
                pw.Text('GSTIN: ${invoiceData.company?.gstin ?? 'Unregistered'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDataTable(List<dynamic> rows, NumberFormat currencyFormat, PdfTemplateConfig config, PdfColor primaryColor) {
    final headers = ['S.NO'];
    if (config.showTripDate) headers.add('DATE');
    headers.add('G.R NO.');
    if (config.showVehicleNo) headers.add('VEHICLE NO.');
    headers.addAll(['LOADING PLACE', 'UNLOADING PLACE', 'FREIGHT CHARGE', 'FASTAG CHARGE', 'AMOUNT']);

    return pw.TableHelper.fromTextArray(
      headers: headers,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 25,
      border: pw.TableBorder.all(color: PdfColors.black, width: 1),
      cellAlignments: {
        0: pw.Alignment.center,
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
          final data = ['${index + 1}'];
          if (config.showTripDate) data.add(row.tripDate ?? '');
          data.add(row.grNumber ?? '');
          if (config.showVehicleNo) data.add(row.vehicleNoText ?? '');
          data.addAll([
            row.loadingPlace ?? '',
            row.unloadingPlace ?? '',
            currencyFormat.format(row.freightCharge),
            currencyFormat.format(row.fastagCharge),
            currencyFormat.format(row.rowAmount),
          ]);
          return data;
        },
      ),
    );
  }

  static pw.Widget _buildTotals(dynamic invoice, NumberFormat currencyFormat, PdfTemplateConfig config, PdfColor primaryColor) {
    final bool isState = invoice.invoiceType == InvoiceType.state;
    
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
                    invoice.amountInWords ?? IndianAmountWords.convert(invoice.payableAmount ?? 0),
                    style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          pw.Container(width: 1, color: PdfColors.black, height: 100),
          pw.Expanded(
            flex: 4,
            child: pw.Container(
              child: pw.Column(
                children: [
                  _buildTotalRow('Base Amount', invoice.totalAmount, currencyFormat),
                  pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
                  
                  if (isState) ...[
                    _buildTotalRow('SGST (${invoice.sgstRate}%)', invoice.sgstAmount, currencyFormat),
                    pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
                    _buildTotalRow('CGST (${invoice.cgstRate}%)', invoice.cgstAmount, currencyFormat),
                  ] else ...[
                    _buildTotalRow('IGST (${invoice.igstRate}%)', invoice.igstAmount, currencyFormat),
                  ],
                  
                  pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
                  _buildTotalRow('Total Payable', invoice.payableAmount, currencyFormat, isBold: true),
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
                  pw.SizedBox(height: 10),
                  pw.Text('Declaration:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                  pw.Text('We declare that this invoice shows the actual price of the goods described and that all particulars are true and correct.', style: pw.TextStyle(fontSize: 8)),
                ],
              ),
            ),
          ),
          pw.Container(width: 1, color: PdfColors.black, height: 120),
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

  static pw.Widget _buildLuxuryHeader(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(12)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(profile.companyName.toUpperCase(), style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(profile.address, style: pw.TextStyle(color: PdfColors.white.withAlpha(200), fontSize: 10)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('INVOICE', style: pw.TextStyle(color: PdfColors.white, fontSize: 32, fontWeight: pw.FontWeight.bold)),
              pw.Text('#${invoiceData.invoice.invoiceNumber}', style: pw.TextStyle(color: PdfColors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

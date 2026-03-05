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

    final isLandscape = cfg.pageOrientation == PdfPageOrientation.landscape;
    final pageFormat = isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;
    final margin = isLandscape
        ? const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 18)
        : const pw.EdgeInsets.all(24);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: margin,
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
    switch (config.layoutVariant) {
      case PdfLayoutVariant.letterheadTop:
        return _buildLetterheadHeader(invoiceData, profile, primaryColor, config);
      case PdfLayoutVariant.headerBand:
        return _buildHeaderBandLayout(invoiceData, profile, primaryColor, config);
      case PdfLayoutVariant.doubleBorder:
        return _buildDoubleBorderHeader(invoiceData, profile, primaryColor, config);
      case PdfLayoutVariant.compact:
        return _buildCompactHeader(invoiceData, profile, primaryColor, config);
      default:
        return _buildStandardHeader(invoiceData, profile, primaryColor, config);
    }
  }

  // ── Standard (single-border) ────────────────────────────────────────────
  static pw.Widget _buildStandardHeader(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor, PdfTemplateConfig config) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 1)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          alignment: pw.Alignment.center,
          decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1))),
          child: pw.Text('TAX INVOICE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        ),
        pw.Row(children: [
          pw.Expanded(flex: 3, child: pw.Container(padding: const pw.EdgeInsets.all(8),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(profile.companyName.isNotEmpty ? profile.companyName : 'YOUR COMPANY', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: primaryColor)),
              if (profile.address.isNotEmpty) pw.Text(profile.address, style: const pw.TextStyle(fontSize: 10)),
              pw.Text([
                if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
                if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
              ].join(' | '), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              if (profile.phone.isNotEmpty || profile.email.isNotEmpty) 
                pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join(' | '), style: const pw.TextStyle(fontSize: 9)),
              if (profile.website.isNotEmpty) pw.Text('Web: ${profile.website}', style: const pw.TextStyle(fontSize: 9)),
            ]),
          )),
          pw.Container(width: 1, color: PdfColors.black, height: 100),
          pw.Expanded(flex: 2, child: _buildInvoiceMetaCol(invoiceData)),
        ]),
        pw.Divider(color: PdfColors.black, thickness: 1, height: 1),
        _buildBilledToSection(invoiceData),
      ]),
    );
  }

  // ── Full-width header band ────────────────────────────────────────────────
  static pw.Widget _buildHeaderBandLayout(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor, PdfTemplateConfig config) {
    final textColor = PdfColor.fromInt(config.headerTextColorHex);
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      pw.Container(
        color: primaryColor,
        padding: const pw.EdgeInsets.all(12),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(profile.companyName.isNotEmpty ? profile.companyName : 'YOUR COMPANY', style: pw.TextStyle(color: textColor, fontSize: 22, fontWeight: pw.FontWeight.bold)),
            if (profile.address.isNotEmpty) pw.Text(profile.address, style: pw.TextStyle(color: textColor, fontSize: 9)),
            pw.Text([
              if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
              if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
            ].join('  |  '), style: pw.TextStyle(color: textColor, fontSize: 9, fontWeight: pw.FontWeight.bold)),
            if (profile.phone.isNotEmpty || profile.email.isNotEmpty)
              pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join('  |  '), style: pw.TextStyle(color: textColor, fontSize: 8)),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('TAX INVOICE', style: pw.TextStyle(color: textColor, fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text('# ${invoiceData.invoice.invoiceNumber}', style: pw.TextStyle(color: textColor, fontSize: 13)),
            pw.Text(invoiceData.invoice.invoiceDate, style: pw.TextStyle(color: textColor, fontSize: 11)),
          ]),
        ]),
      ),
      pw.SizedBox(height: 4),
      pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 0.5)),
        child: _buildBilledToSection(invoiceData),
      ),
    ]);
  }

  // ── Double-border ─────────────────────────────────────────────────────────
  static pw.Widget _buildDoubleBorderHeader(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor, PdfTemplateConfig config) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 2)),
      child: pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 0.5)),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.symmetric(vertical: 5),
            color: primaryColor,
            child: pw.Text('TAX INVOICE', style: pw.TextStyle(color: PdfColor.fromInt(config.headerTextColorHex), fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 3)),
          ),
          pw.Row(children: [
            pw.Expanded(flex: 3, child: pw.Container(padding: const pw.EdgeInsets.all(8),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(profile.companyName.isNotEmpty ? profile.companyName : 'YOUR COMPANY', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                if (profile.address.isNotEmpty) pw.Text(profile.address, style: const pw.TextStyle(fontSize: 9)),
                pw.Text([
                  if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
                  if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
                ].join(' | '), style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                if (profile.phone.isNotEmpty || profile.email.isNotEmpty) 
                  pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join(' | '), style: const pw.TextStyle(fontSize: 8)),
              ]),
            )),
            pw.Container(width: 0.5, color: primaryColor, height: 80),
            pw.Expanded(flex: 2, child: _buildInvoiceMetaCol(invoiceData)),
          ]),
          pw.Container(height: 0.5, color: primaryColor),
          _buildBilledToSection(invoiceData),
        ]),
      ),
    );
  }

  // ── Letterhead-style tall header ───────────────────────────────────────────
  static pw.Widget _buildLetterheadHeader(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor, PdfTemplateConfig config) {
    final textColor = PdfColor.fromInt(config.headerTextColorHex);
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      pw.Container(
        height: 80,
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          gradient: pw.LinearGradient(colors: [primaryColor, PdfColor.fromInt(config.accentColorHex)]),
        ),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text(profile.companyName.toUpperCase(), style: pw.TextStyle(color: textColor, fontSize: 24, fontWeight: pw.FontWeight.bold, letterSpacing: 1.5)),
            pw.SizedBox(height: 4),
            if (profile.address.isNotEmpty) pw.Text(profile.address, style: pw.TextStyle(color: textColor, fontSize: 9)),
            pw.Text([
              if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
              if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
            ].join(' | '), style: pw.TextStyle(color: textColor, fontSize: 9, fontWeight: pw.FontWeight.bold)),
            if (profile.phone.isNotEmpty || profile.email.isNotEmpty)
              pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join(' | '), style: pw.TextStyle(color: textColor, fontSize: 8)),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text('INVOICE', style: pw.TextStyle(color: textColor, fontSize: 28, fontWeight: pw.FontWeight.bold)),
            pw.Text('#${invoiceData.invoice.invoiceNumber}', style: pw.TextStyle(color: textColor, fontSize: 14)),
            pw.Text(invoiceData.invoice.invoiceDate, style: pw.TextStyle(color: textColor, fontSize: 11)),
          ]),
        ]),
      ),
      pw.SizedBox(height: 6),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 0.5)),
        child: _buildBilledToSection(invoiceData),
      ),
    ]);
  }

  // ── Compact header ─────────────────────────────────────────────────────────
  static pw.Widget _buildCompactHeader(InvoiceWithRows invoiceData, UserProfile profile, PdfColor primaryColor, PdfTemplateConfig config) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: primaryColor, width: 0.8)),
      padding: const pw.EdgeInsets.all(6),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(flex: 3, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(profile.companyName, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
          pw.Text([
            if (profile.gstin.isNotEmpty) 'GSTIN: ${profile.gstin}',
            if (profile.pan.isNotEmpty) 'PAN: ${profile.pan}',
            if (profile.address.isNotEmpty) profile.address,
          ].join(' | '), style: const pw.TextStyle(fontSize: 8)),
          if (profile.phone.isNotEmpty || profile.email.isNotEmpty)
            pw.Text([if (profile.phone.isNotEmpty) 'Tel: ${profile.phone}', if (profile.email.isNotEmpty) 'Email: ${profile.email}'].join(' | '), style: const pw.TextStyle(fontSize: 8)),
          pw.SizedBox(height: 4),
          pw.Text('Bill To: ${invoiceData.company?.name ?? ''}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.Text('GSTIN: ${invoiceData.company?.gstin ?? 'Unregistered'}', style: const pw.TextStyle(fontSize: 8)),
        ])),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('TAX INVOICE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: primaryColor)),
          pw.Text('# ${invoiceData.invoice.invoiceNumber}', style: const pw.TextStyle(fontSize: 10)),
          pw.Text(invoiceData.invoice.invoiceDate, style: const pw.TextStyle(fontSize: 9)),
        ]),
      ]),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────
  static pw.Widget _buildInvoiceMetaCol(InvoiceWithRows invoiceData) {
    metaRow(String label, String value) => pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text('$label:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
    ]);
    return pw.Container(padding: const pw.EdgeInsets.all(8), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      metaRow('Invoice No', invoiceData.invoice.invoiceNumber),
      pw.SizedBox(height: 4),
      metaRow('Date', invoiceData.invoice.invoiceDate),
      pw.SizedBox(height: 4),
      metaRow('Reverse Charge', 'N'),
    ]));
  }

  static pw.Widget _buildBilledToSection(InvoiceWithRows invoiceData) {
    return pw.Container(padding: const pw.EdgeInsets.all(8), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('Billed To / Party Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
      pw.SizedBox(height: 2),
      pw.Text(invoiceData.company?.name ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
      if (invoiceData.company?.address != null && invoiceData.company!.address!.isNotEmpty)
        pw.Text(invoiceData.company!.address!, style: const pw.TextStyle(fontSize: 9)),
      pw.Text('State: ${invoiceData.company?.state ?? ''} (${invoiceData.company?.stateCode ?? ''})', style: const pw.TextStyle(fontSize: 9)),
      pw.Text('GSTIN: ${invoiceData.company?.gstin ?? 'Unregistered'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
    ]));
  }

  static pw.Widget _buildDataTable(List<dynamic> rows, NumberFormat currencyFormat, PdfTemplateConfig config, PdfColor primaryColor) {
    final headers = ['S.NO'];
    if (config.showTripDate) headers.add('DATE');
    headers.add('G.R NO.');
    if (config.showVehicleNo) headers.add('VEHICLE NO.');
    headers.addAll(['LOADING PLACE', 'UNLOADING PLACE', 'FREIGHT CHARGE', 'FASTAG CHARGE', 'AMOUNT']);

    final isZebra = config.layoutVariant == PdfLayoutVariant.zebra;
    final isStripe = config.layoutVariant == PdfLayoutVariant.stripedRows;

    // Build data list
    final dataRows = List<List<String>>.generate(rows.length, (index) {
      final row = rows[index];
      final data = ['${index + 1}'];
      if (config.showTripDate) data.add(row.tripDate ?? '');
      data.add(row.grNumber ?? '');
      if (config.showVehicleNo) data.add(row.vehicleNoText ?? '');
      data.addAll([
        row.loadingPlace ?? '', row.unloadingPlace ?? '',
        currencyFormat.format(row.freightCharge),
        currencyFormat.format(row.fastagCharge),
        currencyFormat.format(row.rowAmount),
      ]);
      return data;
    });

    return pw.TableHelper.fromTextArray(
      headers: headers,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.white),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 25,
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.8),
      cellAlignments: {
        0: pw.Alignment.center, 1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft, 3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft, 5: pw.Alignment.centerLeft,
        6: pw.Alignment.centerRight, 7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
      },
      data: dataRows,
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
              pw.Text(profile.address, style: pw.TextStyle(color: const PdfColor(1, 1, 1, 0.78), fontSize: 10)),
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

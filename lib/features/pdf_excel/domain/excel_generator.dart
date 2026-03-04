import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database.dart';

class ExcelGenerator {
  /// Generate an Excel file for a single invoice.
  Future<Uint8List> generateInvoiceExcel(Invoice invoice, List<InvoiceRow> rows) async {
    final excel = Excel.createExcel();
    final sheet = excel['Invoice'];

    // Header
    _setCell(sheet, 0, 0, 'Invoice Number', bold: true);
    _setCell(sheet, 0, 1, invoice.invoiceNumber);
    _setCell(sheet, 0, 3, 'Invoice Date', bold: true);
    _setCell(sheet, 0, 4, invoice.invoiceDate);

    _setCell(sheet, 1, 0, 'Status', bold: true);
    _setCell(sheet, 1, 1, invoice.status);

    // Column headers for rows
    const headers = ['S.No', 'GR No', 'GR Date', 'Vehicle No', 'From', 'To', 'Freight', 'Fastag', 'Other Charges'];
    for (var i = 0; i < headers.length; i++) {
      _setCell(sheet, 3, i, headers[i], bold: true);
    }

    // Data rows
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      _setCell(sheet, 4 + i, 0, '${i + 1}');
      _setCell(sheet, 4 + i, 1, row.grNumber ?? '');
      _setCell(sheet, 4 + i, 2, row.tripDate ?? '');
      _setCell(sheet, 4 + i, 3, row.vehicleNoText ?? '');
      _setCell(sheet, 4 + i, 4, row.loadingPlace ?? '');
      _setCell(sheet, 4 + i, 5, row.unloadingPlace ?? '');
      _setCell(sheet, 4 + i, 6, '${row.freightCharge}');
      _setCell(sheet, 4 + i, 7, '${row.fastagCharge}');
      _setCell(sheet, 4 + i, 8, '${row.fastagCharge}'); // Closest alternative for 'otherCharges'
    }

    // Totals row
    final totalsRow = 4 + rows.length + 1;
    _setCell(sheet, totalsRow, 5, 'Total Freight:', bold: true);
    _setCell(sheet, totalsRow, 6, '${invoice.totalFreight}');
    _setCell(sheet, totalsRow + 1, 5, 'Total Fastag:', bold: true);
    _setCell(sheet, totalsRow + 1, 6, '${invoice.totalFastag}');
    _setCell(sheet, totalsRow + 2, 5, 'SGST:', bold: true);
    _setCell(sheet, totalsRow + 2, 6, '${invoice.sgstAmount}');
    _setCell(sheet, totalsRow + 3, 5, 'CGST:', bold: true);
    _setCell(sheet, totalsRow + 3, 6, '${invoice.cgstAmount}');
    _setCell(sheet, totalsRow + 4, 5, 'IGST:', bold: true);
    _setCell(sheet, totalsRow + 4, 6, '${invoice.igstAmount}');
    _setCell(sheet, totalsRow + 5, 5, 'Payable:', bold: true);
    _setCell(sheet, totalsRow + 5, 6, '${invoice.payableAmount}');

    // Remove the default sheet if needed
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final bytes = excel.save();
    return Uint8List.fromList(bytes!);
  }

  void _setCell(Sheet sheet, int row, int col, String value, {bool bold = false}) {
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
    cell.value = TextCellValue(value);
    if (bold) {
      cell.cellStyle = CellStyle(bold: true);
    }
  }
}

final excelGeneratorProvider = Provider((ref) => ExcelGenerator());

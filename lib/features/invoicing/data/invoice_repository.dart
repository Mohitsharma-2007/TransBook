import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

part 'invoice_repository.g.dart';

class InvoiceWithRows {
  final Invoice invoice;
  final List<InvoiceRow> rows;
  final Company? company;

  InvoiceWithRows({
    required this.invoice,
    required this.rows,
    this.company,
  });
}

class InvoiceWithCompany {
  final Invoice invoice;
  final Company? company;

  InvoiceWithCompany({required this.invoice, this.company});
}

class InvoiceRepository {
  final AppDatabase _db;

  InvoiceRepository(this._db);

  Stream<List<InvoiceWithCompany>> watchAllInvoices() {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(_db.companies, _db.companies.id.equalsExp(_db.invoices.companyId)),
    ])..orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return InvoiceWithCompany(
          invoice: row.readTable(_db.invoices),
          company: row.readTableOrNull(_db.companies),
        );
      }).toList();
    });
  }

  Future<List<InvoiceWithCompany>> getAllInvoices() async {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(_db.companies, _db.companies.id.equalsExp(_db.invoices.companyId)),
    ])..orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)]);

    final rows = await query.get();
    return rows.map((row) {
      return InvoiceWithCompany(
        invoice: row.readTable(_db.invoices),
        company: row.readTableOrNull(_db.companies),
      );
    }).toList();
  }


  Future<InvoiceWithRows?> getInvoiceWithRows(int invoiceId) async {
    final invoiceQuery = _db.select(_db.invoices)..where((tbl) => tbl.id.equals(invoiceId));
    final invoice = await invoiceQuery.getSingleOrNull();
    if (invoice == null) return null;

    final rowsQuery = _db.select(_db.invoiceRows)..where((tbl) => tbl.invoiceId.equals(invoiceId));
    final rows = await rowsQuery.get();

    Company? company;
    if (invoice.companyId != null) {
      final companyQuery = _db.select(_db.companies)..where((tbl) => tbl.id.equals(invoice.companyId!));
      company = await companyQuery.getSingleOrNull();
    }

    return InvoiceWithRows(invoice: invoice, rows: rows, company: company);
  }

  Future<int> insertInvoiceWithRows(InvoicesCompanion invoice, List<InvoiceRowsCompanion> rows) async {
    return await _db.transaction(() async {
      final invoiceId = await _db.into(_db.invoices).insert(invoice);
      
      for (final row in rows) {
        await _db.into(_db.invoiceRows).insert(row.copyWith(invoiceId: Value(invoiceId)));
      }
      
      return invoiceId;
    });
  }

  Future<bool> updateInvoiceWithRows(InvoicesCompanion invoice, List<InvoiceRowsCompanion> rows, int invoiceId) async {
    return await _db.transaction(() async {
      final updated = await _db.update(_db.invoices).replace(invoice);
      
      // A simple approach is to delete existing rows and insert new ones
      await (_db.delete(_db.invoiceRows)..where((tbl) => tbl.invoiceId.equals(invoiceId))).go();
      
      for (final row in rows) {
        await _db.into(_db.invoiceRows).insert(row.copyWith(invoiceId: Value(invoiceId)));
      }
      
      return updated;
    });
  }

  Future<void> deleteInvoice(int invoiceId) async {
    return await _db.transaction(() async {
      await (_db.delete(_db.invoiceRows)..where((tbl) => tbl.invoiceId.equals(invoiceId))).go();
      await (_db.delete(_db.invoices)..where((tbl) => tbl.id.equals(invoiceId))).go();
    });
  }

  Future<List<Invoice>> getDraftInvoicesForCompany(int companyId, String fromDate, String toDate) {
    return (_db.select(_db.invoices)
          ..where((tbl) =>
              tbl.companyId.equals(companyId) &
              tbl.status.equals('DRAFT') &
              tbl.invoiceDate.isBiggerOrEqualValue(fromDate) &
              tbl.invoiceDate.isSmallerOrEqualValue(toDate)))
        .get();
  }
}

@riverpod
InvoiceRepository invoiceRepository(InvoiceRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return InvoiceRepository(db);
}

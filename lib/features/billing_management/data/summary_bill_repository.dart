import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';
import '../domain/summary_bill_models.dart';

part 'summary_bill_repository.g.dart';

class SummaryBillRepository {
  final AppDatabase _db;

  SummaryBillRepository(this._db);

  Stream<List<SummaryBill>> watchAllSummaryBills() {
    return (_db.select(_db.summaryBills)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> insertSummaryBill(SummaryBillsCompanion bill, List<int> invoiceIds) {
    return _db.transaction(() async {
      // 1. Insert Summary Bill
      final summaryId = await _db.into(_db.summaryBills).insert(bill);

      // 2. Link Invoices
      for (final invoiceId in invoiceIds) {
        await _db.into(_db.summaryBillInvoices).insert(
              SummaryBillInvoicesCompanion(
                summaryId: Value(summaryId),
                invoiceId: Value(invoiceId),
              ),
            );

        // 3. Update Invoice Status to SUBMITTED
        await (_db.update(_db.invoices)..where((tbl) => tbl.id.equals(invoiceId))).write(
          const InvoicesCompanion(status: Value('SUBMITTED')),
        );
      }
      return summaryId;
    });
  }

  Future<SummaryBillWithInvoices?> getSummaryBillWithInvoices(int summaryId) async {
    final summaryBill = await (_db.select(_db.summaryBills)..where((tbl) => tbl.id.equals(summaryId))).getSingleOrNull();
    if (summaryBill == null) return null;

    final company = summaryBill.companyId != null
        ? await (_db.select(_db.companies)..where((tbl) => tbl.id.equals(summaryBill.companyId!))).getSingleOrNull()
        : null;

    final invoiceIdsQuery = await (_db.select(_db.summaryBillInvoices)..where((tbl) => tbl.summaryId.equals(summaryId))).get();
    final invoiceIds = invoiceIdsQuery.map((row) => row.invoiceId).toList();

    List<Invoice> invoices = [];
    if (invoiceIds.isNotEmpty) {
      invoices = await (_db.select(_db.invoices)..where((tbl) => tbl.id.isIn(invoiceIds))).get();
    }

    return SummaryBillWithInvoices(
      summaryBill: summaryBill,
      invoices: invoices,
      company: company,
    );
  }
}

@riverpod
SummaryBillRepository summaryBillRepository(SummaryBillRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SummaryBillRepository(db);
}

@riverpod
Stream<List<SummaryBill>> summaryBills(SummaryBillsRef ref) {
  return ref.watch(summaryBillRepositoryProvider).watchAllSummaryBills();
}

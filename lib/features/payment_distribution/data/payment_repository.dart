import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

part 'payment_repository.g.dart';

class PaymentRepository {
  final AppDatabase _db;

  PaymentRepository(this._db);

  Stream<List<Payment>> watchAllPayments() {
    return (_db.select(_db.payments)
          ..orderBy([(t) => OrderingTerm(expression: t.paymentDate, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<Payment>> watchPaymentsForInvoice(int invoiceId) {
    return (_db.select(_db.payments)..where((tbl) => tbl.invoiceId.equals(invoiceId))).watch();
  }

  Future<int> insertPayment(PaymentsCompanion payment) {
    return _db.transaction(() async {
      final paymentId = await _db.into(_db.payments).insert(payment);

      // Update parent invoice's paymentReceived (additive)
      final invoiceId = payment.invoiceId.value;
      if (invoiceId != null) {
        final invoice = await (_db.select(_db.invoices)..where((tbl) => tbl.id.equals(invoiceId))).getSingleOrNull();
        if (invoice != null) {
          final newTotal = invoice.paymentReceived + (payment.amount.value);
          await (_db.update(_db.invoices)..where((tbl) => tbl.id.equals(invoiceId))).write(
            InvoicesCompanion(
              paymentReceived: Value(newTotal),
              paymentDate: payment.paymentDate,
              status: Value(newTotal >= invoice.payableAmount ? 'PAID' : invoice.status),
            ),
          );
        }
      }

      return paymentId;
    });
  }
}

@riverpod
PaymentRepository paymentRepository(PaymentRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentRepository(db);
}

@riverpod
Stream<List<Payment>> allPayments(AllPaymentsRef ref) {
  return ref.watch(paymentRepositoryProvider).watchAllPayments();
}

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

// part 'label_repository.g.dart';

class LabelRepository {
  final AppDatabase _db;

  LabelRepository(this._db);

  Stream<List<Label>> watchAllLabels() {
    return (_db.select(_db.labels)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  Future<int> addLabel(String name, String color, String entityType) async {
    return await _db.into(_db.labels).insert(
      LabelsCompanion.insert(
        name: name,
        colorHex: color,
        entityType: Value(entityType),
      ),
    );
  }

  Future<void> updateLabel(int id, String name, String color) async {
    await (_db.update(_db.labels)..where((t) => t.id.equals(id))).write(
      LabelsCompanion(name: Value(name), colorHex: Value(color)),
    );
  }

  Future<void> deleteLabel(int id) async {
    // Delete associated junctions if necessary, though drift handles some constraints
    await (_db.delete(_db.labels)..where((t) => t.id.equals(id))).go();
  }

  Future<void> attachLabelToInvoice(int invoiceId, int labelId) async {
    await _db.into(_db.invoiceLabels).insert(
      InvoiceLabelsCompanion.insert(
        invoiceId: invoiceId,
        labelId: labelId,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removeLabelFromInvoice(int invoiceId, int labelId) async {
    await (_db.delete(_db.invoiceLabels)
          ..where((t) => t.invoiceId.equals(invoiceId) & t.labelId.equals(labelId)))
        .go();
  }

  Stream<List<Label>> watchLabelsForInvoice(int invoiceId) {
    final query = _db.select(_db.invoiceLabels).join([
      innerJoin(_db.labels, _db.labels.id.equalsExp(_db.invoiceLabels.labelId)),
    ])..where(_db.invoiceLabels.invoiceId.equals(invoiceId));

    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(_db.labels)).toList();
    });
  }
}

final labelRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LabelRepository(db);
});

final labelsStreamProvider = StreamProvider<List<Label>>((ref) {
  return ref.watch(labelRepositoryProvider).watchAllLabels();
});

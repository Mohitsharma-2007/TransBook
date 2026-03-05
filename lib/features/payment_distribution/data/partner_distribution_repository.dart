import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';
import 'package:drift/drift.dart' as drift;

part 'partner_distribution_repository.g.dart';

class PartnerDistributionRepository {
  final AppDatabase _db;

  PartnerDistributionRepository(this._db);

  Future<int> insertDistribution(PartnerDistributionsCompanion distribution) => 
      _db.into(_db.partnerDistributions).insert(distribution);

  Future<void> saveDistributions(List<PartnerDistributionsCompanion> distributions) async {
    await _db.transaction(() async {
      for (final dist in distributions) {
        await _db.into(_db.partnerDistributions).insert(dist);
      }
    });
  }

  Stream<List<PartnerDistribution>> watchAllDistributions() {
    return _db.select(_db.partnerDistributions).watch();
  }

  Stream<List<PartnerDistribution>> watchDistributionsByPartner(int partnerId) {
    return (_db.select(_db.partnerDistributions)
          ..where((tbl) => tbl.partnerId.equals(partnerId)))
        .watch();
  }

  Future<bool> recordPayment(int distributionId, double amountPaid, String date) async {
    final query = _db.select(_db.partnerDistributions)..where((tbl) => tbl.id.equals(distributionId));
    final dist = await query.getSingleOrNull();
    if (dist != null) {
      final newPaidAmount = dist.paidAmount + amountPaid;
      return await _db.update(_db.partnerDistributions).replace(
        dist.copyWith(paidAmount: newPaidAmount, paidDate: drift.Value(date))
      );
    }
    return false;
  }
}

@riverpod
PartnerDistributionRepository partnerDistributionRepository(PartnerDistributionRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PartnerDistributionRepository(db);
}

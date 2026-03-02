import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

part 'rate_card_repository.g.dart';

class RateCardRepository {
  final AppDatabase _db;

  RateCardRepository(this._db);

  Future<List<FreightRateCard>> getRatesForCompany(int companyId) =>
      (_db.select(_db.freightRateCards)..where((tbl) => tbl.companyId.equals(companyId))).get();

  Stream<List<FreightRateCard>> watchRatesForCompany(int companyId) =>
      (_db.select(_db.freightRateCards)..where((tbl) => tbl.companyId.equals(companyId))).watch();

  Future<int> insertRate(FreightRateCardsCompanion rate) => _db.into(_db.freightRateCards).insert(rate);

  Future<bool> updateRate(FreightRateCardsCompanion rate) => _db.update(_db.freightRateCards).replace(rate);

  Future<int> deleteRate(int id) =>
      (_db.delete(_db.freightRateCards)..where((tbl) => tbl.id.equals(id))).go();
}

@riverpod
RateCardRepository rateCardRepository(RateCardRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return RateCardRepository(db);
}

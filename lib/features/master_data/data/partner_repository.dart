import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

part 'partner_repository.g.dart';

class PartnerRepository {
  final AppDatabase _db;

  PartnerRepository(this._db);

  Future<List<Partner>> getAllPartners() => _db.select(_db.partners).get();

  Stream<List<Partner>> watchAllPartners() => _db.select(_db.partners).watch();

  Future<int> insertPartner(PartnersCompanion partner) => _db.into(_db.partners).insert(partner);

  Future<bool> updatePartner(PartnersCompanion partner) => _db.update(_db.partners).replace(partner);

  Future<int> deletePartner(int id) =>
      (_db.delete(_db.partners)..where((tbl) => tbl.id.equals(id))).go();
}

@riverpod
PartnerRepository partnerRepository(PartnerRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PartnerRepository(db);
}

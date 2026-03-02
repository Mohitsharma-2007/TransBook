import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

part 'company_repository.g.dart';

class CompanyRepository {
  final AppDatabase _db;

  CompanyRepository(this._db);

  Future<List<Company>> getAllCompanies() => _db.select(_db.companies).get();

  Stream<List<Company>> watchAllCompanies() => _db.select(_db.companies).watch();

  Future<int> insertCompany(CompaniesCompanion company) => _db.into(_db.companies).insert(company);

  Future<bool> updateCompany(CompaniesCompanion company) => _db.update(_db.companies).replace(company);

  Future<int> deleteCompany(int id) =>
      (_db.delete(_db.companies)..where((tbl) => tbl.id.equals(id))).go();
}

@riverpod
CompanyRepository companyRepository(CompanyRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return CompanyRepository(db);
}

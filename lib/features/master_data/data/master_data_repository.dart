import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

class MasterDataRepository {
  final AppDatabase _db;

  MasterDataRepository(this._db);

  Future<List<String>> getUniqueVehicles() async {
    final query = _db.selectOnly(_db.invoiceRows, distinct: true)
      ..addColumns([_db.invoiceRows.vehicleNoText]);
    final result = await query.map((row) => row.read(_db.invoiceRows.vehicleNoText)).get();
    return result.whereType<String>().toList();
  }

  Future<List<String>> getUniqueLoadingPlaces() async {
    final query = _db.selectOnly(_db.invoiceRows, distinct: true)
      ..addColumns([_db.invoiceRows.loadingPlace]);
    final result = await query.map((row) => row.read(_db.invoiceRows.loadingPlace)).get();
    return result.whereType<String>().toList();
  }

  Future<List<String>> getUniqueUnloadingPlaces() async {
    final query = _db.selectOnly(_db.invoiceRows, distinct: true)
      ..addColumns([_db.invoiceRows.unloadingPlace]);
    final result = await query.map((row) => row.read(_db.invoiceRows.unloadingPlace)).get();
    return result.whereType<String>().toList();
  }
}

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return MasterDataRepository(db);
});

final vehicleSuggestionsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getUniqueVehicles();
});

final loadingPlaceSuggestionsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getUniqueLoadingPlaces();
});

final unloadingPlaceSuggestionsProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(masterDataRepositoryProvider).getUniqueUnloadingPlaces();
});

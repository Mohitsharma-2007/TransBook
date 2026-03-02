import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database.dart';
import '../../../../core/di/database_provider.dart';

part 'vehicle_repository.g.dart';

class VehicleRepository {
  final AppDatabase _db;

  VehicleRepository(this._db);

  Future<List<Vehicle>> getAllVehicles() => _db.select(_db.vehicles).get();

  Stream<List<Vehicle>> watchAllVehicles() => _db.select(_db.vehicles).watch();

  Future<int> insertVehicle(VehiclesCompanion vehicle) => _db.into(_db.vehicles).insert(vehicle);

  Future<bool> updateVehicle(VehiclesCompanion vehicle) => _db.update(_db.vehicles).replace(vehicle);

  Future<int> deleteVehicle(int id) =>
      (_db.delete(_db.vehicles)..where((tbl) => tbl.id.equals(id))).go();
}

@riverpod
VehicleRepository vehicleRepository(VehicleRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return VehicleRepository(db);
}

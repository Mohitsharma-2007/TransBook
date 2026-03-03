import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

part 'tds_distributor.g.dart';

class VehicleTDSShare {
  final int? vehicleId;
  final String vehicleNo;
  final int tripCount;
  final double freightTotal;
  final double tdsShare;

  VehicleTDSShare({
    this.vehicleId,
    required this.vehicleNo,
    required this.tripCount,
    required this.freightTotal,
    required this.tdsShare,
  });
}

class TDSDistributor {
  final AppDatabase _db;

  TDSDistributor(this._db);

  Future<List<VehicleTDSShare>> distribute({
    required String periodFrom,
    required String periodTo,
    int? companyId,
  }) async {
    // 1. Get invoices in period
    var invoiceQuery = _db.select(_db.invoices)
      ..where((tbl) =>
          tbl.invoiceDate.isBiggerOrEqualValue(periodFrom) &
          tbl.invoiceDate.isSmallerOrEqualValue(periodTo));
    if (companyId != null) {
      invoiceQuery = _db.select(_db.invoices)
        ..where((tbl) =>
            tbl.invoiceDate.isBiggerOrEqualValue(periodFrom) &
            tbl.invoiceDate.isSmallerOrEqualValue(periodTo) &
            tbl.companyId.equals(companyId));
    }
    final invoices = await invoiceQuery.get();
    final invoiceIds = invoices.map((i) => i.id).toList();
    if (invoiceIds.isEmpty) return [];

    // 2. Fetch invoice rows for those invoices
    final invoiceRows = await (_db.select(_db.invoiceRows)
          ..where((tbl) => tbl.invoiceId.isIn(invoiceIds)))
        .get();

    // 3. Group by vehicleId / vehicleNoText
    final Map<String, _VehicleAccum> vehicleMap = {};
    for (final row in invoiceRows) {
      final key = row.vehicleNoText ?? 'Vehicle-${row.vehicleId ?? 0}';
      vehicleMap.putIfAbsent(key, () => _VehicleAccum(
        vehicleId: row.vehicleId,
        vehicleNo: key,
      ));
      vehicleMap[key]!.tripCount++;
      vehicleMap[key]!.freightTotal += row.freightCharge;
    }

    // 4. Get total TDS from payments linked to these invoices
    final payments = await (_db.select(_db.payments)
          ..where((tbl) => tbl.invoiceId.isIn(invoiceIds)))
        .get();
    double totalTDS = 0;
    for (final p in payments) {
      totalTDS += p.tdsDeducted;
    }

    // 4. Distribute proportionally
    final totalTrips = vehicleMap.values.fold<int>(0, (sum, v) => sum + v.tripCount);

    return vehicleMap.values.map((v) {
      final share = totalTrips > 0 ? (v.tripCount / totalTrips) * totalTDS : 0.0;
      return VehicleTDSShare(
        vehicleId: v.vehicleId,
        vehicleNo: v.vehicleNo,
        tripCount: v.tripCount,
        freightTotal: v.freightTotal,
        tdsShare: share,
      );
    }).toList();
  }
}

class _VehicleAccum {
  final int? vehicleId;
  final String vehicleNo;
  int tripCount = 0;
  double freightTotal = 0;

  _VehicleAccum({this.vehicleId, required this.vehicleNo});
}

@riverpod
TDSDistributor tdsDistributor(TdsDistributorRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return TDSDistributor(db);
}

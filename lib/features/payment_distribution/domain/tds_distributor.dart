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
    // 1. Fetch invoice rows in the period, joined with invoices for date + company filter
    var query = _db.select(_db.invoiceRows).join([
      innerJoin(_db.invoices, _db.invoices.id.equalsExp(_db.invoiceRows.invoiceId)),
    ]);

    query.where(
      _db.invoices.invoiceDate.isBiggerOrEqualValue(periodFrom) &
      _db.invoices.invoiceDate.isSmallerOrEqualValue(periodTo),
    );

    if (companyId != null) {
      query.where(_db.invoices.companyId.equals(companyId));
    }

    final rows = await query.get();

    // 2. Group by vehicleId / vehicleNoText
    final Map<String, _VehicleAccum> vehicleMap = {};

    for (final row in rows) {
      final invoiceRow = row.readTable(_db.invoiceRows);
      final key = invoiceRow.vehicleNoText ?? 'Vehicle-${invoiceRow.vehicleId ?? 0}';

      vehicleMap.putIfAbsent(key, () => _VehicleAccum(
        vehicleId: invoiceRow.vehicleId,
        vehicleNo: key,
      ));
      vehicleMap[key]!.tripCount++;
      vehicleMap[key]!.freightTotal += invoiceRow.freightCharge;
    }

    // 3. Get total TDS deducted from payments in the period
    final paymentsQuery = _db.select(_db.payments).join([
      innerJoin(_db.invoices, _db.invoices.id.equalsExp(_db.payments.invoiceId)),
    ]);
    paymentsQuery.where(
      _db.payments.paymentDate.isBiggerOrEqualValue(periodFrom) &
      _db.payments.paymentDate.isSmallerOrEqualValue(periodTo),
    );
    if (companyId != null) {
      paymentsQuery.where(_db.invoices.companyId.equals(companyId));
    }
    final paymentRows = await paymentsQuery.get();
    double totalTDS = 0;
    for (final pr in paymentRows) {
      totalTDS += pr.readTable(_db.payments).tdsDeducted;
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

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';

part 'payment_distributor.g.dart';

class PartnerShare {
  final int? partnerId;
  final String partnerName;
  final int vehicleCount;
  final double freightTotal;
  final double tdsShare;
  final double netPayable;

  PartnerShare({
    this.partnerId,
    required this.partnerName,
    required this.vehicleCount,
    required this.freightTotal,
    required this.tdsShare,
    required this.netPayable,
  });
}

class PaymentDistributor {
  final AppDatabase _db;

  PaymentDistributor(this._db);

  Future<List<PartnerShare>> distribute(List<int> invoiceIds) async {
    if (invoiceIds.isEmpty) return [];

    // 1. Get all invoice_rows for given invoiceIds
    final rowsQuery = _db.select(_db.invoiceRows)
      ..where((tbl) => tbl.invoiceId.isIn(invoiceIds));
    final invoiceRows = await rowsQuery.get();

    // 2. Group by vehicleId
    final Map<int, double> vehicleFreight = {};
    for (final row in invoiceRows) {
      final vid = row.vehicleId;
      if (vid != null) {
        vehicleFreight[vid] = (vehicleFreight[vid] ?? 0) + row.freightCharge;
      }
    }

    // 3. Map vehicleId -> Partner via vehicles table
    final vehicleIds = vehicleFreight.keys.toList();
    final vehicles = await (_db.select(_db.vehicles)
          ..where((tbl) => tbl.id.isIn(vehicleIds)))
        .get();

    final Map<int, int?> vehicleToPartner = {};
    for (final v in vehicles) {
      vehicleToPartner[v.id] = v.partnerId;
    }

    // 4. Get partner details
    final partnerIds = vehicleToPartner.values.whereType<int>().toSet().toList();
    final partners = partnerIds.isNotEmpty
        ? await (_db.select(_db.partners)..where((tbl) => tbl.id.isIn(partnerIds))).get()
        : <Partner>[];
    final Map<int, Partner> partnerMap = {for (final p in partners) p.id: p};

    // 5. Aggregate freight per partner
    final Map<int, _PartnerAccum> accum = {};
    for (final entry in vehicleFreight.entries) {
      final partnerId = vehicleToPartner[entry.key];
      if (partnerId != null) {
        accum.putIfAbsent(
          partnerId,
          () => _PartnerAccum(
            partnerId: partnerId,
            partnerName: partnerMap[partnerId]?.name ?? 'Unknown',
          ),
        );
        accum[partnerId]!.vehicleIds.add(entry.key);
        accum[partnerId]!.freightTotal += entry.value;
      }
    }

    // 6. Get total TDS from these invoices
    final invoices = await (_db.select(_db.invoices)
          ..where((tbl) => tbl.id.isIn(invoiceIds)))
        .get();
    final totalTDS = invoices.fold<double>(0, (sum, inv) => sum + inv.tdsAmount);
    final totalFreight = invoices.fold<double>(0, (sum, inv) => sum + inv.totalFreight);

    // 7. Distribute TDS proportionally and compute net
    return accum.values.map((a) {
      final proportion = totalFreight > 0 ? a.freightTotal / totalFreight : 0.0;
      final tds = proportion * totalTDS;
      return PartnerShare(
        partnerId: a.partnerId,
        partnerName: a.partnerName,
        vehicleCount: a.vehicleIds.length,
        freightTotal: a.freightTotal,
        tdsShare: tds,
        netPayable: a.freightTotal - tds,
      );
    }).toList();
  }
}

class _PartnerAccum {
  final int partnerId;
  final String partnerName;
  final Set<int> vehicleIds = {};
  double freightTotal = 0;

  _PartnerAccum({required this.partnerId, required this.partnerName});
}

@riverpod
PaymentDistributor paymentDistributor(PaymentDistributorRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaymentDistributor(db);
}

---
phase: 4
plan: 2
wave: 2
---

# Plan 4.2: TDS Distribution Engine

## Objective
Implement the `TDSDistributor` business logic class that calculates per-vehicle TDS shares based on trip counts within a date range.

## Context
- `e:\TransBook\TRD.md` -> Section 4.4 TDS Distribution
- `e:\TransBook\lib\features\invoicing\data\invoice_repository.dart`
- `e:\TransBook\lib\core\database\tables.dart`

## Tasks

<task type="auto">
  <name>TDS Distributor Service</name>
  <files>
    - `e:\TransBook\lib\features\payment_distribution\domain\tds_distributor.dart`
  </files>
  <action>
    - Create `VehicleTDSShare` model class with fields: vehicleId, vehicleNo, tripCount, freightTotal, tdsShare.
    - Create `TDSDistributor` class injected with `AppDatabase`.
    - Implement `Future<List<VehicleTDSShare>> distribute({required String periodFrom, required String periodTo, int? companyId})`:
      1. Query `invoice_rows` joined with `invoices` for the date range (and optionally companyId).
      2. Group rows by `vehicleId` / `vehicleNoText`.
      3. Count trips and sum freight per vehicle.
      4. Query total TDS deducted from `payments` table for the period.
      5. Distribute TDS proportionally: `vehicleTDS = (vehicleTrips / totalTrips) * totalTDS`.
    - Create riverpod `tdsDistributorProvider`.
  </action>
  <verify>dart run build_runner build --delete-conflicting-outputs; dart analyze lib/features/payment_distribution/domain/</verify>
  <done>TDSDistributor compiles and produces per-vehicle TDS breakdown.</done>
</task>

<task type="auto">
  <name>Payment Distributor Service</name>
  <files>
    - `e:\TransBook\lib\features\payment_distribution\domain\payment_distributor.dart`
  </files>
  <action>
    - Create `PartnerShare` model: partnerId, partnerName, vehicleCount, freightTotal, tdsShare, netPayable.
    - Create `PaymentDistributor` class injected with `AppDatabase`.
    - Implement `Future<List<PartnerShare>> distribute(List<int> invoiceIds)`:
      1. Get all invoice_rows for given invoiceIds.
      2. Group by vehicleId.
      3. Map vehicleId -> partnerId via vehicles table.
      4. Sum freight per partner's vehicles.
      5. Apply TDS proportionally.
      6. Return net payable per partner.
    - Create riverpod `paymentDistributorProvider`.
  </action>
  <verify>dart analyze lib/features/payment_distribution/domain/</verify>
  <done>PaymentDistributor provides per-partner payment breakdown.</done>
</task>

## Success Criteria
- [ ] `TDSDistributor` implements proportional TDS distribution logic.
- [ ] `PaymentDistributor` maps vehicles to partners and calculates net payable.
- [ ] Both pass static analysis.

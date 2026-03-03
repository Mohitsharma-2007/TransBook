# Plan 4.2 Summary
- `TDSDistributor`: Queries invoice rows by date range (optionally by company), groups by vehicle, fetches total TDS from payments table, distributes proportionally by trip count.
- `PaymentDistributor`: Takes invoice IDs, groups rows by vehicle, maps vehicle→partner via vehicles table, aggregates freight per partner, distributes TDS proportionally, returns net payable.
- Both engines pass static analysis.

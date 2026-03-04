import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/constants/app_theme.dart';
import '../../../core/di/database_provider.dart';
import '../../../core/database/database.dart';

class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({super.key});

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final _searchController = TextEditingController();
  List<Invoice> _invoiceResults = [];
  List<Company> _companyResults = [];
  List<Vehicle> _vehicleResults = [];
  bool _isSearching = false;

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() {
        _invoiceResults = [];
        _companyResults = [];
        _vehicleResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final db = ref.read(appDatabaseProvider);
    final term = '%${query.trim()}%';

    final invoices = await (db.select(db.invoices)..where((tbl) => tbl.invoiceNumber.like(term))).get();
    final companies = await (db.select(db.companies)..where((tbl) => tbl.name.like(term) | tbl.gstin.like(term))).get();
    final vehicles = await (db.select(db.vehicles)..where((tbl) => tbl.vehicleNo.like(term))).get();

    if (mounted) {
      setState(() {
        _invoiceResults = invoices;
        _companyResults = companies;
        _vehicleResults = vehicles;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search invoices, companies, or vehicles...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.brandSecondary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchController.text.trim().isEmpty
                      ? const Center(child: Text('Start typing to search global records'))
                      : ListView(
                          children: [
                            if (_invoiceResults.isNotEmpty) ...[
                              _SectionHeader('Invoices'),
                              ..._invoiceResults.map((e) => ListTile(
                                leading: const Icon(Icons.receipt, color: AppTheme.brandSecondary),
                                title: Text(e.invoiceNumber ?? 'Draft Invoice'),
                                subtitle: Text('₹${e.payableAmount} - ${e.status}'),
                                onTap: () => Navigator.pop(context, e),
                              )),
                            ],
                            if (_companyResults.isNotEmpty) ...[
                              _SectionHeader('Companies'),
                              ..._companyResults.map((e) => ListTile(
                                leading: const Icon(Icons.business, color: AppTheme.brandSecondary),
                                title: Text(e.name),
                                subtitle: Text(e.gstin ?? 'No GSTIN'),
                                onTap: () => Navigator.pop(context, e),
                              )),
                            ],
                            if (_vehicleResults.isNotEmpty) ...[
                              _SectionHeader('Vehicles'),
                              ..._vehicleResults.map((e) => ListTile(
                                leading: const Icon(Icons.local_shipping, color: AppTheme.brandSecondary),
                                title: Text(e.vehicleNo),
                                subtitle: Text(e.vehicleType ?? 'Vehicle'),
                                onTap: () => Navigator.pop(context, e),
                              )),
                            ],
                            if (_invoiceResults.isEmpty && _companyResults.isEmpty && _vehicleResults.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(child: Text('No matching records found')),
                              )
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8),
      child: Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

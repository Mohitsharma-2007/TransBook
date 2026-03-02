import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_theme.dart';
import '../data/rate_card_repository.dart';
import '../data/company_repository.dart';
import '../../../../core/database/database.dart';
import 'add_edit_rate_card_dialog.dart';

class RateCardScreen extends ConsumerStatefulWidget {
  const RateCardScreen({super.key});

  @override
  ConsumerState<RateCardScreen> createState() => _RateCardScreenState();
}

class _RateCardScreenState extends ConsumerState<RateCardScreen> {
  Company? _selectedCompany;

  @override
  Widget build(BuildContext context) {
    final companyStream = ref.watch(companyRepositoryProvider).watchAllCompanies();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Freight Rate Cards', style: Theme.of(context).textTheme.titleLarge),
              if (_selectedCompany != null)
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddEditRateCardDialog(company: _selectedCompany!),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Rate'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Company Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Select Company: '),
                  const SizedBox(width: 16),
                  StreamBuilder<List<Company>>(
                    stream: companyStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      final companies = snapshot.data!;
                      return Expanded(
                        child: DropdownButtonFormField<Company>(
                          value: _selectedCompany,
                          hint: const Text('Choose a company to view rates'),
                          items: companies.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedCompany = v;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedCompany == null)
            const Expanded(
              child: Center(
                child: Text('Please select a company above to manage its rate card.', style: TextStyle(color: AppTheme.textSecondary)),
              ),
            )
          else
            Expanded(
              child: Card(
                child: StreamBuilder(
                  stream: ref.watch(rateCardRepositoryProvider).watchRatesForCompany(_selectedCompany!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final rates = snapshot.data ?? [];
                    
                    if (rates.isEmpty) {
                      return const Center(child: Text('No rates defined for this company.', style: TextStyle(color: AppTheme.textSecondary)));
                    }

                    return DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      headingRowColor: MaterialStateProperty.all(AppTheme.brandPrimary),
                      headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      columns: const [
                        DataColumn2(label: Text('LOADING PLACE'), size: ColumnSize.M),
                        DataColumn2(label: Text('UNLOADING PLACE'), size: ColumnSize.L),
                        DataColumn2(label: Text('FREIGHT (₹)'), size: ColumnSize.S, numeric: true),
                        DataColumn2(label: Text('ACTIONS'), fixedWidth: 100),
                      ],
                      rows: List<DataRow>.generate(rates.length, (index) {
                        final rate = rates[index];
                        return DataRow(
                          color: MaterialStateProperty.all(
                            index % 2 == 1 ? AppTheme.surfaceLight : Colors.white,
                          ),
                          cells: [
                            DataCell(Text(rate.loadingPlace ?? '-')),
                            DataCell(Text(rate.unloadingPlace, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('₹${rate.rateAmount.toStringAsFixed(2)}')),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18, color: AppTheme.statusOverdue),
                                onPressed: () {
                                  ref.read(rateCardRepositoryProvider).deleteRate(rate.id);
                                },
                                tooltip: 'Delete',
                                splashRadius: 20,
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

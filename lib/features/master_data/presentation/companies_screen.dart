import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_theme.dart';
import '../data/company_repository.dart';
import 'add_edit_company_dialog.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyStream = ref.watch(companyRepositoryProvider).watchAllCompanies();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Companies', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddEditCompanyDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Company'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name, GSTIN...',
                    prefixIcon: Icon(Icons.search, size: 20, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Filter',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder(
                stream: companyStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final companies = snapshot.data ?? [];
                  
                  if (companies.isEmpty) {
                    return const Center(child: Text('No companies found. Add one to get started.', style: TextStyle(color: AppTheme.textSecondary)));
                  }

                  return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 800,
                    headingRowColor: MaterialStateProperty.all(AppTheme.brandPrimary),
                    headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    columns: const [
                      DataColumn2(label: Text('COMPANY NAME'), size: ColumnSize.L),
                      DataColumn2(label: Text('GSTIN'), size: ColumnSize.L),
                      DataColumn2(label: Text('STATE (CODE)'), size: ColumnSize.M),
                      DataColumn2(label: Text('INVOICE TYPE'), size: ColumnSize.M),
                      DataColumn2(label: Text('ACTIONS'), fixedWidth: 100),
                    ],
                    rows: List<DataRow>.generate(companies.length, (index) {
                      final company = companies[index];
                      return DataRow(
                        color: MaterialStateProperty.all(
                          index % 2 == 1 ? AppTheme.surfaceLight : Colors.white,
                        ),
                        cells: [
                          DataCell(Text(company.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(company.gstin ?? '-')),
                          DataCell(Text('${company.state ?? '-'} (${company.stateCode ?? '-'})')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.brandSecondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                company.invoiceType,
                                style: const TextStyle(color: AppTheme.brandSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            )
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: AppTheme.textSecondary),
                                  onPressed: () {},
                                  tooltip: 'Edit',
                                  splashRadius: 20,
                                ),
                              ],
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

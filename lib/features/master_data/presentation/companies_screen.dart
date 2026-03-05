import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
              Text('Companies', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                  .animate().fadeIn().slideX(begin: -0.1),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddEditCompanyDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Company'),
              ).animate().fadeIn().slideX(begin: 0.1),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business_outlined, size: 80, color: AppTheme.borderLight),
                          const SizedBox(height: 16),
                          Text('No companies found.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary)),
                          const SizedBox(height: 8),
                          Text('Add a client or transporter company to get started.', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ).animate().fadeIn(delay: 300.ms).scale(),
                    );
                  }

                  return DataTable2(
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    minWidth: 800,
                    headingRowHeight: 48,
                    dataRowHeight: 48,
                    dividerThickness: 1,
                    headingRowColor: WidgetStateProperty.all(AppTheme.surfaceLight),
                    columns: const [
                      DataColumn2(label: Text('Company Name'), size: ColumnSize.L),
                      DataColumn2(label: Text('GSTIN'), size: ColumnSize.L),
                      DataColumn2(label: Text('State (Code)'), size: ColumnSize.M),
                      DataColumn2(label: Text('Invoice Type'), size: ColumnSize.M),
                      DataColumn2(label: Text('Actions'), fixedWidth: 100),
                    ],
                    rows: List<DataRow>.generate(companies.length, (index) {
                      final company = companies[index];
                      return DataRow(
                        cells: [
                          DataCell(Text(company.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(company.gstin?.isEmpty ?? true ? '-' : company.gstin!, style: const TextStyle(color: AppTheme.textSecondary))),
                          DataCell(Text('${company.state ?? '-'} (${company.stateCode ?? '-'})', style: const TextStyle(color: AppTheme.textSecondary))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.brandSecondary.withAlpha(25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                company.invoiceType,
                                style: const TextStyle(color: AppTheme.brandSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            )
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.brandSecondary),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AddEditCompanyDialog(company: company),
                                    );
                                  },
                                  tooltip: 'Edit',
                                  splashRadius: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.errorColor),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Company?'),
                                        content: Text('Are you sure you want to delete ${company.name}?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, true), 
                                            child: const Text('Delete', style: TextStyle(color: AppTheme.errorColor))
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await ref.read(companyRepositoryProvider).deleteCompany(company.id);
                                    }
                                  },
                                  tooltip: 'Delete',
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
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          ),
        ],
      ),
    );
  }
}

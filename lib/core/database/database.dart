import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Firms, Companies, FreightRateCards, Partners, Vehicles, Invoices, InvoiceRows, SummaryBills, SummaryBillInvoices, Payments, PartnerDistributions, SyncQueue, Reminders, EmailLogs, AuditLog, Labels, EmailThreads, InvoiceLabels])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add table migrations that were introduced subsequently
          // Adding safe IF NOT EXISTS execution using custom queries if necessary, but createTable handles it.
          try { await m.createTable(summaryBills); } catch (e) {}
          try { await m.createTable(summaryBillInvoices); } catch (e) {}
          try { await m.createTable(payments); } catch (e) {}
          try { await m.createTable(partnerDistributions); } catch (e) {}
          try { await m.createTable(syncQueue); } catch (e) {}
          try { await m.createTable(reminders); } catch (e) {}
          try { await m.createTable(emailLogs); } catch (e) {}
          try { await m.createTable(auditLog); } catch (e) {}
          try { await m.createTable(labels); } catch (e) {}
          try { await m.createTable(emailThreads); } catch (e) {}
          try { await m.createTable(invoiceLabels); } catch (e) {}
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Switching to getApplicationSupportDirectory() (AppData\Roaming) 
    // to bypass Windows OneDrive syncing locks which cause SqliteException(14)
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'TransBook', 'transbook.sqlite'));
    
    // Ensure parent directory exists to prevent SqliteException(14) error
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    
    return NativeDatabase.createInBackground(file);
  });
}

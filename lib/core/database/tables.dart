import 'package:drift/drift.dart';

@DataClassName('Firm')
class Firms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get pan => text().nullable()();
  TextColumn get gstin => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get bankAccount => text().nullable()();
  TextColumn get bankIfsc => text().nullable()();
  TextColumn get beneficiaryName => text().nullable()();
  TextColumn get invoicePrefix => text().withDefault(const Constant('JSV'))();
  IntColumn get currentInvoiceSeq => integer().withDefault(const Constant(1))();
  TextColumn get financialYearStart => text().nullable()();
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('Company')
class Companies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get pan => text().nullable()();
  TextColumn get gstin => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get stateCode => text().nullable()();
  TextColumn get hsnSac => text().withDefault(const Constant('996791'))();
  TextColumn get invoiceType => text()(); // STATE or INTER_STATE
  TextColumn get defaultLoadingPlace => text().nullable()();
  TextColumn get contactName => text().nullable()();
  TextColumn get contactEmail => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
}

@DataClassName('FreightRateCard')
class FreightRateCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get loadingPlace => text().nullable()();
  TextColumn get unloadingPlace => text()();
  RealColumn get rateAmount => real()();
  TextColumn get effectiveFrom => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
}

@DataClassName('Partner')
class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get pan => text().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get bankAccount => text().nullable()();
  TextColumn get bankIfsc => text().nullable()();
  RealColumn get sharePercent => real().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
}

@DataClassName('Vehicle')
class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vehicleNo => text().unique()();
  IntColumn get partnerId => integer().nullable().references(Partners, #id)();
  TextColumn get vehicleType => text().nullable()();
  TextColumn get fitnessExpiry => text().nullable()();
  TextColumn get insuranceExpiry => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();
}

@DataClassName('Invoice')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get invoiceDate => text()();
  IntColumn get companyId => integer().nullable().references(Companies, #id)();
  TextColumn get invoiceType => text().nullable()();
  RealColumn get totalFreight => real().withDefault(const Constant(0))();
  RealColumn get totalFastag => real().withDefault(const Constant(0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0))();
  RealColumn get sgstRate => real().withDefault(const Constant(2.5))();
  RealColumn get cgstRate => real().withDefault(const Constant(2.5))();
  RealColumn get igstRate => real().withDefault(const Constant(5.0))();
  RealColumn get sgstAmount => real().withDefault(const Constant(0))();
  RealColumn get cgstAmount => real().withDefault(const Constant(0))();
  RealColumn get igstAmount => real().withDefault(const Constant(0))();
  RealColumn get gstRcmTotal => real().withDefault(const Constant(0))();
  RealColumn get tdsRate => real().withDefault(const Constant(2.0))();
  RealColumn get tdsAmount => real().withDefault(const Constant(0))();
  RealColumn get payableAmount => real().withDefault(const Constant(0))();
  TextColumn get amountInWords => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  TextColumn get submissionDate => text().nullable()();
  RealColumn get paymentReceived => real().withDefault(const Constant(0))();
  TextColumn get paymentDate => text().nullable()();
  TextColumn get pdfPath => text().nullable()();
  IntColumn get cloudSynced => integer().withDefault(const Constant(0))();
  IntColumn get templateId => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get financialYear => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
}

@DataClassName('InvoiceRow')
class InvoiceRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id)(); // Cascade handled via sql or foreignKey options
  IntColumn get rowOrder => integer().nullable()();
  TextColumn get tripDate => text().nullable()();
  TextColumn get grNumber => text().nullable()();
  IntColumn get vehicleId => integer().nullable().references(Vehicles, #id)();
  TextColumn get vehicleNoText => text().nullable()();
  RealColumn get freightCharge => real().withDefault(const Constant(0))();
  RealColumn get fastagCharge => real().withDefault(const Constant(0))();
  TextColumn get invoiceRefNo => text().nullable()();
  TextColumn get loadingPlace => text().nullable()();
  TextColumn get unloadingPlace => text().nullable()();
  RealColumn get rowAmount => real().withDefault(const Constant(0))();
  TextColumn get customFields => text().nullable()(); // JSON: {"ColName": "value", ...}
}

@DataClassName('SummaryBill')
class SummaryBills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get summaryNumber => text().nullable()();
  IntColumn get companyId => integer().nullable().references(Companies, #id)();
  TextColumn get periodFrom => text().nullable()();
  TextColumn get periodTo => text().nullable()();
  RealColumn get totalAmount => real().nullable()();
  RealColumn get tdsAmount => real().nullable()();
  RealColumn get payableAmount => real().nullable()();
  TextColumn get amountInWords => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('SummaryBillInvoice')
class SummaryBillInvoices extends Table {
  IntColumn get summaryId => integer().references(SummaryBills, #id)();
  IntColumn get invoiceId => integer().references(Invoices, #id)();

  @override
  Set<Column> get primaryKey => {summaryId, invoiceId};
}

@DataClassName('Payment')
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id)();
  TextColumn get paymentDate => text().nullable()();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get paymentMode => text().nullable()(); // NEFT|RTGS|CHEQUE|CASH
  TextColumn get referenceNo => text().nullable()();
  RealColumn get tdsDeducted => real().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('PartnerDistribution')
class PartnerDistributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get periodFrom => text().nullable()();
  TextColumn get periodTo => text().nullable()();
  IntColumn get partnerId => integer().nullable().references(Partners, #id)();
  IntColumn get vehicleId => integer().nullable().references(Vehicles, #id)();
  IntColumn get trips => integer().withDefault(const Constant(0))();
  RealColumn get freightAmount => real().withDefault(const Constant(0))();
  RealColumn get tdsShare => real().withDefault(const Constant(0))();
  RealColumn get netAmount => real().withDefault(const Constant(0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get paidDate => text().nullable()();
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('SyncQueueEntry')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // INVOICE|SUMMARY_BILL
  IntColumn get entityId => integer()();
  TextColumn get action => text()(); // UPLOAD|UPDATE|DELETE
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastAttempt => text().nullable()();
  TextColumn get createdAt => text().nullable()();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // PAYMENT|SUBMISSION|GST|TDS_CERT
  IntColumn get referenceId => integer().nullable()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get dueDate => text()();
  IntColumn get escalationLevel => integer().withDefault(const Constant(0))();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  TextColumn get lastNotified => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class EmailLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().nullable()();
  TextColumn get direction => text()(); // SENT|RECEIVED
  TextColumn get subject => text().nullable()();
  TextColumn get body => text().nullable()();
  TextColumn get sentAt => text().nullable()();
  TextColumn get gmailMessageId => text().nullable()();
  TextColumn get status => text().nullable()();
}

@DataClassName('AuditLogEntry')
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get action => text()(); // CREATE|UPDATE|DELETE|EXPORT|EMAIL
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  TextColumn get userNote => text().nullable()();
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('Label')
class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
  TextColumn get entityType => text().nullable()(); // ALL, COMPANY, INVOICE
  TextColumn get createdAt => text().nullable()();
}

@DataClassName('EmailThread')
class EmailThreads extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get threadId => text().unique()(); // Gmail Thread ID
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id)();
  TextColumn get subject => text()();
  TextColumn get lastSnippet => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('SENT'))(); // SENT, REPLIED, ERROR
  TextColumn get lastMessageDate => text().nullable()();
  TextColumn get participantEmail => text().nullable()();
}

@DataClassName('InvoiceLabel')
class InvoiceLabels extends Table {
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  IntColumn get labelId => integer().references(Labels, #id)();

  @override
  Set<Column> get primaryKey => {invoiceId, labelId};
}

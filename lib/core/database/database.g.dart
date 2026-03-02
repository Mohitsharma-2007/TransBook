// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FirmsTable extends Firms with TableInfo<$FirmsTable, Firm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FirmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panMeta = const VerificationMeta('pan');
  @override
  late final GeneratedColumn<String> pan = GeneratedColumn<String>(
    'pan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountMeta = const VerificationMeta(
    'bankAccount',
  );
  @override
  late final GeneratedColumn<String> bankAccount = GeneratedColumn<String>(
    'bank_account',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankIfscMeta = const VerificationMeta(
    'bankIfsc',
  );
  @override
  late final GeneratedColumn<String> bankIfsc = GeneratedColumn<String>(
    'bank_ifsc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _beneficiaryNameMeta = const VerificationMeta(
    'beneficiaryName',
  );
  @override
  late final GeneratedColumn<String> beneficiaryName = GeneratedColumn<String>(
    'beneficiary_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoicePrefixMeta = const VerificationMeta(
    'invoicePrefix',
  );
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
    'invoice_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('JSV'),
  );
  static const VerificationMeta _currentInvoiceSeqMeta = const VerificationMeta(
    'currentInvoiceSeq',
  );
  @override
  late final GeneratedColumn<int> currentInvoiceSeq = GeneratedColumn<int>(
    'current_invoice_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _financialYearStartMeta =
      const VerificationMeta('financialYearStart');
  @override
  late final GeneratedColumn<String> financialYearStart =
      GeneratedColumn<String>(
        'financial_year_start',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    phone,
    email,
    pan,
    gstin,
    state,
    stateCode,
    logoPath,
    bankName,
    bankAccount,
    bankIfsc,
    beneficiaryName,
    invoicePrefix,
    currentInvoiceSeq,
    financialYearStart,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'firms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Firm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('pan')) {
      context.handle(
        _panMeta,
        pan.isAcceptableOrUnknown(data['pan']!, _panMeta),
      );
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('bank_account')) {
      context.handle(
        _bankAccountMeta,
        bankAccount.isAcceptableOrUnknown(
          data['bank_account']!,
          _bankAccountMeta,
        ),
      );
    }
    if (data.containsKey('bank_ifsc')) {
      context.handle(
        _bankIfscMeta,
        bankIfsc.isAcceptableOrUnknown(data['bank_ifsc']!, _bankIfscMeta),
      );
    }
    if (data.containsKey('beneficiary_name')) {
      context.handle(
        _beneficiaryNameMeta,
        beneficiaryName.isAcceptableOrUnknown(
          data['beneficiary_name']!,
          _beneficiaryNameMeta,
        ),
      );
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
        _invoicePrefixMeta,
        invoicePrefix.isAcceptableOrUnknown(
          data['invoice_prefix']!,
          _invoicePrefixMeta,
        ),
      );
    }
    if (data.containsKey('current_invoice_seq')) {
      context.handle(
        _currentInvoiceSeqMeta,
        currentInvoiceSeq.isAcceptableOrUnknown(
          data['current_invoice_seq']!,
          _currentInvoiceSeqMeta,
        ),
      );
    }
    if (data.containsKey('financial_year_start')) {
      context.handle(
        _financialYearStartMeta,
        financialYearStart.isAcceptableOrUnknown(
          data['financial_year_start']!,
          _financialYearStartMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Firm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Firm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      pan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan'],
      ),
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      bankAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account'],
      ),
      bankIfsc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_ifsc'],
      ),
      beneficiaryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beneficiary_name'],
      ),
      invoicePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_prefix'],
      )!,
      currentInvoiceSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_invoice_seq'],
      )!,
      financialYearStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}financial_year_start'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $FirmsTable createAlias(String alias) {
    return $FirmsTable(attachedDatabase, alias);
  }
}

class Firm extends DataClass implements Insertable<Firm> {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? pan;
  final String? gstin;
  final String? state;
  final String? stateCode;
  final String? logoPath;
  final String? bankName;
  final String? bankAccount;
  final String? bankIfsc;
  final String? beneficiaryName;
  final String invoicePrefix;
  final int currentInvoiceSeq;
  final String? financialYearStart;
  final String? createdAt;
  const Firm({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.pan,
    this.gstin,
    this.state,
    this.stateCode,
    this.logoPath,
    this.bankName,
    this.bankAccount,
    this.bankIfsc,
    this.beneficiaryName,
    required this.invoicePrefix,
    required this.currentInvoiceSeq,
    this.financialYearStart,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || pan != null) {
      map['pan'] = Variable<String>(pan);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || bankAccount != null) {
      map['bank_account'] = Variable<String>(bankAccount);
    }
    if (!nullToAbsent || bankIfsc != null) {
      map['bank_ifsc'] = Variable<String>(bankIfsc);
    }
    if (!nullToAbsent || beneficiaryName != null) {
      map['beneficiary_name'] = Variable<String>(beneficiaryName);
    }
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    map['current_invoice_seq'] = Variable<int>(currentInvoiceSeq);
    if (!nullToAbsent || financialYearStart != null) {
      map['financial_year_start'] = Variable<String>(financialYearStart);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    return map;
  }

  FirmsCompanion toCompanion(bool nullToAbsent) {
    return FirmsCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      pan: pan == null && nullToAbsent ? const Value.absent() : Value(pan),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      bankAccount: bankAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccount),
      bankIfsc: bankIfsc == null && nullToAbsent
          ? const Value.absent()
          : Value(bankIfsc),
      beneficiaryName: beneficiaryName == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryName),
      invoicePrefix: Value(invoicePrefix),
      currentInvoiceSeq: Value(currentInvoiceSeq),
      financialYearStart: financialYearStart == null && nullToAbsent
          ? const Value.absent()
          : Value(financialYearStart),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Firm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Firm(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      pan: serializer.fromJson<String?>(json['pan']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      state: serializer.fromJson<String?>(json['state']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      bankAccount: serializer.fromJson<String?>(json['bankAccount']),
      bankIfsc: serializer.fromJson<String?>(json['bankIfsc']),
      beneficiaryName: serializer.fromJson<String?>(json['beneficiaryName']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      currentInvoiceSeq: serializer.fromJson<int>(json['currentInvoiceSeq']),
      financialYearStart: serializer.fromJson<String?>(
        json['financialYearStart'],
      ),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'pan': serializer.toJson<String?>(pan),
      'gstin': serializer.toJson<String?>(gstin),
      'state': serializer.toJson<String?>(state),
      'stateCode': serializer.toJson<String?>(stateCode),
      'logoPath': serializer.toJson<String?>(logoPath),
      'bankName': serializer.toJson<String?>(bankName),
      'bankAccount': serializer.toJson<String?>(bankAccount),
      'bankIfsc': serializer.toJson<String?>(bankIfsc),
      'beneficiaryName': serializer.toJson<String?>(beneficiaryName),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'currentInvoiceSeq': serializer.toJson<int>(currentInvoiceSeq),
      'financialYearStart': serializer.toJson<String?>(financialYearStart),
      'createdAt': serializer.toJson<String?>(createdAt),
    };
  }

  Firm copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> pan = const Value.absent(),
    Value<String?> gstin = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    Value<String?> logoPath = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    Value<String?> bankAccount = const Value.absent(),
    Value<String?> bankIfsc = const Value.absent(),
    Value<String?> beneficiaryName = const Value.absent(),
    String? invoicePrefix,
    int? currentInvoiceSeq,
    Value<String?> financialYearStart = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
  }) => Firm(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    pan: pan.present ? pan.value : this.pan,
    gstin: gstin.present ? gstin.value : this.gstin,
    state: state.present ? state.value : this.state,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    bankName: bankName.present ? bankName.value : this.bankName,
    bankAccount: bankAccount.present ? bankAccount.value : this.bankAccount,
    bankIfsc: bankIfsc.present ? bankIfsc.value : this.bankIfsc,
    beneficiaryName: beneficiaryName.present
        ? beneficiaryName.value
        : this.beneficiaryName,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    currentInvoiceSeq: currentInvoiceSeq ?? this.currentInvoiceSeq,
    financialYearStart: financialYearStart.present
        ? financialYearStart.value
        : this.financialYearStart,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  Firm copyWithCompanion(FirmsCompanion data) {
    return Firm(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      pan: data.pan.present ? data.pan.value : this.pan,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      state: data.state.present ? data.state.value : this.state,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccount: data.bankAccount.present
          ? data.bankAccount.value
          : this.bankAccount,
      bankIfsc: data.bankIfsc.present ? data.bankIfsc.value : this.bankIfsc,
      beneficiaryName: data.beneficiaryName.present
          ? data.beneficiaryName.value
          : this.beneficiaryName,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      currentInvoiceSeq: data.currentInvoiceSeq.present
          ? data.currentInvoiceSeq.value
          : this.currentInvoiceSeq,
      financialYearStart: data.financialYearStart.present
          ? data.financialYearStart.value
          : this.financialYearStart,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Firm(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('pan: $pan, ')
          ..write('gstin: $gstin, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('logoPath: $logoPath, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccount: $bankAccount, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('beneficiaryName: $beneficiaryName, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('currentInvoiceSeq: $currentInvoiceSeq, ')
          ..write('financialYearStart: $financialYearStart, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    phone,
    email,
    pan,
    gstin,
    state,
    stateCode,
    logoPath,
    bankName,
    bankAccount,
    bankIfsc,
    beneficiaryName,
    invoicePrefix,
    currentInvoiceSeq,
    financialYearStart,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Firm &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.pan == this.pan &&
          other.gstin == this.gstin &&
          other.state == this.state &&
          other.stateCode == this.stateCode &&
          other.logoPath == this.logoPath &&
          other.bankName == this.bankName &&
          other.bankAccount == this.bankAccount &&
          other.bankIfsc == this.bankIfsc &&
          other.beneficiaryName == this.beneficiaryName &&
          other.invoicePrefix == this.invoicePrefix &&
          other.currentInvoiceSeq == this.currentInvoiceSeq &&
          other.financialYearStart == this.financialYearStart &&
          other.createdAt == this.createdAt);
}

class FirmsCompanion extends UpdateCompanion<Firm> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> pan;
  final Value<String?> gstin;
  final Value<String?> state;
  final Value<String?> stateCode;
  final Value<String?> logoPath;
  final Value<String?> bankName;
  final Value<String?> bankAccount;
  final Value<String?> bankIfsc;
  final Value<String?> beneficiaryName;
  final Value<String> invoicePrefix;
  final Value<int> currentInvoiceSeq;
  final Value<String?> financialYearStart;
  final Value<String?> createdAt;
  const FirmsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.pan = const Value.absent(),
    this.gstin = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccount = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.beneficiaryName = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.currentInvoiceSeq = const Value.absent(),
    this.financialYearStart = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FirmsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.pan = const Value.absent(),
    this.gstin = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccount = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.beneficiaryName = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.currentInvoiceSeq = const Value.absent(),
    this.financialYearStart = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Firm> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? pan,
    Expression<String>? gstin,
    Expression<String>? state,
    Expression<String>? stateCode,
    Expression<String>? logoPath,
    Expression<String>? bankName,
    Expression<String>? bankAccount,
    Expression<String>? bankIfsc,
    Expression<String>? beneficiaryName,
    Expression<String>? invoicePrefix,
    Expression<int>? currentInvoiceSeq,
    Expression<String>? financialYearStart,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (pan != null) 'pan': pan,
      if (gstin != null) 'gstin': gstin,
      if (state != null) 'state': state,
      if (stateCode != null) 'state_code': stateCode,
      if (logoPath != null) 'logo_path': logoPath,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccount != null) 'bank_account': bankAccount,
      if (bankIfsc != null) 'bank_ifsc': bankIfsc,
      if (beneficiaryName != null) 'beneficiary_name': beneficiaryName,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (currentInvoiceSeq != null) 'current_invoice_seq': currentInvoiceSeq,
      if (financialYearStart != null)
        'financial_year_start': financialYearStart,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FirmsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? pan,
    Value<String?>? gstin,
    Value<String?>? state,
    Value<String?>? stateCode,
    Value<String?>? logoPath,
    Value<String?>? bankName,
    Value<String?>? bankAccount,
    Value<String?>? bankIfsc,
    Value<String?>? beneficiaryName,
    Value<String>? invoicePrefix,
    Value<int>? currentInvoiceSeq,
    Value<String?>? financialYearStart,
    Value<String?>? createdAt,
  }) {
    return FirmsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      pan: pan ?? this.pan,
      gstin: gstin ?? this.gstin,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      logoPath: logoPath ?? this.logoPath,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      currentInvoiceSeq: currentInvoiceSeq ?? this.currentInvoiceSeq,
      financialYearStart: financialYearStart ?? this.financialYearStart,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (pan.present) {
      map['pan'] = Variable<String>(pan.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccount.present) {
      map['bank_account'] = Variable<String>(bankAccount.value);
    }
    if (bankIfsc.present) {
      map['bank_ifsc'] = Variable<String>(bankIfsc.value);
    }
    if (beneficiaryName.present) {
      map['beneficiary_name'] = Variable<String>(beneficiaryName.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (currentInvoiceSeq.present) {
      map['current_invoice_seq'] = Variable<int>(currentInvoiceSeq.value);
    }
    if (financialYearStart.present) {
      map['financial_year_start'] = Variable<String>(financialYearStart.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FirmsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('pan: $pan, ')
          ..write('gstin: $gstin, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('logoPath: $logoPath, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccount: $bankAccount, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('beneficiaryName: $beneficiaryName, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('currentInvoiceSeq: $currentInvoiceSeq, ')
          ..write('financialYearStart: $financialYearStart, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panMeta = const VerificationMeta('pan');
  @override
  late final GeneratedColumn<String> pan = GeneratedColumn<String>(
    'pan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateCodeMeta = const VerificationMeta(
    'stateCode',
  );
  @override
  late final GeneratedColumn<String> stateCode = GeneratedColumn<String>(
    'state_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnSacMeta = const VerificationMeta('hsnSac');
  @override
  late final GeneratedColumn<String> hsnSac = GeneratedColumn<String>(
    'hsn_sac',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('996791'),
  );
  static const VerificationMeta _invoiceTypeMeta = const VerificationMeta(
    'invoiceType',
  );
  @override
  late final GeneratedColumn<String> invoiceType = GeneratedColumn<String>(
    'invoice_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultLoadingPlaceMeta =
      const VerificationMeta('defaultLoadingPlace');
  @override
  late final GeneratedColumn<String> defaultLoadingPlace =
      GeneratedColumn<String>(
        'default_loading_place',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactEmailMeta = const VerificationMeta(
    'contactEmail',
  );
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
    'contact_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactPhoneMeta = const VerificationMeta(
    'contactPhone',
  );
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
    'contact_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    pan,
    gstin,
    state,
    stateCode,
    hsnSac,
    invoiceType,
    defaultLoadingPlace,
    contactName,
    contactEmail,
    contactPhone,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Company> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('pan')) {
      context.handle(
        _panMeta,
        pan.isAcceptableOrUnknown(data['pan']!, _panMeta),
      );
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('state_code')) {
      context.handle(
        _stateCodeMeta,
        stateCode.isAcceptableOrUnknown(data['state_code']!, _stateCodeMeta),
      );
    }
    if (data.containsKey('hsn_sac')) {
      context.handle(
        _hsnSacMeta,
        hsnSac.isAcceptableOrUnknown(data['hsn_sac']!, _hsnSacMeta),
      );
    }
    if (data.containsKey('invoice_type')) {
      context.handle(
        _invoiceTypeMeta,
        invoiceType.isAcceptableOrUnknown(
          data['invoice_type']!,
          _invoiceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceTypeMeta);
    }
    if (data.containsKey('default_loading_place')) {
      context.handle(
        _defaultLoadingPlaceMeta,
        defaultLoadingPlace.isAcceptableOrUnknown(
          data['default_loading_place']!,
          _defaultLoadingPlaceMeta,
        ),
      );
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    }
    if (data.containsKey('contact_email')) {
      context.handle(
        _contactEmailMeta,
        contactEmail.isAcceptableOrUnknown(
          data['contact_email']!,
          _contactEmailMeta,
        ),
      );
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
        _contactPhoneMeta,
        contactPhone.isAcceptableOrUnknown(
          data['contact_phone']!,
          _contactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      pan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan'],
      ),
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      stateCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_code'],
      ),
      hsnSac: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_sac'],
      )!,
      invoiceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_type'],
      )!,
      defaultLoadingPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_loading_place'],
      ),
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      ),
      contactEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_email'],
      ),
      contactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_phone'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final int id;
  final String name;
  final String? address;
  final String? pan;
  final String? gstin;
  final String? state;
  final String? stateCode;
  final String hsnSac;
  final String invoiceType;
  final String? defaultLoadingPlace;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final int isActive;
  final String? createdAt;
  final String? updatedAt;
  const Company({
    required this.id,
    required this.name,
    this.address,
    this.pan,
    this.gstin,
    this.state,
    this.stateCode,
    required this.hsnSac,
    required this.invoiceType,
    this.defaultLoadingPlace,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || pan != null) {
      map['pan'] = Variable<String>(pan);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || stateCode != null) {
      map['state_code'] = Variable<String>(stateCode);
    }
    map['hsn_sac'] = Variable<String>(hsnSac);
    map['invoice_type'] = Variable<String>(invoiceType);
    if (!nullToAbsent || defaultLoadingPlace != null) {
      map['default_loading_place'] = Variable<String>(defaultLoadingPlace);
    }
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    if (!nullToAbsent || contactEmail != null) {
      map['contact_email'] = Variable<String>(contactEmail);
    }
    if (!nullToAbsent || contactPhone != null) {
      map['contact_phone'] = Variable<String>(contactPhone);
    }
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      pan: pan == null && nullToAbsent ? const Value.absent() : Value(pan),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      stateCode: stateCode == null && nullToAbsent
          ? const Value.absent()
          : Value(stateCode),
      hsnSac: Value(hsnSac),
      invoiceType: Value(invoiceType),
      defaultLoadingPlace: defaultLoadingPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultLoadingPlace),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      contactEmail: contactEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(contactEmail),
      contactPhone: contactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPhone),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Company.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      pan: serializer.fromJson<String?>(json['pan']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      state: serializer.fromJson<String?>(json['state']),
      stateCode: serializer.fromJson<String?>(json['stateCode']),
      hsnSac: serializer.fromJson<String>(json['hsnSac']),
      invoiceType: serializer.fromJson<String>(json['invoiceType']),
      defaultLoadingPlace: serializer.fromJson<String?>(
        json['defaultLoadingPlace'],
      ),
      contactName: serializer.fromJson<String?>(json['contactName']),
      contactEmail: serializer.fromJson<String?>(json['contactEmail']),
      contactPhone: serializer.fromJson<String?>(json['contactPhone']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'pan': serializer.toJson<String?>(pan),
      'gstin': serializer.toJson<String?>(gstin),
      'state': serializer.toJson<String?>(state),
      'stateCode': serializer.toJson<String?>(stateCode),
      'hsnSac': serializer.toJson<String>(hsnSac),
      'invoiceType': serializer.toJson<String>(invoiceType),
      'defaultLoadingPlace': serializer.toJson<String?>(defaultLoadingPlace),
      'contactName': serializer.toJson<String?>(contactName),
      'contactEmail': serializer.toJson<String?>(contactEmail),
      'contactPhone': serializer.toJson<String?>(contactPhone),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Company copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> pan = const Value.absent(),
    Value<String?> gstin = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> stateCode = const Value.absent(),
    String? hsnSac,
    String? invoiceType,
    Value<String?> defaultLoadingPlace = const Value.absent(),
    Value<String?> contactName = const Value.absent(),
    Value<String?> contactEmail = const Value.absent(),
    Value<String?> contactPhone = const Value.absent(),
    int? isActive,
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Company(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    pan: pan.present ? pan.value : this.pan,
    gstin: gstin.present ? gstin.value : this.gstin,
    state: state.present ? state.value : this.state,
    stateCode: stateCode.present ? stateCode.value : this.stateCode,
    hsnSac: hsnSac ?? this.hsnSac,
    invoiceType: invoiceType ?? this.invoiceType,
    defaultLoadingPlace: defaultLoadingPlace.present
        ? defaultLoadingPlace.value
        : this.defaultLoadingPlace,
    contactName: contactName.present ? contactName.value : this.contactName,
    contactEmail: contactEmail.present ? contactEmail.value : this.contactEmail,
    contactPhone: contactPhone.present ? contactPhone.value : this.contactPhone,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      pan: data.pan.present ? data.pan.value : this.pan,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      state: data.state.present ? data.state.value : this.state,
      stateCode: data.stateCode.present ? data.stateCode.value : this.stateCode,
      hsnSac: data.hsnSac.present ? data.hsnSac.value : this.hsnSac,
      invoiceType: data.invoiceType.present
          ? data.invoiceType.value
          : this.invoiceType,
      defaultLoadingPlace: data.defaultLoadingPlace.present
          ? data.defaultLoadingPlace.value
          : this.defaultLoadingPlace,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('pan: $pan, ')
          ..write('gstin: $gstin, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('hsnSac: $hsnSac, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('defaultLoadingPlace: $defaultLoadingPlace, ')
          ..write('contactName: $contactName, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    pan,
    gstin,
    state,
    stateCode,
    hsnSac,
    invoiceType,
    defaultLoadingPlace,
    contactName,
    contactEmail,
    contactPhone,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.pan == this.pan &&
          other.gstin == this.gstin &&
          other.state == this.state &&
          other.stateCode == this.stateCode &&
          other.hsnSac == this.hsnSac &&
          other.invoiceType == this.invoiceType &&
          other.defaultLoadingPlace == this.defaultLoadingPlace &&
          other.contactName == this.contactName &&
          other.contactEmail == this.contactEmail &&
          other.contactPhone == this.contactPhone &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> pan;
  final Value<String?> gstin;
  final Value<String?> state;
  final Value<String?> stateCode;
  final Value<String> hsnSac;
  final Value<String> invoiceType;
  final Value<String?> defaultLoadingPlace;
  final Value<String?> contactName;
  final Value<String?> contactEmail;
  final Value<String?> contactPhone;
  final Value<int> isActive;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.pan = const Value.absent(),
    this.gstin = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.hsnSac = const Value.absent(),
    this.invoiceType = const Value.absent(),
    this.defaultLoadingPlace = const Value.absent(),
    this.contactName = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.pan = const Value.absent(),
    this.gstin = const Value.absent(),
    this.state = const Value.absent(),
    this.stateCode = const Value.absent(),
    this.hsnSac = const Value.absent(),
    required String invoiceType,
    this.defaultLoadingPlace = const Value.absent(),
    this.contactName = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       invoiceType = Value(invoiceType);
  static Insertable<Company> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? pan,
    Expression<String>? gstin,
    Expression<String>? state,
    Expression<String>? stateCode,
    Expression<String>? hsnSac,
    Expression<String>? invoiceType,
    Expression<String>? defaultLoadingPlace,
    Expression<String>? contactName,
    Expression<String>? contactEmail,
    Expression<String>? contactPhone,
    Expression<int>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (pan != null) 'pan': pan,
      if (gstin != null) 'gstin': gstin,
      if (state != null) 'state': state,
      if (stateCode != null) 'state_code': stateCode,
      if (hsnSac != null) 'hsn_sac': hsnSac,
      if (invoiceType != null) 'invoice_type': invoiceType,
      if (defaultLoadingPlace != null)
        'default_loading_place': defaultLoadingPlace,
      if (contactName != null) 'contact_name': contactName,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompaniesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? pan,
    Value<String?>? gstin,
    Value<String?>? state,
    Value<String?>? stateCode,
    Value<String>? hsnSac,
    Value<String>? invoiceType,
    Value<String?>? defaultLoadingPlace,
    Value<String?>? contactName,
    Value<String?>? contactEmail,
    Value<String?>? contactPhone,
    Value<int>? isActive,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
  }) {
    return CompaniesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      pan: pan ?? this.pan,
      gstin: gstin ?? this.gstin,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      hsnSac: hsnSac ?? this.hsnSac,
      invoiceType: invoiceType ?? this.invoiceType,
      defaultLoadingPlace: defaultLoadingPlace ?? this.defaultLoadingPlace,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (pan.present) {
      map['pan'] = Variable<String>(pan.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (stateCode.present) {
      map['state_code'] = Variable<String>(stateCode.value);
    }
    if (hsnSac.present) {
      map['hsn_sac'] = Variable<String>(hsnSac.value);
    }
    if (invoiceType.present) {
      map['invoice_type'] = Variable<String>(invoiceType.value);
    }
    if (defaultLoadingPlace.present) {
      map['default_loading_place'] = Variable<String>(
        defaultLoadingPlace.value,
      );
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('pan: $pan, ')
          ..write('gstin: $gstin, ')
          ..write('state: $state, ')
          ..write('stateCode: $stateCode, ')
          ..write('hsnSac: $hsnSac, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('defaultLoadingPlace: $defaultLoadingPlace, ')
          ..write('contactName: $contactName, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FreightRateCardsTable extends FreightRateCards
    with TableInfo<$FreightRateCardsTable, FreightRateCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FreightRateCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _loadingPlaceMeta = const VerificationMeta(
    'loadingPlace',
  );
  @override
  late final GeneratedColumn<String> loadingPlace = GeneratedColumn<String>(
    'loading_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unloadingPlaceMeta = const VerificationMeta(
    'unloadingPlace',
  );
  @override
  late final GeneratedColumn<String> unloadingPlace = GeneratedColumn<String>(
    'unloading_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateAmountMeta = const VerificationMeta(
    'rateAmount',
  );
  @override
  late final GeneratedColumn<double> rateAmount = GeneratedColumn<double>(
    'rate_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<String> effectiveFrom = GeneratedColumn<String>(
    'effective_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyId,
    loadingPlace,
    unloadingPlace,
    rateAmount,
    effectiveFrom,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'freight_rate_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<FreightRateCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('loading_place')) {
      context.handle(
        _loadingPlaceMeta,
        loadingPlace.isAcceptableOrUnknown(
          data['loading_place']!,
          _loadingPlaceMeta,
        ),
      );
    }
    if (data.containsKey('unloading_place')) {
      context.handle(
        _unloadingPlaceMeta,
        unloadingPlace.isAcceptableOrUnknown(
          data['unloading_place']!,
          _unloadingPlaceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unloadingPlaceMeta);
    }
    if (data.containsKey('rate_amount')) {
      context.handle(
        _rateAmountMeta,
        rateAmount.isAcceptableOrUnknown(data['rate_amount']!, _rateAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_rateAmountMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FreightRateCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FreightRateCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      )!,
      loadingPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loading_place'],
      ),
      unloadingPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unloading_place'],
      )!,
      rateAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_amount'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_from'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $FreightRateCardsTable createAlias(String alias) {
    return $FreightRateCardsTable(attachedDatabase, alias);
  }
}

class FreightRateCard extends DataClass implements Insertable<FreightRateCard> {
  final int id;
  final int companyId;
  final String? loadingPlace;
  final String unloadingPlace;
  final double rateAmount;
  final String? effectiveFrom;
  final int isActive;
  const FreightRateCard({
    required this.id,
    required this.companyId,
    this.loadingPlace,
    required this.unloadingPlace,
    required this.rateAmount,
    this.effectiveFrom,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_id'] = Variable<int>(companyId);
    if (!nullToAbsent || loadingPlace != null) {
      map['loading_place'] = Variable<String>(loadingPlace);
    }
    map['unloading_place'] = Variable<String>(unloadingPlace);
    map['rate_amount'] = Variable<double>(rateAmount);
    if (!nullToAbsent || effectiveFrom != null) {
      map['effective_from'] = Variable<String>(effectiveFrom);
    }
    map['is_active'] = Variable<int>(isActive);
    return map;
  }

  FreightRateCardsCompanion toCompanion(bool nullToAbsent) {
    return FreightRateCardsCompanion(
      id: Value(id),
      companyId: Value(companyId),
      loadingPlace: loadingPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(loadingPlace),
      unloadingPlace: Value(unloadingPlace),
      rateAmount: Value(rateAmount),
      effectiveFrom: effectiveFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveFrom),
      isActive: Value(isActive),
    );
  }

  factory FreightRateCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FreightRateCard(
      id: serializer.fromJson<int>(json['id']),
      companyId: serializer.fromJson<int>(json['companyId']),
      loadingPlace: serializer.fromJson<String?>(json['loadingPlace']),
      unloadingPlace: serializer.fromJson<String>(json['unloadingPlace']),
      rateAmount: serializer.fromJson<double>(json['rateAmount']),
      effectiveFrom: serializer.fromJson<String?>(json['effectiveFrom']),
      isActive: serializer.fromJson<int>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyId': serializer.toJson<int>(companyId),
      'loadingPlace': serializer.toJson<String?>(loadingPlace),
      'unloadingPlace': serializer.toJson<String>(unloadingPlace),
      'rateAmount': serializer.toJson<double>(rateAmount),
      'effectiveFrom': serializer.toJson<String?>(effectiveFrom),
      'isActive': serializer.toJson<int>(isActive),
    };
  }

  FreightRateCard copyWith({
    int? id,
    int? companyId,
    Value<String?> loadingPlace = const Value.absent(),
    String? unloadingPlace,
    double? rateAmount,
    Value<String?> effectiveFrom = const Value.absent(),
    int? isActive,
  }) => FreightRateCard(
    id: id ?? this.id,
    companyId: companyId ?? this.companyId,
    loadingPlace: loadingPlace.present ? loadingPlace.value : this.loadingPlace,
    unloadingPlace: unloadingPlace ?? this.unloadingPlace,
    rateAmount: rateAmount ?? this.rateAmount,
    effectiveFrom: effectiveFrom.present
        ? effectiveFrom.value
        : this.effectiveFrom,
    isActive: isActive ?? this.isActive,
  );
  FreightRateCard copyWithCompanion(FreightRateCardsCompanion data) {
    return FreightRateCard(
      id: data.id.present ? data.id.value : this.id,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      loadingPlace: data.loadingPlace.present
          ? data.loadingPlace.value
          : this.loadingPlace,
      unloadingPlace: data.unloadingPlace.present
          ? data.unloadingPlace.value
          : this.unloadingPlace,
      rateAmount: data.rateAmount.present
          ? data.rateAmount.value
          : this.rateAmount,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FreightRateCard(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('loadingPlace: $loadingPlace, ')
          ..write('unloadingPlace: $unloadingPlace, ')
          ..write('rateAmount: $rateAmount, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyId,
    loadingPlace,
    unloadingPlace,
    rateAmount,
    effectiveFrom,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FreightRateCard &&
          other.id == this.id &&
          other.companyId == this.companyId &&
          other.loadingPlace == this.loadingPlace &&
          other.unloadingPlace == this.unloadingPlace &&
          other.rateAmount == this.rateAmount &&
          other.effectiveFrom == this.effectiveFrom &&
          other.isActive == this.isActive);
}

class FreightRateCardsCompanion extends UpdateCompanion<FreightRateCard> {
  final Value<int> id;
  final Value<int> companyId;
  final Value<String?> loadingPlace;
  final Value<String> unloadingPlace;
  final Value<double> rateAmount;
  final Value<String?> effectiveFrom;
  final Value<int> isActive;
  const FreightRateCardsCompanion({
    this.id = const Value.absent(),
    this.companyId = const Value.absent(),
    this.loadingPlace = const Value.absent(),
    this.unloadingPlace = const Value.absent(),
    this.rateAmount = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  FreightRateCardsCompanion.insert({
    this.id = const Value.absent(),
    required int companyId,
    this.loadingPlace = const Value.absent(),
    required String unloadingPlace,
    required double rateAmount,
    this.effectiveFrom = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : companyId = Value(companyId),
       unloadingPlace = Value(unloadingPlace),
       rateAmount = Value(rateAmount);
  static Insertable<FreightRateCard> custom({
    Expression<int>? id,
    Expression<int>? companyId,
    Expression<String>? loadingPlace,
    Expression<String>? unloadingPlace,
    Expression<double>? rateAmount,
    Expression<String>? effectiveFrom,
    Expression<int>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyId != null) 'company_id': companyId,
      if (loadingPlace != null) 'loading_place': loadingPlace,
      if (unloadingPlace != null) 'unloading_place': unloadingPlace,
      if (rateAmount != null) 'rate_amount': rateAmount,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (isActive != null) 'is_active': isActive,
    });
  }

  FreightRateCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? companyId,
    Value<String?>? loadingPlace,
    Value<String>? unloadingPlace,
    Value<double>? rateAmount,
    Value<String?>? effectiveFrom,
    Value<int>? isActive,
  }) {
    return FreightRateCardsCompanion(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      loadingPlace: loadingPlace ?? this.loadingPlace,
      unloadingPlace: unloadingPlace ?? this.unloadingPlace,
      rateAmount: rateAmount ?? this.rateAmount,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (loadingPlace.present) {
      map['loading_place'] = Variable<String>(loadingPlace.value);
    }
    if (unloadingPlace.present) {
      map['unloading_place'] = Variable<String>(unloadingPlace.value);
    }
    if (rateAmount.present) {
      map['rate_amount'] = Variable<double>(rateAmount.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<String>(effectiveFrom.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FreightRateCardsCompanion(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('loadingPlace: $loadingPlace, ')
          ..write('unloadingPlace: $unloadingPlace, ')
          ..write('rateAmount: $rateAmount, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $PartnersTable extends Partners with TableInfo<$PartnersTable, Partner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panMeta = const VerificationMeta('pan');
  @override
  late final GeneratedColumn<String> pan = GeneratedColumn<String>(
    'pan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankAccountMeta = const VerificationMeta(
    'bankAccount',
  );
  @override
  late final GeneratedColumn<String> bankAccount = GeneratedColumn<String>(
    'bank_account',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankIfscMeta = const VerificationMeta(
    'bankIfsc',
  );
  @override
  late final GeneratedColumn<String> bankIfsc = GeneratedColumn<String>(
    'bank_ifsc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharePercentMeta = const VerificationMeta(
    'sharePercent',
  );
  @override
  late final GeneratedColumn<double> sharePercent = GeneratedColumn<double>(
    'share_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    pan,
    bankName,
    bankAccount,
    bankIfsc,
    sharePercent,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partners';
  @override
  VerificationContext validateIntegrity(
    Insertable<Partner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('pan')) {
      context.handle(
        _panMeta,
        pan.isAcceptableOrUnknown(data['pan']!, _panMeta),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('bank_account')) {
      context.handle(
        _bankAccountMeta,
        bankAccount.isAcceptableOrUnknown(
          data['bank_account']!,
          _bankAccountMeta,
        ),
      );
    }
    if (data.containsKey('bank_ifsc')) {
      context.handle(
        _bankIfscMeta,
        bankIfsc.isAcceptableOrUnknown(data['bank_ifsc']!, _bankIfscMeta),
      );
    }
    if (data.containsKey('share_percent')) {
      context.handle(
        _sharePercentMeta,
        sharePercent.isAcceptableOrUnknown(
          data['share_percent']!,
          _sharePercentMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Partner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Partner(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      pan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      bankAccount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account'],
      ),
      bankIfsc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_ifsc'],
      ),
      sharePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}share_percent'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $PartnersTable createAlias(String alias) {
    return $PartnersTable(attachedDatabase, alias);
  }
}

class Partner extends DataClass implements Insertable<Partner> {
  final int id;
  final String name;
  final String? phone;
  final String? pan;
  final String? bankName;
  final String? bankAccount;
  final String? bankIfsc;
  final double? sharePercent;
  final int isActive;
  const Partner({
    required this.id,
    required this.name,
    this.phone,
    this.pan,
    this.bankName,
    this.bankAccount,
    this.bankIfsc,
    this.sharePercent,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || pan != null) {
      map['pan'] = Variable<String>(pan);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || bankAccount != null) {
      map['bank_account'] = Variable<String>(bankAccount);
    }
    if (!nullToAbsent || bankIfsc != null) {
      map['bank_ifsc'] = Variable<String>(bankIfsc);
    }
    if (!nullToAbsent || sharePercent != null) {
      map['share_percent'] = Variable<double>(sharePercent);
    }
    map['is_active'] = Variable<int>(isActive);
    return map;
  }

  PartnersCompanion toCompanion(bool nullToAbsent) {
    return PartnersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      pan: pan == null && nullToAbsent ? const Value.absent() : Value(pan),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      bankAccount: bankAccount == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccount),
      bankIfsc: bankIfsc == null && nullToAbsent
          ? const Value.absent()
          : Value(bankIfsc),
      sharePercent: sharePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(sharePercent),
      isActive: Value(isActive),
    );
  }

  factory Partner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Partner(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      pan: serializer.fromJson<String?>(json['pan']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      bankAccount: serializer.fromJson<String?>(json['bankAccount']),
      bankIfsc: serializer.fromJson<String?>(json['bankIfsc']),
      sharePercent: serializer.fromJson<double?>(json['sharePercent']),
      isActive: serializer.fromJson<int>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'pan': serializer.toJson<String?>(pan),
      'bankName': serializer.toJson<String?>(bankName),
      'bankAccount': serializer.toJson<String?>(bankAccount),
      'bankIfsc': serializer.toJson<String?>(bankIfsc),
      'sharePercent': serializer.toJson<double?>(sharePercent),
      'isActive': serializer.toJson<int>(isActive),
    };
  }

  Partner copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> pan = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    Value<String?> bankAccount = const Value.absent(),
    Value<String?> bankIfsc = const Value.absent(),
    Value<double?> sharePercent = const Value.absent(),
    int? isActive,
  }) => Partner(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    pan: pan.present ? pan.value : this.pan,
    bankName: bankName.present ? bankName.value : this.bankName,
    bankAccount: bankAccount.present ? bankAccount.value : this.bankAccount,
    bankIfsc: bankIfsc.present ? bankIfsc.value : this.bankIfsc,
    sharePercent: sharePercent.present ? sharePercent.value : this.sharePercent,
    isActive: isActive ?? this.isActive,
  );
  Partner copyWithCompanion(PartnersCompanion data) {
    return Partner(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      pan: data.pan.present ? data.pan.value : this.pan,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccount: data.bankAccount.present
          ? data.bankAccount.value
          : this.bankAccount,
      bankIfsc: data.bankIfsc.present ? data.bankIfsc.value : this.bankIfsc,
      sharePercent: data.sharePercent.present
          ? data.sharePercent.value
          : this.sharePercent,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Partner(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('pan: $pan, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccount: $bankAccount, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('sharePercent: $sharePercent, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    pan,
    bankName,
    bankAccount,
    bankIfsc,
    sharePercent,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partner &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.pan == this.pan &&
          other.bankName == this.bankName &&
          other.bankAccount == this.bankAccount &&
          other.bankIfsc == this.bankIfsc &&
          other.sharePercent == this.sharePercent &&
          other.isActive == this.isActive);
}

class PartnersCompanion extends UpdateCompanion<Partner> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> pan;
  final Value<String?> bankName;
  final Value<String?> bankAccount;
  final Value<String?> bankIfsc;
  final Value<double?> sharePercent;
  final Value<int> isActive;
  const PartnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.pan = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccount = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.sharePercent = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PartnersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.pan = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccount = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.sharePercent = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Partner> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? pan,
    Expression<String>? bankName,
    Expression<String>? bankAccount,
    Expression<String>? bankIfsc,
    Expression<double>? sharePercent,
    Expression<int>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (pan != null) 'pan': pan,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccount != null) 'bank_account': bankAccount,
      if (bankIfsc != null) 'bank_ifsc': bankIfsc,
      if (sharePercent != null) 'share_percent': sharePercent,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PartnersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? pan,
    Value<String?>? bankName,
    Value<String?>? bankAccount,
    Value<String?>? bankIfsc,
    Value<double?>? sharePercent,
    Value<int>? isActive,
  }) {
    return PartnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      pan: pan ?? this.pan,
      bankName: bankName ?? this.bankName,
      bankAccount: bankAccount ?? this.bankAccount,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      sharePercent: sharePercent ?? this.sharePercent,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (pan.present) {
      map['pan'] = Variable<String>(pan.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccount.present) {
      map['bank_account'] = Variable<String>(bankAccount.value);
    }
    if (bankIfsc.present) {
      map['bank_ifsc'] = Variable<String>(bankIfsc.value);
    }
    if (sharePercent.present) {
      map['share_percent'] = Variable<double>(sharePercent.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('pan: $pan, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccount: $bankAccount, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('sharePercent: $sharePercent, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleNoMeta = const VerificationMeta(
    'vehicleNo',
  );
  @override
  late final GeneratedColumn<String> vehicleNo = GeneratedColumn<String>(
    'vehicle_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _partnerIdMeta = const VerificationMeta(
    'partnerId',
  );
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
    'partner_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES partners (id)',
    ),
  );
  static const VerificationMeta _vehicleTypeMeta = const VerificationMeta(
    'vehicleType',
  );
  @override
  late final GeneratedColumn<String> vehicleType = GeneratedColumn<String>(
    'vehicle_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fitnessExpiryMeta = const VerificationMeta(
    'fitnessExpiry',
  );
  @override
  late final GeneratedColumn<String> fitnessExpiry = GeneratedColumn<String>(
    'fitness_expiry',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insuranceExpiryMeta = const VerificationMeta(
    'insuranceExpiry',
  );
  @override
  late final GeneratedColumn<String> insuranceExpiry = GeneratedColumn<String>(
    'insurance_expiry',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleNo,
    partnerId,
    vehicleType,
    fitnessExpiry,
    insuranceExpiry,
    isActive,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_no')) {
      context.handle(
        _vehicleNoMeta,
        vehicleNo.isAcceptableOrUnknown(data['vehicle_no']!, _vehicleNoMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleNoMeta);
    }
    if (data.containsKey('partner_id')) {
      context.handle(
        _partnerIdMeta,
        partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta),
      );
    }
    if (data.containsKey('vehicle_type')) {
      context.handle(
        _vehicleTypeMeta,
        vehicleType.isAcceptableOrUnknown(
          data['vehicle_type']!,
          _vehicleTypeMeta,
        ),
      );
    }
    if (data.containsKey('fitness_expiry')) {
      context.handle(
        _fitnessExpiryMeta,
        fitnessExpiry.isAcceptableOrUnknown(
          data['fitness_expiry']!,
          _fitnessExpiryMeta,
        ),
      );
    }
    if (data.containsKey('insurance_expiry')) {
      context.handle(
        _insuranceExpiryMeta,
        insuranceExpiry.isAcceptableOrUnknown(
          data['insurance_expiry']!,
          _insuranceExpiryMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_no'],
      )!,
      partnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}partner_id'],
      ),
      vehicleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type'],
      ),
      fitnessExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fitness_expiry'],
      ),
      insuranceExpiry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insurance_expiry'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String vehicleNo;
  final int? partnerId;
  final String? vehicleType;
  final String? fitnessExpiry;
  final String? insuranceExpiry;
  final int isActive;
  final String? notes;
  const Vehicle({
    required this.id,
    required this.vehicleNo,
    this.partnerId,
    this.vehicleType,
    this.fitnessExpiry,
    this.insuranceExpiry,
    required this.isActive,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_no'] = Variable<String>(vehicleNo);
    if (!nullToAbsent || partnerId != null) {
      map['partner_id'] = Variable<int>(partnerId);
    }
    if (!nullToAbsent || vehicleType != null) {
      map['vehicle_type'] = Variable<String>(vehicleType);
    }
    if (!nullToAbsent || fitnessExpiry != null) {
      map['fitness_expiry'] = Variable<String>(fitnessExpiry);
    }
    if (!nullToAbsent || insuranceExpiry != null) {
      map['insurance_expiry'] = Variable<String>(insuranceExpiry);
    }
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      vehicleNo: Value(vehicleNo),
      partnerId: partnerId == null && nullToAbsent
          ? const Value.absent()
          : Value(partnerId),
      vehicleType: vehicleType == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleType),
      fitnessExpiry: fitnessExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(fitnessExpiry),
      insuranceExpiry: insuranceExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceExpiry),
      isActive: Value(isActive),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      vehicleNo: serializer.fromJson<String>(json['vehicleNo']),
      partnerId: serializer.fromJson<int?>(json['partnerId']),
      vehicleType: serializer.fromJson<String?>(json['vehicleType']),
      fitnessExpiry: serializer.fromJson<String?>(json['fitnessExpiry']),
      insuranceExpiry: serializer.fromJson<String?>(json['insuranceExpiry']),
      isActive: serializer.fromJson<int>(json['isActive']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleNo': serializer.toJson<String>(vehicleNo),
      'partnerId': serializer.toJson<int?>(partnerId),
      'vehicleType': serializer.toJson<String?>(vehicleType),
      'fitnessExpiry': serializer.toJson<String?>(fitnessExpiry),
      'insuranceExpiry': serializer.toJson<String?>(insuranceExpiry),
      'isActive': serializer.toJson<int>(isActive),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Vehicle copyWith({
    int? id,
    String? vehicleNo,
    Value<int?> partnerId = const Value.absent(),
    Value<String?> vehicleType = const Value.absent(),
    Value<String?> fitnessExpiry = const Value.absent(),
    Value<String?> insuranceExpiry = const Value.absent(),
    int? isActive,
    Value<String?> notes = const Value.absent(),
  }) => Vehicle(
    id: id ?? this.id,
    vehicleNo: vehicleNo ?? this.vehicleNo,
    partnerId: partnerId.present ? partnerId.value : this.partnerId,
    vehicleType: vehicleType.present ? vehicleType.value : this.vehicleType,
    fitnessExpiry: fitnessExpiry.present
        ? fitnessExpiry.value
        : this.fitnessExpiry,
    insuranceExpiry: insuranceExpiry.present
        ? insuranceExpiry.value
        : this.insuranceExpiry,
    isActive: isActive ?? this.isActive,
    notes: notes.present ? notes.value : this.notes,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      vehicleNo: data.vehicleNo.present ? data.vehicleNo.value : this.vehicleNo,
      partnerId: data.partnerId.present ? data.partnerId.value : this.partnerId,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      fitnessExpiry: data.fitnessExpiry.present
          ? data.fitnessExpiry.value
          : this.fitnessExpiry,
      insuranceExpiry: data.insuranceExpiry.present
          ? data.insuranceExpiry.value
          : this.insuranceExpiry,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('vehicleNo: $vehicleNo, ')
          ..write('partnerId: $partnerId, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('fitnessExpiry: $fitnessExpiry, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleNo,
    partnerId,
    vehicleType,
    fitnessExpiry,
    insuranceExpiry,
    isActive,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.vehicleNo == this.vehicleNo &&
          other.partnerId == this.partnerId &&
          other.vehicleType == this.vehicleType &&
          other.fitnessExpiry == this.fitnessExpiry &&
          other.insuranceExpiry == this.insuranceExpiry &&
          other.isActive == this.isActive &&
          other.notes == this.notes);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> vehicleNo;
  final Value<int?> partnerId;
  final Value<String?> vehicleType;
  final Value<String?> fitnessExpiry;
  final Value<String?> insuranceExpiry;
  final Value<int> isActive;
  final Value<String?> notes;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.vehicleNo = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.fitnessExpiry = const Value.absent(),
    this.insuranceExpiry = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String vehicleNo,
    this.partnerId = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.fitnessExpiry = const Value.absent(),
    this.insuranceExpiry = const Value.absent(),
    this.isActive = const Value.absent(),
    this.notes = const Value.absent(),
  }) : vehicleNo = Value(vehicleNo);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? vehicleNo,
    Expression<int>? partnerId,
    Expression<String>? vehicleType,
    Expression<String>? fitnessExpiry,
    Expression<String>? insuranceExpiry,
    Expression<int>? isActive,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleNo != null) 'vehicle_no': vehicleNo,
      if (partnerId != null) 'partner_id': partnerId,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (fitnessExpiry != null) 'fitness_expiry': fitnessExpiry,
      if (insuranceExpiry != null) 'insurance_expiry': insuranceExpiry,
      if (isActive != null) 'is_active': isActive,
      if (notes != null) 'notes': notes,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? vehicleNo,
    Value<int?>? partnerId,
    Value<String?>? vehicleType,
    Value<String?>? fitnessExpiry,
    Value<String?>? insuranceExpiry,
    Value<int>? isActive,
    Value<String?>? notes,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      partnerId: partnerId ?? this.partnerId,
      vehicleType: vehicleType ?? this.vehicleType,
      fitnessExpiry: fitnessExpiry ?? this.fitnessExpiry,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleNo.present) {
      map['vehicle_no'] = Variable<String>(vehicleNo.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(vehicleType.value);
    }
    if (fitnessExpiry.present) {
      map['fitness_expiry'] = Variable<String>(fitnessExpiry.value);
    }
    if (insuranceExpiry.present) {
      map['insurance_expiry'] = Variable<String>(insuranceExpiry.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleNo: $vehicleNo, ')
          ..write('partnerId: $partnerId, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('fitnessExpiry: $fitnessExpiry, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('isActive: $isActive, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<String> invoiceDate = GeneratedColumn<String>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<int> companyId = GeneratedColumn<int>(
    'company_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _invoiceTypeMeta = const VerificationMeta(
    'invoiceType',
  );
  @override
  late final GeneratedColumn<String> invoiceType = GeneratedColumn<String>(
    'invoice_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalFreightMeta = const VerificationMeta(
    'totalFreight',
  );
  @override
  late final GeneratedColumn<double> totalFreight = GeneratedColumn<double>(
    'total_freight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalFastagMeta = const VerificationMeta(
    'totalFastag',
  );
  @override
  late final GeneratedColumn<double> totalFastag = GeneratedColumn<double>(
    'total_fastag',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sgstRateMeta = const VerificationMeta(
    'sgstRate',
  );
  @override
  late final GeneratedColumn<double> sgstRate = GeneratedColumn<double>(
    'sgst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _cgstRateMeta = const VerificationMeta(
    'cgstRate',
  );
  @override
  late final GeneratedColumn<double> cgstRate = GeneratedColumn<double>(
    'cgst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _igstRateMeta = const VerificationMeta(
    'igstRate',
  );
  @override
  late final GeneratedColumn<double> igstRate = GeneratedColumn<double>(
    'igst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(5.0),
  );
  static const VerificationMeta _sgstAmountMeta = const VerificationMeta(
    'sgstAmount',
  );
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
    'sgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cgstAmountMeta = const VerificationMeta(
    'cgstAmount',
  );
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
    'cgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _igstAmountMeta = const VerificationMeta(
    'igstAmount',
  );
  @override
  late final GeneratedColumn<double> igstAmount = GeneratedColumn<double>(
    'igst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gstRcmTotalMeta = const VerificationMeta(
    'gstRcmTotal',
  );
  @override
  late final GeneratedColumn<double> gstRcmTotal = GeneratedColumn<double>(
    'gst_rcm_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tdsRateMeta = const VerificationMeta(
    'tdsRate',
  );
  @override
  late final GeneratedColumn<double> tdsRate = GeneratedColumn<double>(
    'tds_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.0),
  );
  static const VerificationMeta _tdsAmountMeta = const VerificationMeta(
    'tdsAmount',
  );
  @override
  late final GeneratedColumn<double> tdsAmount = GeneratedColumn<double>(
    'tds_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payableAmountMeta = const VerificationMeta(
    'payableAmount',
  );
  @override
  late final GeneratedColumn<double> payableAmount = GeneratedColumn<double>(
    'payable_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountInWordsMeta = const VerificationMeta(
    'amountInWords',
  );
  @override
  late final GeneratedColumn<String> amountInWords = GeneratedColumn<String>(
    'amount_in_words',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DRAFT'),
  );
  static const VerificationMeta _submissionDateMeta = const VerificationMeta(
    'submissionDate',
  );
  @override
  late final GeneratedColumn<String> submissionDate = GeneratedColumn<String>(
    'submission_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentReceivedMeta = const VerificationMeta(
    'paymentReceived',
  );
  @override
  late final GeneratedColumn<double> paymentReceived = GeneratedColumn<double>(
    'payment_received',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<String> paymentDate = GeneratedColumn<String>(
    'payment_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pdfPathMeta = const VerificationMeta(
    'pdfPath',
  );
  @override
  late final GeneratedColumn<String> pdfPath = GeneratedColumn<String>(
    'pdf_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cloudSyncedMeta = const VerificationMeta(
    'cloudSynced',
  );
  @override
  late final GeneratedColumn<int> cloudSynced = GeneratedColumn<int>(
    'cloud_synced',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _financialYearMeta = const VerificationMeta(
    'financialYear',
  );
  @override
  late final GeneratedColumn<String> financialYear = GeneratedColumn<String>(
    'financial_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    invoiceDate,
    companyId,
    invoiceType,
    totalFreight,
    totalFastag,
    totalAmount,
    sgstRate,
    cgstRate,
    igstRate,
    sgstAmount,
    cgstAmount,
    igstAmount,
    gstRcmTotal,
    tdsRate,
    tdsAmount,
    payableAmount,
    amountInWords,
    status,
    submissionDate,
    paymentReceived,
    paymentDate,
    pdfPath,
    cloudSynced,
    templateId,
    notes,
    financialYear,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    }
    if (data.containsKey('invoice_type')) {
      context.handle(
        _invoiceTypeMeta,
        invoiceType.isAcceptableOrUnknown(
          data['invoice_type']!,
          _invoiceTypeMeta,
        ),
      );
    }
    if (data.containsKey('total_freight')) {
      context.handle(
        _totalFreightMeta,
        totalFreight.isAcceptableOrUnknown(
          data['total_freight']!,
          _totalFreightMeta,
        ),
      );
    }
    if (data.containsKey('total_fastag')) {
      context.handle(
        _totalFastagMeta,
        totalFastag.isAcceptableOrUnknown(
          data['total_fastag']!,
          _totalFastagMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('sgst_rate')) {
      context.handle(
        _sgstRateMeta,
        sgstRate.isAcceptableOrUnknown(data['sgst_rate']!, _sgstRateMeta),
      );
    }
    if (data.containsKey('cgst_rate')) {
      context.handle(
        _cgstRateMeta,
        cgstRate.isAcceptableOrUnknown(data['cgst_rate']!, _cgstRateMeta),
      );
    }
    if (data.containsKey('igst_rate')) {
      context.handle(
        _igstRateMeta,
        igstRate.isAcceptableOrUnknown(data['igst_rate']!, _igstRateMeta),
      );
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
        _sgstAmountMeta,
        sgstAmount.isAcceptableOrUnknown(data['sgst_amount']!, _sgstAmountMeta),
      );
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
        _cgstAmountMeta,
        cgstAmount.isAcceptableOrUnknown(data['cgst_amount']!, _cgstAmountMeta),
      );
    }
    if (data.containsKey('igst_amount')) {
      context.handle(
        _igstAmountMeta,
        igstAmount.isAcceptableOrUnknown(data['igst_amount']!, _igstAmountMeta),
      );
    }
    if (data.containsKey('gst_rcm_total')) {
      context.handle(
        _gstRcmTotalMeta,
        gstRcmTotal.isAcceptableOrUnknown(
          data['gst_rcm_total']!,
          _gstRcmTotalMeta,
        ),
      );
    }
    if (data.containsKey('tds_rate')) {
      context.handle(
        _tdsRateMeta,
        tdsRate.isAcceptableOrUnknown(data['tds_rate']!, _tdsRateMeta),
      );
    }
    if (data.containsKey('tds_amount')) {
      context.handle(
        _tdsAmountMeta,
        tdsAmount.isAcceptableOrUnknown(data['tds_amount']!, _tdsAmountMeta),
      );
    }
    if (data.containsKey('payable_amount')) {
      context.handle(
        _payableAmountMeta,
        payableAmount.isAcceptableOrUnknown(
          data['payable_amount']!,
          _payableAmountMeta,
        ),
      );
    }
    if (data.containsKey('amount_in_words')) {
      context.handle(
        _amountInWordsMeta,
        amountInWords.isAcceptableOrUnknown(
          data['amount_in_words']!,
          _amountInWordsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('submission_date')) {
      context.handle(
        _submissionDateMeta,
        submissionDate.isAcceptableOrUnknown(
          data['submission_date']!,
          _submissionDateMeta,
        ),
      );
    }
    if (data.containsKey('payment_received')) {
      context.handle(
        _paymentReceivedMeta,
        paymentReceived.isAcceptableOrUnknown(
          data['payment_received']!,
          _paymentReceivedMeta,
        ),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    }
    if (data.containsKey('pdf_path')) {
      context.handle(
        _pdfPathMeta,
        pdfPath.isAcceptableOrUnknown(data['pdf_path']!, _pdfPathMeta),
      );
    }
    if (data.containsKey('cloud_synced')) {
      context.handle(
        _cloudSyncedMeta,
        cloudSynced.isAcceptableOrUnknown(
          data['cloud_synced']!,
          _cloudSyncedMeta,
        ),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('financial_year')) {
      context.handle(
        _financialYearMeta,
        financialYear.isAcceptableOrUnknown(
          data['financial_year']!,
          _financialYearMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_date'],
      )!,
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}company_id'],
      ),
      invoiceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_type'],
      ),
      totalFreight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_freight'],
      )!,
      totalFastag: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fastag'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      sgstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_rate'],
      )!,
      cgstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_rate'],
      )!,
      igstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}igst_rate'],
      )!,
      sgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_amount'],
      )!,
      cgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_amount'],
      )!,
      igstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}igst_amount'],
      )!,
      gstRcmTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rcm_total'],
      )!,
      tdsRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tds_rate'],
      )!,
      tdsAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tds_amount'],
      )!,
      payableAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payable_amount'],
      )!,
      amountInWords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_in_words'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      submissionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_date'],
      ),
      paymentReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payment_received'],
      )!,
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_date'],
      ),
      pdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_path'],
      ),
      cloudSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cloud_synced'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      financialYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}financial_year'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String invoiceNumber;
  final String invoiceDate;
  final int? companyId;
  final String? invoiceType;
  final double totalFreight;
  final double totalFastag;
  final double totalAmount;
  final double sgstRate;
  final double cgstRate;
  final double igstRate;
  final double sgstAmount;
  final double cgstAmount;
  final double igstAmount;
  final double gstRcmTotal;
  final double tdsRate;
  final double tdsAmount;
  final double payableAmount;
  final String? amountInWords;
  final String status;
  final String? submissionDate;
  final double paymentReceived;
  final String? paymentDate;
  final String? pdfPath;
  final int cloudSynced;
  final int? templateId;
  final String? notes;
  final String? financialYear;
  final String? createdAt;
  final String? updatedAt;
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.companyId,
    this.invoiceType,
    required this.totalFreight,
    required this.totalFastag,
    required this.totalAmount,
    required this.sgstRate,
    required this.cgstRate,
    required this.igstRate,
    required this.sgstAmount,
    required this.cgstAmount,
    required this.igstAmount,
    required this.gstRcmTotal,
    required this.tdsRate,
    required this.tdsAmount,
    required this.payableAmount,
    this.amountInWords,
    required this.status,
    this.submissionDate,
    required this.paymentReceived,
    this.paymentDate,
    this.pdfPath,
    required this.cloudSynced,
    this.templateId,
    this.notes,
    this.financialYear,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['invoice_date'] = Variable<String>(invoiceDate);
    if (!nullToAbsent || companyId != null) {
      map['company_id'] = Variable<int>(companyId);
    }
    if (!nullToAbsent || invoiceType != null) {
      map['invoice_type'] = Variable<String>(invoiceType);
    }
    map['total_freight'] = Variable<double>(totalFreight);
    map['total_fastag'] = Variable<double>(totalFastag);
    map['total_amount'] = Variable<double>(totalAmount);
    map['sgst_rate'] = Variable<double>(sgstRate);
    map['cgst_rate'] = Variable<double>(cgstRate);
    map['igst_rate'] = Variable<double>(igstRate);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['igst_amount'] = Variable<double>(igstAmount);
    map['gst_rcm_total'] = Variable<double>(gstRcmTotal);
    map['tds_rate'] = Variable<double>(tdsRate);
    map['tds_amount'] = Variable<double>(tdsAmount);
    map['payable_amount'] = Variable<double>(payableAmount);
    if (!nullToAbsent || amountInWords != null) {
      map['amount_in_words'] = Variable<String>(amountInWords);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || submissionDate != null) {
      map['submission_date'] = Variable<String>(submissionDate);
    }
    map['payment_received'] = Variable<double>(paymentReceived);
    if (!nullToAbsent || paymentDate != null) {
      map['payment_date'] = Variable<String>(paymentDate);
    }
    if (!nullToAbsent || pdfPath != null) {
      map['pdf_path'] = Variable<String>(pdfPath);
    }
    map['cloud_synced'] = Variable<int>(cloudSynced);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || financialYear != null) {
      map['financial_year'] = Variable<String>(financialYear);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      invoiceDate: Value(invoiceDate),
      companyId: companyId == null && nullToAbsent
          ? const Value.absent()
          : Value(companyId),
      invoiceType: invoiceType == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceType),
      totalFreight: Value(totalFreight),
      totalFastag: Value(totalFastag),
      totalAmount: Value(totalAmount),
      sgstRate: Value(sgstRate),
      cgstRate: Value(cgstRate),
      igstRate: Value(igstRate),
      sgstAmount: Value(sgstAmount),
      cgstAmount: Value(cgstAmount),
      igstAmount: Value(igstAmount),
      gstRcmTotal: Value(gstRcmTotal),
      tdsRate: Value(tdsRate),
      tdsAmount: Value(tdsAmount),
      payableAmount: Value(payableAmount),
      amountInWords: amountInWords == null && nullToAbsent
          ? const Value.absent()
          : Value(amountInWords),
      status: Value(status),
      submissionDate: submissionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(submissionDate),
      paymentReceived: Value(paymentReceived),
      paymentDate: paymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDate),
      pdfPath: pdfPath == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfPath),
      cloudSynced: Value(cloudSynced),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      financialYear: financialYear == null && nullToAbsent
          ? const Value.absent()
          : Value(financialYear),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      invoiceDate: serializer.fromJson<String>(json['invoiceDate']),
      companyId: serializer.fromJson<int?>(json['companyId']),
      invoiceType: serializer.fromJson<String?>(json['invoiceType']),
      totalFreight: serializer.fromJson<double>(json['totalFreight']),
      totalFastag: serializer.fromJson<double>(json['totalFastag']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      sgstRate: serializer.fromJson<double>(json['sgstRate']),
      cgstRate: serializer.fromJson<double>(json['cgstRate']),
      igstRate: serializer.fromJson<double>(json['igstRate']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      igstAmount: serializer.fromJson<double>(json['igstAmount']),
      gstRcmTotal: serializer.fromJson<double>(json['gstRcmTotal']),
      tdsRate: serializer.fromJson<double>(json['tdsRate']),
      tdsAmount: serializer.fromJson<double>(json['tdsAmount']),
      payableAmount: serializer.fromJson<double>(json['payableAmount']),
      amountInWords: serializer.fromJson<String?>(json['amountInWords']),
      status: serializer.fromJson<String>(json['status']),
      submissionDate: serializer.fromJson<String?>(json['submissionDate']),
      paymentReceived: serializer.fromJson<double>(json['paymentReceived']),
      paymentDate: serializer.fromJson<String?>(json['paymentDate']),
      pdfPath: serializer.fromJson<String?>(json['pdfPath']),
      cloudSynced: serializer.fromJson<int>(json['cloudSynced']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      notes: serializer.fromJson<String?>(json['notes']),
      financialYear: serializer.fromJson<String?>(json['financialYear']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'invoiceDate': serializer.toJson<String>(invoiceDate),
      'companyId': serializer.toJson<int?>(companyId),
      'invoiceType': serializer.toJson<String?>(invoiceType),
      'totalFreight': serializer.toJson<double>(totalFreight),
      'totalFastag': serializer.toJson<double>(totalFastag),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'sgstRate': serializer.toJson<double>(sgstRate),
      'cgstRate': serializer.toJson<double>(cgstRate),
      'igstRate': serializer.toJson<double>(igstRate),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'igstAmount': serializer.toJson<double>(igstAmount),
      'gstRcmTotal': serializer.toJson<double>(gstRcmTotal),
      'tdsRate': serializer.toJson<double>(tdsRate),
      'tdsAmount': serializer.toJson<double>(tdsAmount),
      'payableAmount': serializer.toJson<double>(payableAmount),
      'amountInWords': serializer.toJson<String?>(amountInWords),
      'status': serializer.toJson<String>(status),
      'submissionDate': serializer.toJson<String?>(submissionDate),
      'paymentReceived': serializer.toJson<double>(paymentReceived),
      'paymentDate': serializer.toJson<String?>(paymentDate),
      'pdfPath': serializer.toJson<String?>(pdfPath),
      'cloudSynced': serializer.toJson<int>(cloudSynced),
      'templateId': serializer.toJson<int?>(templateId),
      'notes': serializer.toJson<String?>(notes),
      'financialYear': serializer.toJson<String?>(financialYear),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Invoice copyWith({
    int? id,
    String? invoiceNumber,
    String? invoiceDate,
    Value<int?> companyId = const Value.absent(),
    Value<String?> invoiceType = const Value.absent(),
    double? totalFreight,
    double? totalFastag,
    double? totalAmount,
    double? sgstRate,
    double? cgstRate,
    double? igstRate,
    double? sgstAmount,
    double? cgstAmount,
    double? igstAmount,
    double? gstRcmTotal,
    double? tdsRate,
    double? tdsAmount,
    double? payableAmount,
    Value<String?> amountInWords = const Value.absent(),
    String? status,
    Value<String?> submissionDate = const Value.absent(),
    double? paymentReceived,
    Value<String?> paymentDate = const Value.absent(),
    Value<String?> pdfPath = const Value.absent(),
    int? cloudSynced,
    Value<int?> templateId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> financialYear = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Invoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    companyId: companyId.present ? companyId.value : this.companyId,
    invoiceType: invoiceType.present ? invoiceType.value : this.invoiceType,
    totalFreight: totalFreight ?? this.totalFreight,
    totalFastag: totalFastag ?? this.totalFastag,
    totalAmount: totalAmount ?? this.totalAmount,
    sgstRate: sgstRate ?? this.sgstRate,
    cgstRate: cgstRate ?? this.cgstRate,
    igstRate: igstRate ?? this.igstRate,
    sgstAmount: sgstAmount ?? this.sgstAmount,
    cgstAmount: cgstAmount ?? this.cgstAmount,
    igstAmount: igstAmount ?? this.igstAmount,
    gstRcmTotal: gstRcmTotal ?? this.gstRcmTotal,
    tdsRate: tdsRate ?? this.tdsRate,
    tdsAmount: tdsAmount ?? this.tdsAmount,
    payableAmount: payableAmount ?? this.payableAmount,
    amountInWords: amountInWords.present
        ? amountInWords.value
        : this.amountInWords,
    status: status ?? this.status,
    submissionDate: submissionDate.present
        ? submissionDate.value
        : this.submissionDate,
    paymentReceived: paymentReceived ?? this.paymentReceived,
    paymentDate: paymentDate.present ? paymentDate.value : this.paymentDate,
    pdfPath: pdfPath.present ? pdfPath.value : this.pdfPath,
    cloudSynced: cloudSynced ?? this.cloudSynced,
    templateId: templateId.present ? templateId.value : this.templateId,
    notes: notes.present ? notes.value : this.notes,
    financialYear: financialYear.present
        ? financialYear.value
        : this.financialYear,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      invoiceType: data.invoiceType.present
          ? data.invoiceType.value
          : this.invoiceType,
      totalFreight: data.totalFreight.present
          ? data.totalFreight.value
          : this.totalFreight,
      totalFastag: data.totalFastag.present
          ? data.totalFastag.value
          : this.totalFastag,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      sgstRate: data.sgstRate.present ? data.sgstRate.value : this.sgstRate,
      cgstRate: data.cgstRate.present ? data.cgstRate.value : this.cgstRate,
      igstRate: data.igstRate.present ? data.igstRate.value : this.igstRate,
      sgstAmount: data.sgstAmount.present
          ? data.sgstAmount.value
          : this.sgstAmount,
      cgstAmount: data.cgstAmount.present
          ? data.cgstAmount.value
          : this.cgstAmount,
      igstAmount: data.igstAmount.present
          ? data.igstAmount.value
          : this.igstAmount,
      gstRcmTotal: data.gstRcmTotal.present
          ? data.gstRcmTotal.value
          : this.gstRcmTotal,
      tdsRate: data.tdsRate.present ? data.tdsRate.value : this.tdsRate,
      tdsAmount: data.tdsAmount.present ? data.tdsAmount.value : this.tdsAmount,
      payableAmount: data.payableAmount.present
          ? data.payableAmount.value
          : this.payableAmount,
      amountInWords: data.amountInWords.present
          ? data.amountInWords.value
          : this.amountInWords,
      status: data.status.present ? data.status.value : this.status,
      submissionDate: data.submissionDate.present
          ? data.submissionDate.value
          : this.submissionDate,
      paymentReceived: data.paymentReceived.present
          ? data.paymentReceived.value
          : this.paymentReceived,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      pdfPath: data.pdfPath.present ? data.pdfPath.value : this.pdfPath,
      cloudSynced: data.cloudSynced.present
          ? data.cloudSynced.value
          : this.cloudSynced,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      notes: data.notes.present ? data.notes.value : this.notes,
      financialYear: data.financialYear.present
          ? data.financialYear.value
          : this.financialYear,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('companyId: $companyId, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('totalFreight: $totalFreight, ')
          ..write('totalFastag: $totalFastag, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('sgstRate: $sgstRate, ')
          ..write('cgstRate: $cgstRate, ')
          ..write('igstRate: $igstRate, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('igstAmount: $igstAmount, ')
          ..write('gstRcmTotal: $gstRcmTotal, ')
          ..write('tdsRate: $tdsRate, ')
          ..write('tdsAmount: $tdsAmount, ')
          ..write('payableAmount: $payableAmount, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('paymentReceived: $paymentReceived, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('cloudSynced: $cloudSynced, ')
          ..write('templateId: $templateId, ')
          ..write('notes: $notes, ')
          ..write('financialYear: $financialYear, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    invoiceNumber,
    invoiceDate,
    companyId,
    invoiceType,
    totalFreight,
    totalFastag,
    totalAmount,
    sgstRate,
    cgstRate,
    igstRate,
    sgstAmount,
    cgstAmount,
    igstAmount,
    gstRcmTotal,
    tdsRate,
    tdsAmount,
    payableAmount,
    amountInWords,
    status,
    submissionDate,
    paymentReceived,
    paymentDate,
    pdfPath,
    cloudSynced,
    templateId,
    notes,
    financialYear,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.invoiceDate == this.invoiceDate &&
          other.companyId == this.companyId &&
          other.invoiceType == this.invoiceType &&
          other.totalFreight == this.totalFreight &&
          other.totalFastag == this.totalFastag &&
          other.totalAmount == this.totalAmount &&
          other.sgstRate == this.sgstRate &&
          other.cgstRate == this.cgstRate &&
          other.igstRate == this.igstRate &&
          other.sgstAmount == this.sgstAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.igstAmount == this.igstAmount &&
          other.gstRcmTotal == this.gstRcmTotal &&
          other.tdsRate == this.tdsRate &&
          other.tdsAmount == this.tdsAmount &&
          other.payableAmount == this.payableAmount &&
          other.amountInWords == this.amountInWords &&
          other.status == this.status &&
          other.submissionDate == this.submissionDate &&
          other.paymentReceived == this.paymentReceived &&
          other.paymentDate == this.paymentDate &&
          other.pdfPath == this.pdfPath &&
          other.cloudSynced == this.cloudSynced &&
          other.templateId == this.templateId &&
          other.notes == this.notes &&
          other.financialYear == this.financialYear &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<String> invoiceDate;
  final Value<int?> companyId;
  final Value<String?> invoiceType;
  final Value<double> totalFreight;
  final Value<double> totalFastag;
  final Value<double> totalAmount;
  final Value<double> sgstRate;
  final Value<double> cgstRate;
  final Value<double> igstRate;
  final Value<double> sgstAmount;
  final Value<double> cgstAmount;
  final Value<double> igstAmount;
  final Value<double> gstRcmTotal;
  final Value<double> tdsRate;
  final Value<double> tdsAmount;
  final Value<double> payableAmount;
  final Value<String?> amountInWords;
  final Value<String> status;
  final Value<String?> submissionDate;
  final Value<double> paymentReceived;
  final Value<String?> paymentDate;
  final Value<String?> pdfPath;
  final Value<int> cloudSynced;
  final Value<int?> templateId;
  final Value<String?> notes;
  final Value<String?> financialYear;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.companyId = const Value.absent(),
    this.invoiceType = const Value.absent(),
    this.totalFreight = const Value.absent(),
    this.totalFastag = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.sgstRate = const Value.absent(),
    this.cgstRate = const Value.absent(),
    this.igstRate = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.igstAmount = const Value.absent(),
    this.gstRcmTotal = const Value.absent(),
    this.tdsRate = const Value.absent(),
    this.tdsAmount = const Value.absent(),
    this.payableAmount = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.status = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.paymentReceived = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.cloudSynced = const Value.absent(),
    this.templateId = const Value.absent(),
    this.notes = const Value.absent(),
    this.financialYear = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    required String invoiceDate,
    this.companyId = const Value.absent(),
    this.invoiceType = const Value.absent(),
    this.totalFreight = const Value.absent(),
    this.totalFastag = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.sgstRate = const Value.absent(),
    this.cgstRate = const Value.absent(),
    this.igstRate = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.igstAmount = const Value.absent(),
    this.gstRcmTotal = const Value.absent(),
    this.tdsRate = const Value.absent(),
    this.tdsAmount = const Value.absent(),
    this.payableAmount = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.status = const Value.absent(),
    this.submissionDate = const Value.absent(),
    this.paymentReceived = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.cloudSynced = const Value.absent(),
    this.templateId = const Value.absent(),
    this.notes = const Value.absent(),
    this.financialYear = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : invoiceNumber = Value(invoiceNumber),
       invoiceDate = Value(invoiceDate);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? invoiceDate,
    Expression<int>? companyId,
    Expression<String>? invoiceType,
    Expression<double>? totalFreight,
    Expression<double>? totalFastag,
    Expression<double>? totalAmount,
    Expression<double>? sgstRate,
    Expression<double>? cgstRate,
    Expression<double>? igstRate,
    Expression<double>? sgstAmount,
    Expression<double>? cgstAmount,
    Expression<double>? igstAmount,
    Expression<double>? gstRcmTotal,
    Expression<double>? tdsRate,
    Expression<double>? tdsAmount,
    Expression<double>? payableAmount,
    Expression<String>? amountInWords,
    Expression<String>? status,
    Expression<String>? submissionDate,
    Expression<double>? paymentReceived,
    Expression<String>? paymentDate,
    Expression<String>? pdfPath,
    Expression<int>? cloudSynced,
    Expression<int>? templateId,
    Expression<String>? notes,
    Expression<String>? financialYear,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (companyId != null) 'company_id': companyId,
      if (invoiceType != null) 'invoice_type': invoiceType,
      if (totalFreight != null) 'total_freight': totalFreight,
      if (totalFastag != null) 'total_fastag': totalFastag,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (sgstRate != null) 'sgst_rate': sgstRate,
      if (cgstRate != null) 'cgst_rate': cgstRate,
      if (igstRate != null) 'igst_rate': igstRate,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (igstAmount != null) 'igst_amount': igstAmount,
      if (gstRcmTotal != null) 'gst_rcm_total': gstRcmTotal,
      if (tdsRate != null) 'tds_rate': tdsRate,
      if (tdsAmount != null) 'tds_amount': tdsAmount,
      if (payableAmount != null) 'payable_amount': payableAmount,
      if (amountInWords != null) 'amount_in_words': amountInWords,
      if (status != null) 'status': status,
      if (submissionDate != null) 'submission_date': submissionDate,
      if (paymentReceived != null) 'payment_received': paymentReceived,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (pdfPath != null) 'pdf_path': pdfPath,
      if (cloudSynced != null) 'cloud_synced': cloudSynced,
      if (templateId != null) 'template_id': templateId,
      if (notes != null) 'notes': notes,
      if (financialYear != null) 'financial_year': financialYear,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNumber,
    Value<String>? invoiceDate,
    Value<int?>? companyId,
    Value<String?>? invoiceType,
    Value<double>? totalFreight,
    Value<double>? totalFastag,
    Value<double>? totalAmount,
    Value<double>? sgstRate,
    Value<double>? cgstRate,
    Value<double>? igstRate,
    Value<double>? sgstAmount,
    Value<double>? cgstAmount,
    Value<double>? igstAmount,
    Value<double>? gstRcmTotal,
    Value<double>? tdsRate,
    Value<double>? tdsAmount,
    Value<double>? payableAmount,
    Value<String?>? amountInWords,
    Value<String>? status,
    Value<String?>? submissionDate,
    Value<double>? paymentReceived,
    Value<String?>? paymentDate,
    Value<String?>? pdfPath,
    Value<int>? cloudSynced,
    Value<int?>? templateId,
    Value<String?>? notes,
    Value<String?>? financialYear,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      companyId: companyId ?? this.companyId,
      invoiceType: invoiceType ?? this.invoiceType,
      totalFreight: totalFreight ?? this.totalFreight,
      totalFastag: totalFastag ?? this.totalFastag,
      totalAmount: totalAmount ?? this.totalAmount,
      sgstRate: sgstRate ?? this.sgstRate,
      cgstRate: cgstRate ?? this.cgstRate,
      igstRate: igstRate ?? this.igstRate,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      igstAmount: igstAmount ?? this.igstAmount,
      gstRcmTotal: gstRcmTotal ?? this.gstRcmTotal,
      tdsRate: tdsRate ?? this.tdsRate,
      tdsAmount: tdsAmount ?? this.tdsAmount,
      payableAmount: payableAmount ?? this.payableAmount,
      amountInWords: amountInWords ?? this.amountInWords,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
      paymentReceived: paymentReceived ?? this.paymentReceived,
      paymentDate: paymentDate ?? this.paymentDate,
      pdfPath: pdfPath ?? this.pdfPath,
      cloudSynced: cloudSynced ?? this.cloudSynced,
      templateId: templateId ?? this.templateId,
      notes: notes ?? this.notes,
      financialYear: financialYear ?? this.financialYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<String>(invoiceDate.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<int>(companyId.value);
    }
    if (invoiceType.present) {
      map['invoice_type'] = Variable<String>(invoiceType.value);
    }
    if (totalFreight.present) {
      map['total_freight'] = Variable<double>(totalFreight.value);
    }
    if (totalFastag.present) {
      map['total_fastag'] = Variable<double>(totalFastag.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (sgstRate.present) {
      map['sgst_rate'] = Variable<double>(sgstRate.value);
    }
    if (cgstRate.present) {
      map['cgst_rate'] = Variable<double>(cgstRate.value);
    }
    if (igstRate.present) {
      map['igst_rate'] = Variable<double>(igstRate.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (igstAmount.present) {
      map['igst_amount'] = Variable<double>(igstAmount.value);
    }
    if (gstRcmTotal.present) {
      map['gst_rcm_total'] = Variable<double>(gstRcmTotal.value);
    }
    if (tdsRate.present) {
      map['tds_rate'] = Variable<double>(tdsRate.value);
    }
    if (tdsAmount.present) {
      map['tds_amount'] = Variable<double>(tdsAmount.value);
    }
    if (payableAmount.present) {
      map['payable_amount'] = Variable<double>(payableAmount.value);
    }
    if (amountInWords.present) {
      map['amount_in_words'] = Variable<String>(amountInWords.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (submissionDate.present) {
      map['submission_date'] = Variable<String>(submissionDate.value);
    }
    if (paymentReceived.present) {
      map['payment_received'] = Variable<double>(paymentReceived.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<String>(paymentDate.value);
    }
    if (pdfPath.present) {
      map['pdf_path'] = Variable<String>(pdfPath.value);
    }
    if (cloudSynced.present) {
      map['cloud_synced'] = Variable<int>(cloudSynced.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (financialYear.present) {
      map['financial_year'] = Variable<String>(financialYear.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('companyId: $companyId, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('totalFreight: $totalFreight, ')
          ..write('totalFastag: $totalFastag, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('sgstRate: $sgstRate, ')
          ..write('cgstRate: $cgstRate, ')
          ..write('igstRate: $igstRate, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('igstAmount: $igstAmount, ')
          ..write('gstRcmTotal: $gstRcmTotal, ')
          ..write('tdsRate: $tdsRate, ')
          ..write('tdsAmount: $tdsAmount, ')
          ..write('payableAmount: $payableAmount, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('submissionDate: $submissionDate, ')
          ..write('paymentReceived: $paymentReceived, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('cloudSynced: $cloudSynced, ')
          ..write('templateId: $templateId, ')
          ..write('notes: $notes, ')
          ..write('financialYear: $financialYear, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceRowsTable extends InvoiceRows
    with TableInfo<$InvoiceRowsTable, InvoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _rowOrderMeta = const VerificationMeta(
    'rowOrder',
  );
  @override
  late final GeneratedColumn<int> rowOrder = GeneratedColumn<int>(
    'row_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tripDateMeta = const VerificationMeta(
    'tripDate',
  );
  @override
  late final GeneratedColumn<String> tripDate = GeneratedColumn<String>(
    'trip_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grNumberMeta = const VerificationMeta(
    'grNumber',
  );
  @override
  late final GeneratedColumn<String> grNumber = GeneratedColumn<String>(
    'gr_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _vehicleNoTextMeta = const VerificationMeta(
    'vehicleNoText',
  );
  @override
  late final GeneratedColumn<String> vehicleNoText = GeneratedColumn<String>(
    'vehicle_no_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _freightChargeMeta = const VerificationMeta(
    'freightCharge',
  );
  @override
  late final GeneratedColumn<double> freightCharge = GeneratedColumn<double>(
    'freight_charge',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fastagChargeMeta = const VerificationMeta(
    'fastagCharge',
  );
  @override
  late final GeneratedColumn<double> fastagCharge = GeneratedColumn<double>(
    'fastag_charge',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceRefNoMeta = const VerificationMeta(
    'invoiceRefNo',
  );
  @override
  late final GeneratedColumn<String> invoiceRefNo = GeneratedColumn<String>(
    'invoice_ref_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadingPlaceMeta = const VerificationMeta(
    'loadingPlace',
  );
  @override
  late final GeneratedColumn<String> loadingPlace = GeneratedColumn<String>(
    'loading_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unloadingPlaceMeta = const VerificationMeta(
    'unloadingPlace',
  );
  @override
  late final GeneratedColumn<String> unloadingPlace = GeneratedColumn<String>(
    'unloading_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rowAmountMeta = const VerificationMeta(
    'rowAmount',
  );
  @override
  late final GeneratedColumn<double> rowAmount = GeneratedColumn<double>(
    'row_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    rowOrder,
    tripDate,
    grNumber,
    vehicleId,
    vehicleNoText,
    freightCharge,
    fastagCharge,
    invoiceRefNo,
    loadingPlace,
    unloadingPlace,
    rowAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    if (data.containsKey('row_order')) {
      context.handle(
        _rowOrderMeta,
        rowOrder.isAcceptableOrUnknown(data['row_order']!, _rowOrderMeta),
      );
    }
    if (data.containsKey('trip_date')) {
      context.handle(
        _tripDateMeta,
        tripDate.isAcceptableOrUnknown(data['trip_date']!, _tripDateMeta),
      );
    }
    if (data.containsKey('gr_number')) {
      context.handle(
        _grNumberMeta,
        grNumber.isAcceptableOrUnknown(data['gr_number']!, _grNumberMeta),
      );
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('vehicle_no_text')) {
      context.handle(
        _vehicleNoTextMeta,
        vehicleNoText.isAcceptableOrUnknown(
          data['vehicle_no_text']!,
          _vehicleNoTextMeta,
        ),
      );
    }
    if (data.containsKey('freight_charge')) {
      context.handle(
        _freightChargeMeta,
        freightCharge.isAcceptableOrUnknown(
          data['freight_charge']!,
          _freightChargeMeta,
        ),
      );
    }
    if (data.containsKey('fastag_charge')) {
      context.handle(
        _fastagChargeMeta,
        fastagCharge.isAcceptableOrUnknown(
          data['fastag_charge']!,
          _fastagChargeMeta,
        ),
      );
    }
    if (data.containsKey('invoice_ref_no')) {
      context.handle(
        _invoiceRefNoMeta,
        invoiceRefNo.isAcceptableOrUnknown(
          data['invoice_ref_no']!,
          _invoiceRefNoMeta,
        ),
      );
    }
    if (data.containsKey('loading_place')) {
      context.handle(
        _loadingPlaceMeta,
        loadingPlace.isAcceptableOrUnknown(
          data['loading_place']!,
          _loadingPlaceMeta,
        ),
      );
    }
    if (data.containsKey('unloading_place')) {
      context.handle(
        _unloadingPlaceMeta,
        unloadingPlace.isAcceptableOrUnknown(
          data['unloading_place']!,
          _unloadingPlaceMeta,
        ),
      );
    }
    if (data.containsKey('row_amount')) {
      context.handle(
        _rowAmountMeta,
        rowAmount.isAcceptableOrUnknown(data['row_amount']!, _rowAmountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      ),
      rowOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}row_order'],
      ),
      tripDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_date'],
      ),
      grNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gr_number'],
      ),
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      ),
      vehicleNoText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_no_text'],
      ),
      freightCharge: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}freight_charge'],
      )!,
      fastagCharge: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fastag_charge'],
      )!,
      invoiceRefNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_ref_no'],
      ),
      loadingPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loading_place'],
      ),
      unloadingPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unloading_place'],
      ),
      rowAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}row_amount'],
      )!,
    );
  }

  @override
  $InvoiceRowsTable createAlias(String alias) {
    return $InvoiceRowsTable(attachedDatabase, alias);
  }
}

class InvoiceRow extends DataClass implements Insertable<InvoiceRow> {
  final int id;
  final int? invoiceId;
  final int? rowOrder;
  final String? tripDate;
  final String? grNumber;
  final int? vehicleId;
  final String? vehicleNoText;
  final double freightCharge;
  final double fastagCharge;
  final String? invoiceRefNo;
  final String? loadingPlace;
  final String? unloadingPlace;
  final double rowAmount;
  const InvoiceRow({
    required this.id,
    this.invoiceId,
    this.rowOrder,
    this.tripDate,
    this.grNumber,
    this.vehicleId,
    this.vehicleNoText,
    required this.freightCharge,
    required this.fastagCharge,
    this.invoiceRefNo,
    this.loadingPlace,
    this.unloadingPlace,
    required this.rowAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    if (!nullToAbsent || rowOrder != null) {
      map['row_order'] = Variable<int>(rowOrder);
    }
    if (!nullToAbsent || tripDate != null) {
      map['trip_date'] = Variable<String>(tripDate);
    }
    if (!nullToAbsent || grNumber != null) {
      map['gr_number'] = Variable<String>(grNumber);
    }
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<int>(vehicleId);
    }
    if (!nullToAbsent || vehicleNoText != null) {
      map['vehicle_no_text'] = Variable<String>(vehicleNoText);
    }
    map['freight_charge'] = Variable<double>(freightCharge);
    map['fastag_charge'] = Variable<double>(fastagCharge);
    if (!nullToAbsent || invoiceRefNo != null) {
      map['invoice_ref_no'] = Variable<String>(invoiceRefNo);
    }
    if (!nullToAbsent || loadingPlace != null) {
      map['loading_place'] = Variable<String>(loadingPlace);
    }
    if (!nullToAbsent || unloadingPlace != null) {
      map['unloading_place'] = Variable<String>(unloadingPlace);
    }
    map['row_amount'] = Variable<double>(rowAmount);
    return map;
  }

  InvoiceRowsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceRowsCompanion(
      id: Value(id),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      rowOrder: rowOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(rowOrder),
      tripDate: tripDate == null && nullToAbsent
          ? const Value.absent()
          : Value(tripDate),
      grNumber: grNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(grNumber),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      vehicleNoText: vehicleNoText == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleNoText),
      freightCharge: Value(freightCharge),
      fastagCharge: Value(fastagCharge),
      invoiceRefNo: invoiceRefNo == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceRefNo),
      loadingPlace: loadingPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(loadingPlace),
      unloadingPlace: unloadingPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(unloadingPlace),
      rowAmount: Value(rowAmount),
    );
  }

  factory InvoiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceRow(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
      rowOrder: serializer.fromJson<int?>(json['rowOrder']),
      tripDate: serializer.fromJson<String?>(json['tripDate']),
      grNumber: serializer.fromJson<String?>(json['grNumber']),
      vehicleId: serializer.fromJson<int?>(json['vehicleId']),
      vehicleNoText: serializer.fromJson<String?>(json['vehicleNoText']),
      freightCharge: serializer.fromJson<double>(json['freightCharge']),
      fastagCharge: serializer.fromJson<double>(json['fastagCharge']),
      invoiceRefNo: serializer.fromJson<String?>(json['invoiceRefNo']),
      loadingPlace: serializer.fromJson<String?>(json['loadingPlace']),
      unloadingPlace: serializer.fromJson<String?>(json['unloadingPlace']),
      rowAmount: serializer.fromJson<double>(json['rowAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int?>(invoiceId),
      'rowOrder': serializer.toJson<int?>(rowOrder),
      'tripDate': serializer.toJson<String?>(tripDate),
      'grNumber': serializer.toJson<String?>(grNumber),
      'vehicleId': serializer.toJson<int?>(vehicleId),
      'vehicleNoText': serializer.toJson<String?>(vehicleNoText),
      'freightCharge': serializer.toJson<double>(freightCharge),
      'fastagCharge': serializer.toJson<double>(fastagCharge),
      'invoiceRefNo': serializer.toJson<String?>(invoiceRefNo),
      'loadingPlace': serializer.toJson<String?>(loadingPlace),
      'unloadingPlace': serializer.toJson<String?>(unloadingPlace),
      'rowAmount': serializer.toJson<double>(rowAmount),
    };
  }

  InvoiceRow copyWith({
    int? id,
    Value<int?> invoiceId = const Value.absent(),
    Value<int?> rowOrder = const Value.absent(),
    Value<String?> tripDate = const Value.absent(),
    Value<String?> grNumber = const Value.absent(),
    Value<int?> vehicleId = const Value.absent(),
    Value<String?> vehicleNoText = const Value.absent(),
    double? freightCharge,
    double? fastagCharge,
    Value<String?> invoiceRefNo = const Value.absent(),
    Value<String?> loadingPlace = const Value.absent(),
    Value<String?> unloadingPlace = const Value.absent(),
    double? rowAmount,
  }) => InvoiceRow(
    id: id ?? this.id,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    rowOrder: rowOrder.present ? rowOrder.value : this.rowOrder,
    tripDate: tripDate.present ? tripDate.value : this.tripDate,
    grNumber: grNumber.present ? grNumber.value : this.grNumber,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    vehicleNoText: vehicleNoText.present
        ? vehicleNoText.value
        : this.vehicleNoText,
    freightCharge: freightCharge ?? this.freightCharge,
    fastagCharge: fastagCharge ?? this.fastagCharge,
    invoiceRefNo: invoiceRefNo.present ? invoiceRefNo.value : this.invoiceRefNo,
    loadingPlace: loadingPlace.present ? loadingPlace.value : this.loadingPlace,
    unloadingPlace: unloadingPlace.present
        ? unloadingPlace.value
        : this.unloadingPlace,
    rowAmount: rowAmount ?? this.rowAmount,
  );
  InvoiceRow copyWithCompanion(InvoiceRowsCompanion data) {
    return InvoiceRow(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      rowOrder: data.rowOrder.present ? data.rowOrder.value : this.rowOrder,
      tripDate: data.tripDate.present ? data.tripDate.value : this.tripDate,
      grNumber: data.grNumber.present ? data.grNumber.value : this.grNumber,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      vehicleNoText: data.vehicleNoText.present
          ? data.vehicleNoText.value
          : this.vehicleNoText,
      freightCharge: data.freightCharge.present
          ? data.freightCharge.value
          : this.freightCharge,
      fastagCharge: data.fastagCharge.present
          ? data.fastagCharge.value
          : this.fastagCharge,
      invoiceRefNo: data.invoiceRefNo.present
          ? data.invoiceRefNo.value
          : this.invoiceRefNo,
      loadingPlace: data.loadingPlace.present
          ? data.loadingPlace.value
          : this.loadingPlace,
      unloadingPlace: data.unloadingPlace.present
          ? data.unloadingPlace.value
          : this.unloadingPlace,
      rowAmount: data.rowAmount.present ? data.rowAmount.value : this.rowAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('rowOrder: $rowOrder, ')
          ..write('tripDate: $tripDate, ')
          ..write('grNumber: $grNumber, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNoText: $vehicleNoText, ')
          ..write('freightCharge: $freightCharge, ')
          ..write('fastagCharge: $fastagCharge, ')
          ..write('invoiceRefNo: $invoiceRefNo, ')
          ..write('loadingPlace: $loadingPlace, ')
          ..write('unloadingPlace: $unloadingPlace, ')
          ..write('rowAmount: $rowAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    rowOrder,
    tripDate,
    grNumber,
    vehicleId,
    vehicleNoText,
    freightCharge,
    fastagCharge,
    invoiceRefNo,
    loadingPlace,
    unloadingPlace,
    rowAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.rowOrder == this.rowOrder &&
          other.tripDate == this.tripDate &&
          other.grNumber == this.grNumber &&
          other.vehicleId == this.vehicleId &&
          other.vehicleNoText == this.vehicleNoText &&
          other.freightCharge == this.freightCharge &&
          other.fastagCharge == this.fastagCharge &&
          other.invoiceRefNo == this.invoiceRefNo &&
          other.loadingPlace == this.loadingPlace &&
          other.unloadingPlace == this.unloadingPlace &&
          other.rowAmount == this.rowAmount);
}

class InvoiceRowsCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<int> id;
  final Value<int?> invoiceId;
  final Value<int?> rowOrder;
  final Value<String?> tripDate;
  final Value<String?> grNumber;
  final Value<int?> vehicleId;
  final Value<String?> vehicleNoText;
  final Value<double> freightCharge;
  final Value<double> fastagCharge;
  final Value<String?> invoiceRefNo;
  final Value<String?> loadingPlace;
  final Value<String?> unloadingPlace;
  final Value<double> rowAmount;
  const InvoiceRowsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.rowOrder = const Value.absent(),
    this.tripDate = const Value.absent(),
    this.grNumber = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.vehicleNoText = const Value.absent(),
    this.freightCharge = const Value.absent(),
    this.fastagCharge = const Value.absent(),
    this.invoiceRefNo = const Value.absent(),
    this.loadingPlace = const Value.absent(),
    this.unloadingPlace = const Value.absent(),
    this.rowAmount = const Value.absent(),
  });
  InvoiceRowsCompanion.insert({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.rowOrder = const Value.absent(),
    this.tripDate = const Value.absent(),
    this.grNumber = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.vehicleNoText = const Value.absent(),
    this.freightCharge = const Value.absent(),
    this.fastagCharge = const Value.absent(),
    this.invoiceRefNo = const Value.absent(),
    this.loadingPlace = const Value.absent(),
    this.unloadingPlace = const Value.absent(),
    this.rowAmount = const Value.absent(),
  });
  static Insertable<InvoiceRow> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? rowOrder,
    Expression<String>? tripDate,
    Expression<String>? grNumber,
    Expression<int>? vehicleId,
    Expression<String>? vehicleNoText,
    Expression<double>? freightCharge,
    Expression<double>? fastagCharge,
    Expression<String>? invoiceRefNo,
    Expression<String>? loadingPlace,
    Expression<String>? unloadingPlace,
    Expression<double>? rowAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (rowOrder != null) 'row_order': rowOrder,
      if (tripDate != null) 'trip_date': tripDate,
      if (grNumber != null) 'gr_number': grNumber,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (vehicleNoText != null) 'vehicle_no_text': vehicleNoText,
      if (freightCharge != null) 'freight_charge': freightCharge,
      if (fastagCharge != null) 'fastag_charge': fastagCharge,
      if (invoiceRefNo != null) 'invoice_ref_no': invoiceRefNo,
      if (loadingPlace != null) 'loading_place': loadingPlace,
      if (unloadingPlace != null) 'unloading_place': unloadingPlace,
      if (rowAmount != null) 'row_amount': rowAmount,
    });
  }

  InvoiceRowsCompanion copyWith({
    Value<int>? id,
    Value<int?>? invoiceId,
    Value<int?>? rowOrder,
    Value<String?>? tripDate,
    Value<String?>? grNumber,
    Value<int?>? vehicleId,
    Value<String?>? vehicleNoText,
    Value<double>? freightCharge,
    Value<double>? fastagCharge,
    Value<String?>? invoiceRefNo,
    Value<String?>? loadingPlace,
    Value<String?>? unloadingPlace,
    Value<double>? rowAmount,
  }) {
    return InvoiceRowsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      rowOrder: rowOrder ?? this.rowOrder,
      tripDate: tripDate ?? this.tripDate,
      grNumber: grNumber ?? this.grNumber,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNoText: vehicleNoText ?? this.vehicleNoText,
      freightCharge: freightCharge ?? this.freightCharge,
      fastagCharge: fastagCharge ?? this.fastagCharge,
      invoiceRefNo: invoiceRefNo ?? this.invoiceRefNo,
      loadingPlace: loadingPlace ?? this.loadingPlace,
      unloadingPlace: unloadingPlace ?? this.unloadingPlace,
      rowAmount: rowAmount ?? this.rowAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (rowOrder.present) {
      map['row_order'] = Variable<int>(rowOrder.value);
    }
    if (tripDate.present) {
      map['trip_date'] = Variable<String>(tripDate.value);
    }
    if (grNumber.present) {
      map['gr_number'] = Variable<String>(grNumber.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (vehicleNoText.present) {
      map['vehicle_no_text'] = Variable<String>(vehicleNoText.value);
    }
    if (freightCharge.present) {
      map['freight_charge'] = Variable<double>(freightCharge.value);
    }
    if (fastagCharge.present) {
      map['fastag_charge'] = Variable<double>(fastagCharge.value);
    }
    if (invoiceRefNo.present) {
      map['invoice_ref_no'] = Variable<String>(invoiceRefNo.value);
    }
    if (loadingPlace.present) {
      map['loading_place'] = Variable<String>(loadingPlace.value);
    }
    if (unloadingPlace.present) {
      map['unloading_place'] = Variable<String>(unloadingPlace.value);
    }
    if (rowAmount.present) {
      map['row_amount'] = Variable<double>(rowAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRowsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('rowOrder: $rowOrder, ')
          ..write('tripDate: $tripDate, ')
          ..write('grNumber: $grNumber, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('vehicleNoText: $vehicleNoText, ')
          ..write('freightCharge: $freightCharge, ')
          ..write('fastagCharge: $fastagCharge, ')
          ..write('invoiceRefNo: $invoiceRefNo, ')
          ..write('loadingPlace: $loadingPlace, ')
          ..write('unloadingPlace: $unloadingPlace, ')
          ..write('rowAmount: $rowAmount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FirmsTable firms = $FirmsTable(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $FreightRateCardsTable freightRateCards = $FreightRateCardsTable(
    this,
  );
  late final $PartnersTable partners = $PartnersTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceRowsTable invoiceRows = $InvoiceRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    firms,
    companies,
    freightRateCards,
    partners,
    vehicles,
    invoices,
    invoiceRows,
  ];
}

typedef $$FirmsTableCreateCompanionBuilder =
    FirmsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> pan,
      Value<String?> gstin,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> logoPath,
      Value<String?> bankName,
      Value<String?> bankAccount,
      Value<String?> bankIfsc,
      Value<String?> beneficiaryName,
      Value<String> invoicePrefix,
      Value<int> currentInvoiceSeq,
      Value<String?> financialYearStart,
      Value<String?> createdAt,
    });
typedef $$FirmsTableUpdateCompanionBuilder =
    FirmsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> pan,
      Value<String?> gstin,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String?> logoPath,
      Value<String?> bankName,
      Value<String?> bankAccount,
      Value<String?> bankIfsc,
      Value<String?> beneficiaryName,
      Value<String> invoicePrefix,
      Value<int> currentInvoiceSeq,
      Value<String?> financialYearStart,
      Value<String?> createdAt,
    });

class $$FirmsTableFilterComposer extends Composer<_$AppDatabase, $FirmsTable> {
  $$FirmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentInvoiceSeq => $composableBuilder(
    column: $table.currentInvoiceSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get financialYearStart => $composableBuilder(
    column: $table.financialYearStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FirmsTableOrderingComposer
    extends Composer<_$AppDatabase, $FirmsTable> {
  $$FirmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentInvoiceSeq => $composableBuilder(
    column: $table.currentInvoiceSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financialYearStart => $composableBuilder(
    column: $table.financialYearStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FirmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FirmsTable> {
  $$FirmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get pan =>
      $composableBuilder(column: $table.pan, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankIfsc =>
      $composableBuilder(column: $table.bankIfsc, builder: (column) => column);

  GeneratedColumn<String> get beneficiaryName => $composableBuilder(
    column: $table.beneficiaryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
    column: $table.invoicePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentInvoiceSeq => $composableBuilder(
    column: $table.currentInvoiceSeq,
    builder: (column) => column,
  );

  GeneratedColumn<String> get financialYearStart => $composableBuilder(
    column: $table.financialYearStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FirmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FirmsTable,
          Firm,
          $$FirmsTableFilterComposer,
          $$FirmsTableOrderingComposer,
          $$FirmsTableAnnotationComposer,
          $$FirmsTableCreateCompanionBuilder,
          $$FirmsTableUpdateCompanionBuilder,
          (Firm, BaseReferences<_$AppDatabase, $FirmsTable, Firm>),
          Firm,
          PrefetchHooks Function()
        > {
  $$FirmsTableTableManager(_$AppDatabase db, $FirmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FirmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FirmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FirmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccount = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<String?> beneficiaryName = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> currentInvoiceSeq = const Value.absent(),
                Value<String?> financialYearStart = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => FirmsCompanion(
                id: id,
                name: name,
                address: address,
                phone: phone,
                email: email,
                pan: pan,
                gstin: gstin,
                state: state,
                stateCode: stateCode,
                logoPath: logoPath,
                bankName: bankName,
                bankAccount: bankAccount,
                bankIfsc: bankIfsc,
                beneficiaryName: beneficiaryName,
                invoicePrefix: invoicePrefix,
                currentInvoiceSeq: currentInvoiceSeq,
                financialYearStart: financialYearStart,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccount = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<String?> beneficiaryName = const Value.absent(),
                Value<String> invoicePrefix = const Value.absent(),
                Value<int> currentInvoiceSeq = const Value.absent(),
                Value<String?> financialYearStart = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => FirmsCompanion.insert(
                id: id,
                name: name,
                address: address,
                phone: phone,
                email: email,
                pan: pan,
                gstin: gstin,
                state: state,
                stateCode: stateCode,
                logoPath: logoPath,
                bankName: bankName,
                bankAccount: bankAccount,
                bankIfsc: bankIfsc,
                beneficiaryName: beneficiaryName,
                invoicePrefix: invoicePrefix,
                currentInvoiceSeq: currentInvoiceSeq,
                financialYearStart: financialYearStart,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FirmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FirmsTable,
      Firm,
      $$FirmsTableFilterComposer,
      $$FirmsTableOrderingComposer,
      $$FirmsTableAnnotationComposer,
      $$FirmsTableCreateCompanionBuilder,
      $$FirmsTableUpdateCompanionBuilder,
      (Firm, BaseReferences<_$AppDatabase, $FirmsTable, Firm>),
      Firm,
      PrefetchHooks Function()
    >;
typedef $$CompaniesTableCreateCompanionBuilder =
    CompaniesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> pan,
      Value<String?> gstin,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String> hsnSac,
      required String invoiceType,
      Value<String?> defaultLoadingPlace,
      Value<String?> contactName,
      Value<String?> contactEmail,
      Value<String?> contactPhone,
      Value<int> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });
typedef $$CompaniesTableUpdateCompanionBuilder =
    CompaniesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> pan,
      Value<String?> gstin,
      Value<String?> state,
      Value<String?> stateCode,
      Value<String> hsnSac,
      Value<String> invoiceType,
      Value<String?> defaultLoadingPlace,
      Value<String?> contactName,
      Value<String?> contactEmail,
      Value<String?> contactPhone,
      Value<int> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FreightRateCardsTable, List<FreightRateCard>>
  _freightRateCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.freightRateCards,
    aliasName: $_aliasNameGenerator(
      db.companies.id,
      db.freightRateCards.companyId,
    ),
  );

  $$FreightRateCardsTableProcessedTableManager get freightRateCardsRefs {
    final manager = $$FreightRateCardsTableTableManager(
      $_db,
      $_db.freightRateCards,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _freightRateCardsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.companies.id, db.invoices.companyId),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnSac => $composableBuilder(
    column: $table.hsnSac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultLoadingPlace => $composableBuilder(
    column: $table.defaultLoadingPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> freightRateCardsRefs(
    Expression<bool> Function($$FreightRateCardsTableFilterComposer f) f,
  ) {
    final $$FreightRateCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.freightRateCards,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FreightRateCardsTableFilterComposer(
            $db: $db,
            $table: $db.freightRateCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateCode => $composableBuilder(
    column: $table.stateCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnSac => $composableBuilder(
    column: $table.hsnSac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultLoadingPlace => $composableBuilder(
    column: $table.defaultLoadingPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get pan =>
      $composableBuilder(column: $table.pan, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get stateCode =>
      $composableBuilder(column: $table.stateCode, builder: (column) => column);

  GeneratedColumn<String> get hsnSac =>
      $composableBuilder(column: $table.hsnSac, builder: (column) => column);

  GeneratedColumn<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultLoadingPlace => $composableBuilder(
    column: $table.defaultLoadingPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> freightRateCardsRefs<T extends Object>(
    Expression<T> Function($$FreightRateCardsTableAnnotationComposer a) f,
  ) {
    final $$FreightRateCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.freightRateCards,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FreightRateCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.freightRateCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompaniesTable,
          Company,
          $$CompaniesTableFilterComposer,
          $$CompaniesTableOrderingComposer,
          $$CompaniesTableAnnotationComposer,
          $$CompaniesTableCreateCompanionBuilder,
          $$CompaniesTableUpdateCompanionBuilder,
          (Company, $$CompaniesTableReferences),
          Company,
          PrefetchHooks Function({bool freightRateCardsRefs, bool invoicesRefs})
        > {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String> hsnSac = const Value.absent(),
                Value<String> invoiceType = const Value.absent(),
                Value<String?> defaultLoadingPlace = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<String?> contactEmail = const Value.absent(),
                Value<String?> contactPhone = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => CompaniesCompanion(
                id: id,
                name: name,
                address: address,
                pan: pan,
                gstin: gstin,
                state: state,
                stateCode: stateCode,
                hsnSac: hsnSac,
                invoiceType: invoiceType,
                defaultLoadingPlace: defaultLoadingPlace,
                contactName: contactName,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> stateCode = const Value.absent(),
                Value<String> hsnSac = const Value.absent(),
                required String invoiceType,
                Value<String?> defaultLoadingPlace = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<String?> contactEmail = const Value.absent(),
                Value<String?> contactPhone = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => CompaniesCompanion.insert(
                id: id,
                name: name,
                address: address,
                pan: pan,
                gstin: gstin,
                state: state,
                stateCode: stateCode,
                hsnSac: hsnSac,
                invoiceType: invoiceType,
                defaultLoadingPlace: defaultLoadingPlace,
                contactName: contactName,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompaniesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({freightRateCardsRefs = false, invoicesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (freightRateCardsRefs) db.freightRateCards,
                    if (invoicesRefs) db.invoices,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (freightRateCardsRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          FreightRateCard
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._freightRateCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).freightRateCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Company,
                          $CompaniesTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.companyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompaniesTable,
      Company,
      $$CompaniesTableFilterComposer,
      $$CompaniesTableOrderingComposer,
      $$CompaniesTableAnnotationComposer,
      $$CompaniesTableCreateCompanionBuilder,
      $$CompaniesTableUpdateCompanionBuilder,
      (Company, $$CompaniesTableReferences),
      Company,
      PrefetchHooks Function({bool freightRateCardsRefs, bool invoicesRefs})
    >;
typedef $$FreightRateCardsTableCreateCompanionBuilder =
    FreightRateCardsCompanion Function({
      Value<int> id,
      required int companyId,
      Value<String?> loadingPlace,
      required String unloadingPlace,
      required double rateAmount,
      Value<String?> effectiveFrom,
      Value<int> isActive,
    });
typedef $$FreightRateCardsTableUpdateCompanionBuilder =
    FreightRateCardsCompanion Function({
      Value<int> id,
      Value<int> companyId,
      Value<String?> loadingPlace,
      Value<String> unloadingPlace,
      Value<double> rateAmount,
      Value<String?> effectiveFrom,
      Value<int> isActive,
    });

final class $$FreightRateCardsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FreightRateCardsTable, FreightRateCard> {
  $$FreightRateCardsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias(
        $_aliasNameGenerator(db.freightRateCards.companyId, db.companies.id),
      );

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<int>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FreightRateCardsTableFilterComposer
    extends Composer<_$AppDatabase, $FreightRateCardsTable> {
  $$FreightRateCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rateAmount => $composableBuilder(
    column: $table.rateAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FreightRateCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FreightRateCardsTable> {
  $$FreightRateCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rateAmount => $composableBuilder(
    column: $table.rateAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FreightRateCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FreightRateCardsTable> {
  $$FreightRateCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rateAmount => $composableBuilder(
    column: $table.rateAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FreightRateCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FreightRateCardsTable,
          FreightRateCard,
          $$FreightRateCardsTableFilterComposer,
          $$FreightRateCardsTableOrderingComposer,
          $$FreightRateCardsTableAnnotationComposer,
          $$FreightRateCardsTableCreateCompanionBuilder,
          $$FreightRateCardsTableUpdateCompanionBuilder,
          (FreightRateCard, $$FreightRateCardsTableReferences),
          FreightRateCard,
          PrefetchHooks Function({bool companyId})
        > {
  $$FreightRateCardsTableTableManager(
    _$AppDatabase db,
    $FreightRateCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FreightRateCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FreightRateCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FreightRateCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> companyId = const Value.absent(),
                Value<String?> loadingPlace = const Value.absent(),
                Value<String> unloadingPlace = const Value.absent(),
                Value<double> rateAmount = const Value.absent(),
                Value<String?> effectiveFrom = const Value.absent(),
                Value<int> isActive = const Value.absent(),
              }) => FreightRateCardsCompanion(
                id: id,
                companyId: companyId,
                loadingPlace: loadingPlace,
                unloadingPlace: unloadingPlace,
                rateAmount: rateAmount,
                effectiveFrom: effectiveFrom,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int companyId,
                Value<String?> loadingPlace = const Value.absent(),
                required String unloadingPlace,
                required double rateAmount,
                Value<String?> effectiveFrom = const Value.absent(),
                Value<int> isActive = const Value.absent(),
              }) => FreightRateCardsCompanion.insert(
                id: id,
                companyId: companyId,
                loadingPlace: loadingPlace,
                unloadingPlace: unloadingPlace,
                rateAmount: rateAmount,
                effectiveFrom: effectiveFrom,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FreightRateCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.companyId,
                                referencedTable:
                                    $$FreightRateCardsTableReferences
                                        ._companyIdTable(db),
                                referencedColumn:
                                    $$FreightRateCardsTableReferences
                                        ._companyIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FreightRateCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FreightRateCardsTable,
      FreightRateCard,
      $$FreightRateCardsTableFilterComposer,
      $$FreightRateCardsTableOrderingComposer,
      $$FreightRateCardsTableAnnotationComposer,
      $$FreightRateCardsTableCreateCompanionBuilder,
      $$FreightRateCardsTableUpdateCompanionBuilder,
      (FreightRateCard, $$FreightRateCardsTableReferences),
      FreightRateCard,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$PartnersTableCreateCompanionBuilder =
    PartnersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> pan,
      Value<String?> bankName,
      Value<String?> bankAccount,
      Value<String?> bankIfsc,
      Value<double?> sharePercent,
      Value<int> isActive,
    });
typedef $$PartnersTableUpdateCompanionBuilder =
    PartnersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> pan,
      Value<String?> bankName,
      Value<String?> bankAccount,
      Value<String?> bankIfsc,
      Value<double?> sharePercent,
      Value<int> isActive,
    });

final class $$PartnersTableReferences
    extends BaseReferences<_$AppDatabase, $PartnersTable, Partner> {
  $$PartnersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<Vehicle>> _vehiclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: $_aliasNameGenerator(db.partners.id, db.vehicles.partnerId),
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.partnerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartnersTableFilterComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.partnerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartnersTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pan => $composableBuilder(
    column: $table.pan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnersTable> {
  $$PartnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get pan =>
      $composableBuilder(column: $table.pan, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccount => $composableBuilder(
    column: $table.bankAccount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankIfsc =>
      $composableBuilder(column: $table.bankIfsc, builder: (column) => column);

  GeneratedColumn<double> get sharePercent => $composableBuilder(
    column: $table.sharePercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.partnerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnersTable,
          Partner,
          $$PartnersTableFilterComposer,
          $$PartnersTableOrderingComposer,
          $$PartnersTableAnnotationComposer,
          $$PartnersTableCreateCompanionBuilder,
          $$PartnersTableUpdateCompanionBuilder,
          (Partner, $$PartnersTableReferences),
          Partner,
          PrefetchHooks Function({bool vehiclesRefs})
        > {
  $$PartnersTableTableManager(_$AppDatabase db, $PartnersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccount = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<double?> sharePercent = const Value.absent(),
                Value<int> isActive = const Value.absent(),
              }) => PartnersCompanion(
                id: id,
                name: name,
                phone: phone,
                pan: pan,
                bankName: bankName,
                bankAccount: bankAccount,
                bankIfsc: bankIfsc,
                sharePercent: sharePercent,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> pan = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<String?> bankAccount = const Value.absent(),
                Value<String?> bankIfsc = const Value.absent(),
                Value<double?> sharePercent = const Value.absent(),
                Value<int> isActive = const Value.absent(),
              }) => PartnersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                pan: pan,
                bankName: bankName,
                bankAccount: bankAccount,
                bankIfsc: bankIfsc,
                sharePercent: sharePercent,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartnersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehiclesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiclesRefs) db.vehicles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiclesRefs)
                    await $_getPrefetchedData<Partner, $PartnersTable, Vehicle>(
                      currentTable: table,
                      referencedTable: $$PartnersTableReferences
                          ._vehiclesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PartnersTableReferences(db, table, p0).vehiclesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.partnerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PartnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnersTable,
      Partner,
      $$PartnersTableFilterComposer,
      $$PartnersTableOrderingComposer,
      $$PartnersTableAnnotationComposer,
      $$PartnersTableCreateCompanionBuilder,
      $$PartnersTableUpdateCompanionBuilder,
      (Partner, $$PartnersTableReferences),
      Partner,
      PrefetchHooks Function({bool vehiclesRefs})
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      required String vehicleNo,
      Value<int?> partnerId,
      Value<String?> vehicleType,
      Value<String?> fitnessExpiry,
      Value<String?> insuranceExpiry,
      Value<int> isActive,
      Value<String?> notes,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      Value<String> vehicleNo,
      Value<int?> partnerId,
      Value<String?> vehicleType,
      Value<String?> fitnessExpiry,
      Value<String?> insuranceExpiry,
      Value<int> isActive,
      Value<String?> notes,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartnersTable _partnerIdTable(_$AppDatabase db) => db.partners
      .createAlias($_aliasNameGenerator(db.vehicles.partnerId, db.partners.id));

  $$PartnersTableProcessedTableManager? get partnerId {
    final $_column = $_itemColumn<int>('partner_id');
    if ($_column == null) return null;
    final manager = $$PartnersTableTableManager(
      $_db,
      $_db.partners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partnerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceRowsTable, List<InvoiceRow>>
  _invoiceRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceRows,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.invoiceRows.vehicleId),
  );

  $$InvoiceRowsTableProcessedTableManager get invoiceRowsRefs {
    final manager = $$InvoiceRowsTableTableManager(
      $_db,
      $_db.invoiceRows,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNo => $composableBuilder(
    column: $table.vehicleNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fitnessExpiry => $composableBuilder(
    column: $table.fitnessExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PartnersTableFilterComposer get partnerId {
    final $$PartnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableFilterComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceRowsRefs(
    Expression<bool> Function($$InvoiceRowsTableFilterComposer f) f,
  ) {
    final $$InvoiceRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceRows,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceRowsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNo => $composableBuilder(
    column: $table.vehicleNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitnessExpiry => $composableBuilder(
    column: $table.fitnessExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartnersTableOrderingComposer get partnerId {
    final $$PartnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableOrderingComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleNo =>
      $composableBuilder(column: $table.vehicleNo, builder: (column) => column);

  GeneratedColumn<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fitnessExpiry => $composableBuilder(
    column: $table.fitnessExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insuranceExpiry => $composableBuilder(
    column: $table.insuranceExpiry,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PartnersTableAnnotationComposer get partnerId {
    final $$PartnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partnerId,
      referencedTable: $db.partners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnersTableAnnotationComposer(
            $db: $db,
            $table: $db.partners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceRowsRefs<T extends Object>(
    Expression<T> Function($$InvoiceRowsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceRows,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({bool partnerId, bool invoiceRowsRefs})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> vehicleNo = const Value.absent(),
                Value<int?> partnerId = const Value.absent(),
                Value<String?> vehicleType = const Value.absent(),
                Value<String?> fitnessExpiry = const Value.absent(),
                Value<String?> insuranceExpiry = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                vehicleNo: vehicleNo,
                partnerId: partnerId,
                vehicleType: vehicleType,
                fitnessExpiry: fitnessExpiry,
                insuranceExpiry: insuranceExpiry,
                isActive: isActive,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String vehicleNo,
                Value<int?> partnerId = const Value.absent(),
                Value<String?> vehicleType = const Value.absent(),
                Value<String?> fitnessExpiry = const Value.absent(),
                Value<String?> insuranceExpiry = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                vehicleNo: vehicleNo,
                partnerId: partnerId,
                vehicleType: vehicleType,
                fitnessExpiry: fitnessExpiry,
                insuranceExpiry: insuranceExpiry,
                isActive: isActive,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({partnerId = false, invoiceRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceRowsRefs) db.invoiceRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (partnerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.partnerId,
                                    referencedTable: $$VehiclesTableReferences
                                        ._partnerIdTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._partnerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceRowsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          InvoiceRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._invoiceRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({bool partnerId, bool invoiceRowsRefs})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required String invoiceNumber,
      required String invoiceDate,
      Value<int?> companyId,
      Value<String?> invoiceType,
      Value<double> totalFreight,
      Value<double> totalFastag,
      Value<double> totalAmount,
      Value<double> sgstRate,
      Value<double> cgstRate,
      Value<double> igstRate,
      Value<double> sgstAmount,
      Value<double> cgstAmount,
      Value<double> igstAmount,
      Value<double> gstRcmTotal,
      Value<double> tdsRate,
      Value<double> tdsAmount,
      Value<double> payableAmount,
      Value<String?> amountInWords,
      Value<String> status,
      Value<String?> submissionDate,
      Value<double> paymentReceived,
      Value<String?> paymentDate,
      Value<String?> pdfPath,
      Value<int> cloudSynced,
      Value<int?> templateId,
      Value<String?> notes,
      Value<String?> financialYear,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<String> invoiceNumber,
      Value<String> invoiceDate,
      Value<int?> companyId,
      Value<String?> invoiceType,
      Value<double> totalFreight,
      Value<double> totalFastag,
      Value<double> totalAmount,
      Value<double> sgstRate,
      Value<double> cgstRate,
      Value<double> igstRate,
      Value<double> sgstAmount,
      Value<double> cgstAmount,
      Value<double> igstAmount,
      Value<double> gstRcmTotal,
      Value<double> tdsRate,
      Value<double> tdsAmount,
      Value<double> payableAmount,
      Value<String?> amountInWords,
      Value<String> status,
      Value<String?> submissionDate,
      Value<double> paymentReceived,
      Value<String?> paymentDate,
      Value<String?> pdfPath,
      Value<int> cloudSynced,
      Value<int?> templateId,
      Value<String?> notes,
      Value<String?> financialYear,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias(
        $_aliasNameGenerator(db.invoices.companyId, db.companies.id),
      );

  $$CompaniesTableProcessedTableManager? get companyId {
    final $_column = $_itemColumn<int>('company_id');
    if ($_column == null) return null;
    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceRowsTable, List<InvoiceRow>>
  _invoiceRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceRows,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.invoiceRows.invoiceId),
  );

  $$InvoiceRowsTableProcessedTableManager get invoiceRowsRefs {
    final manager = $$InvoiceRowsTableTableManager(
      $_db,
      $_db.invoiceRows,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFreight => $composableBuilder(
    column: $table.totalFreight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFastag => $composableBuilder(
    column: $table.totalFastag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstRate => $composableBuilder(
    column: $table.sgstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstRate => $composableBuilder(
    column: $table.cgstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get igstRate => $composableBuilder(
    column: $table.igstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRcmTotal => $composableBuilder(
    column: $table.gstRcmTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tdsRate => $composableBuilder(
    column: $table.tdsRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tdsAmount => $composableBuilder(
    column: $table.tdsAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payableAmount => $composableBuilder(
    column: $table.payableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cloudSynced => $composableBuilder(
    column: $table.cloudSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get financialYear => $composableBuilder(
    column: $table.financialYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceRowsRefs(
    Expression<bool> Function($$InvoiceRowsTableFilterComposer f) f,
  ) {
    final $$InvoiceRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceRows,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceRowsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFreight => $composableBuilder(
    column: $table.totalFreight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFastag => $composableBuilder(
    column: $table.totalFastag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstRate => $composableBuilder(
    column: $table.sgstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstRate => $composableBuilder(
    column: $table.cgstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get igstRate => $composableBuilder(
    column: $table.igstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRcmTotal => $composableBuilder(
    column: $table.gstRcmTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tdsRate => $composableBuilder(
    column: $table.tdsRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tdsAmount => $composableBuilder(
    column: $table.tdsAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payableAmount => $composableBuilder(
    column: $table.payableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cloudSynced => $composableBuilder(
    column: $table.cloudSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financialYear => $composableBuilder(
    column: $table.financialYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFreight => $composableBuilder(
    column: $table.totalFreight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFastag => $composableBuilder(
    column: $table.totalFastag,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sgstRate =>
      $composableBuilder(column: $table.sgstRate, builder: (column) => column);

  GeneratedColumn<double> get cgstRate =>
      $composableBuilder(column: $table.cgstRate, builder: (column) => column);

  GeneratedColumn<double> get igstRate =>
      $composableBuilder(column: $table.igstRate, builder: (column) => column);

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gstRcmTotal => $composableBuilder(
    column: $table.gstRcmTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tdsRate =>
      $composableBuilder(column: $table.tdsRate, builder: (column) => column);

  GeneratedColumn<double> get tdsAmount =>
      $composableBuilder(column: $table.tdsAmount, builder: (column) => column);

  GeneratedColumn<double> get payableAmount => $composableBuilder(
    column: $table.payableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get submissionDate => $composableBuilder(
    column: $table.submissionDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentReceived => $composableBuilder(
    column: $table.paymentReceived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfPath =>
      $composableBuilder(column: $table.pdfPath, builder: (column) => column);

  GeneratedColumn<int> get cloudSynced => $composableBuilder(
    column: $table.cloudSynced,
    builder: (column) => column,
  );

  GeneratedColumn<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get financialYear => $composableBuilder(
    column: $table.financialYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceRowsRefs<T extends Object>(
    Expression<T> Function($$InvoiceRowsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceRows,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({bool companyId, bool invoiceRowsRefs})
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<String> invoiceDate = const Value.absent(),
                Value<int?> companyId = const Value.absent(),
                Value<String?> invoiceType = const Value.absent(),
                Value<double> totalFreight = const Value.absent(),
                Value<double> totalFastag = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> sgstRate = const Value.absent(),
                Value<double> cgstRate = const Value.absent(),
                Value<double> igstRate = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> igstAmount = const Value.absent(),
                Value<double> gstRcmTotal = const Value.absent(),
                Value<double> tdsRate = const Value.absent(),
                Value<double> tdsAmount = const Value.absent(),
                Value<double> payableAmount = const Value.absent(),
                Value<String?> amountInWords = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> submissionDate = const Value.absent(),
                Value<double> paymentReceived = const Value.absent(),
                Value<String?> paymentDate = const Value.absent(),
                Value<String?> pdfPath = const Value.absent(),
                Value<int> cloudSynced = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> financialYear = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                companyId: companyId,
                invoiceType: invoiceType,
                totalFreight: totalFreight,
                totalFastag: totalFastag,
                totalAmount: totalAmount,
                sgstRate: sgstRate,
                cgstRate: cgstRate,
                igstRate: igstRate,
                sgstAmount: sgstAmount,
                cgstAmount: cgstAmount,
                igstAmount: igstAmount,
                gstRcmTotal: gstRcmTotal,
                tdsRate: tdsRate,
                tdsAmount: tdsAmount,
                payableAmount: payableAmount,
                amountInWords: amountInWords,
                status: status,
                submissionDate: submissionDate,
                paymentReceived: paymentReceived,
                paymentDate: paymentDate,
                pdfPath: pdfPath,
                cloudSynced: cloudSynced,
                templateId: templateId,
                notes: notes,
                financialYear: financialYear,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNumber,
                required String invoiceDate,
                Value<int?> companyId = const Value.absent(),
                Value<String?> invoiceType = const Value.absent(),
                Value<double> totalFreight = const Value.absent(),
                Value<double> totalFastag = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> sgstRate = const Value.absent(),
                Value<double> cgstRate = const Value.absent(),
                Value<double> igstRate = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> igstAmount = const Value.absent(),
                Value<double> gstRcmTotal = const Value.absent(),
                Value<double> tdsRate = const Value.absent(),
                Value<double> tdsAmount = const Value.absent(),
                Value<double> payableAmount = const Value.absent(),
                Value<String?> amountInWords = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> submissionDate = const Value.absent(),
                Value<double> paymentReceived = const Value.absent(),
                Value<String?> paymentDate = const Value.absent(),
                Value<String?> pdfPath = const Value.absent(),
                Value<int> cloudSynced = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> financialYear = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                invoiceDate: invoiceDate,
                companyId: companyId,
                invoiceType: invoiceType,
                totalFreight: totalFreight,
                totalFastag: totalFastag,
                totalAmount: totalAmount,
                sgstRate: sgstRate,
                cgstRate: cgstRate,
                igstRate: igstRate,
                sgstAmount: sgstAmount,
                cgstAmount: cgstAmount,
                igstAmount: igstAmount,
                gstRcmTotal: gstRcmTotal,
                tdsRate: tdsRate,
                tdsAmount: tdsAmount,
                payableAmount: payableAmount,
                amountInWords: amountInWords,
                status: status,
                submissionDate: submissionDate,
                paymentReceived: paymentReceived,
                paymentDate: paymentDate,
                pdfPath: pdfPath,
                cloudSynced: cloudSynced,
                templateId: templateId,
                notes: notes,
                financialYear: financialYear,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({companyId = false, invoiceRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceRowsRefs) db.invoiceRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (companyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.companyId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._companyIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._companyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceRowsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceRow
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({bool companyId, bool invoiceRowsRefs})
    >;
typedef $$InvoiceRowsTableCreateCompanionBuilder =
    InvoiceRowsCompanion Function({
      Value<int> id,
      Value<int?> invoiceId,
      Value<int?> rowOrder,
      Value<String?> tripDate,
      Value<String?> grNumber,
      Value<int?> vehicleId,
      Value<String?> vehicleNoText,
      Value<double> freightCharge,
      Value<double> fastagCharge,
      Value<String?> invoiceRefNo,
      Value<String?> loadingPlace,
      Value<String?> unloadingPlace,
      Value<double> rowAmount,
    });
typedef $$InvoiceRowsTableUpdateCompanionBuilder =
    InvoiceRowsCompanion Function({
      Value<int> id,
      Value<int?> invoiceId,
      Value<int?> rowOrder,
      Value<String?> tripDate,
      Value<String?> grNumber,
      Value<int?> vehicleId,
      Value<String?> vehicleNoText,
      Value<double> freightCharge,
      Value<double> fastagCharge,
      Value<String?> invoiceRefNo,
      Value<String?> loadingPlace,
      Value<String?> unloadingPlace,
      Value<double> rowAmount,
    });

final class $$InvoiceRowsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceRowsTable, InvoiceRow> {
  $$InvoiceRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoiceRows.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.invoiceRows.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager? get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id');
    if ($_column == null) return null;
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceRowsTable> {
  $$InvoiceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rowOrder => $composableBuilder(
    column: $table.rowOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripDate => $composableBuilder(
    column: $table.tripDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grNumber => $composableBuilder(
    column: $table.grNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNoText => $composableBuilder(
    column: $table.vehicleNoText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get freightCharge => $composableBuilder(
    column: $table.freightCharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fastagCharge => $composableBuilder(
    column: $table.fastagCharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceRefNo => $composableBuilder(
    column: $table.invoiceRefNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rowAmount => $composableBuilder(
    column: $table.rowAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceRowsTable> {
  $$InvoiceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rowOrder => $composableBuilder(
    column: $table.rowOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripDate => $composableBuilder(
    column: $table.tripDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grNumber => $composableBuilder(
    column: $table.grNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNoText => $composableBuilder(
    column: $table.vehicleNoText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get freightCharge => $composableBuilder(
    column: $table.freightCharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fastagCharge => $composableBuilder(
    column: $table.fastagCharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceRefNo => $composableBuilder(
    column: $table.invoiceRefNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rowAmount => $composableBuilder(
    column: $table.rowAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceRowsTable> {
  $$InvoiceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rowOrder =>
      $composableBuilder(column: $table.rowOrder, builder: (column) => column);

  GeneratedColumn<String> get tripDate =>
      $composableBuilder(column: $table.tripDate, builder: (column) => column);

  GeneratedColumn<String> get grNumber =>
      $composableBuilder(column: $table.grNumber, builder: (column) => column);

  GeneratedColumn<String> get vehicleNoText => $composableBuilder(
    column: $table.vehicleNoText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get freightCharge => $composableBuilder(
    column: $table.freightCharge,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fastagCharge => $composableBuilder(
    column: $table.fastagCharge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceRefNo => $composableBuilder(
    column: $table.invoiceRefNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loadingPlace => $composableBuilder(
    column: $table.loadingPlace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unloadingPlace => $composableBuilder(
    column: $table.unloadingPlace,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rowAmount =>
      $composableBuilder(column: $table.rowAmount, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceRowsTable,
          InvoiceRow,
          $$InvoiceRowsTableFilterComposer,
          $$InvoiceRowsTableOrderingComposer,
          $$InvoiceRowsTableAnnotationComposer,
          $$InvoiceRowsTableCreateCompanionBuilder,
          $$InvoiceRowsTableUpdateCompanionBuilder,
          (InvoiceRow, $$InvoiceRowsTableReferences),
          InvoiceRow,
          PrefetchHooks Function({bool invoiceId, bool vehicleId})
        > {
  $$InvoiceRowsTableTableManager(_$AppDatabase db, $InvoiceRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
                Value<int?> rowOrder = const Value.absent(),
                Value<String?> tripDate = const Value.absent(),
                Value<String?> grNumber = const Value.absent(),
                Value<int?> vehicleId = const Value.absent(),
                Value<String?> vehicleNoText = const Value.absent(),
                Value<double> freightCharge = const Value.absent(),
                Value<double> fastagCharge = const Value.absent(),
                Value<String?> invoiceRefNo = const Value.absent(),
                Value<String?> loadingPlace = const Value.absent(),
                Value<String?> unloadingPlace = const Value.absent(),
                Value<double> rowAmount = const Value.absent(),
              }) => InvoiceRowsCompanion(
                id: id,
                invoiceId: invoiceId,
                rowOrder: rowOrder,
                tripDate: tripDate,
                grNumber: grNumber,
                vehicleId: vehicleId,
                vehicleNoText: vehicleNoText,
                freightCharge: freightCharge,
                fastagCharge: fastagCharge,
                invoiceRefNo: invoiceRefNo,
                loadingPlace: loadingPlace,
                unloadingPlace: unloadingPlace,
                rowAmount: rowAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> invoiceId = const Value.absent(),
                Value<int?> rowOrder = const Value.absent(),
                Value<String?> tripDate = const Value.absent(),
                Value<String?> grNumber = const Value.absent(),
                Value<int?> vehicleId = const Value.absent(),
                Value<String?> vehicleNoText = const Value.absent(),
                Value<double> freightCharge = const Value.absent(),
                Value<double> fastagCharge = const Value.absent(),
                Value<String?> invoiceRefNo = const Value.absent(),
                Value<String?> loadingPlace = const Value.absent(),
                Value<String?> unloadingPlace = const Value.absent(),
                Value<double> rowAmount = const Value.absent(),
              }) => InvoiceRowsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                rowOrder: rowOrder,
                tripDate: tripDate,
                grNumber: grNumber,
                vehicleId: vehicleId,
                vehicleNoText: vehicleNoText,
                freightCharge: freightCharge,
                fastagCharge: fastagCharge,
                invoiceRefNo: invoiceRefNo,
                loadingPlace: loadingPlace,
                unloadingPlace: unloadingPlace,
                rowAmount: rowAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceRowsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$InvoiceRowsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$InvoiceRowsTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$InvoiceRowsTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceRowsTable,
      InvoiceRow,
      $$InvoiceRowsTableFilterComposer,
      $$InvoiceRowsTableOrderingComposer,
      $$InvoiceRowsTableAnnotationComposer,
      $$InvoiceRowsTableCreateCompanionBuilder,
      $$InvoiceRowsTableUpdateCompanionBuilder,
      (InvoiceRow, $$InvoiceRowsTableReferences),
      InvoiceRow,
      PrefetchHooks Function({bool invoiceId, bool vehicleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FirmsTableTableManager get firms =>
      $$FirmsTableTableManager(_db, _db.firms);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$FreightRateCardsTableTableManager get freightRateCards =>
      $$FreightRateCardsTableTableManager(_db, _db.freightRateCards);
  $$PartnersTableTableManager get partners =>
      $$PartnersTableTableManager(_db, _db.partners);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceRowsTableTableManager get invoiceRows =>
      $$InvoiceRowsTableTableManager(_db, _db.invoiceRows);
}

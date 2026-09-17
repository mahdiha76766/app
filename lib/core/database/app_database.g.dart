// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkshopsTable extends Workshops
    with TableInfo<$WorkshopsTable, WorkshopRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkshopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _mechanicNameMeta = const VerificationMeta(
    'mechanicName',
  );
  @override
  late final GeneratedColumn<String> mechanicName = GeneratedColumn<String>(
    'mechanic_name',
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
  static const VerificationMeta _morningHourMeta = const VerificationMeta(
    'morningHour',
  );
  @override
  late final GeneratedColumn<int> morningHour = GeneratedColumn<int>(
    'morning_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _afternoonHourMeta = const VerificationMeta(
    'afternoonHour',
  );
  @override
  late final GeneratedColumn<int> afternoonHour = GeneratedColumn<int>(
    'afternoon_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(17),
  );
  static const VerificationMeta _nightHourMeta = const VerificationMeta(
    'nightHour',
  );
  @override
  late final GeneratedColumn<int> nightHour = GeneratedColumn<int>(
    'night_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _enableWhatsAppMeta = const VerificationMeta(
    'enableWhatsApp',
  );
  @override
  late final GeneratedColumn<bool> enableWhatsApp = GeneratedColumn<bool>(
    'enable_whats_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_whats_app" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _enableTelegramMeta = const VerificationMeta(
    'enableTelegram',
  );
  @override
  late final GeneratedColumn<bool> enableTelegram = GeneratedColumn<bool>(
    'enable_telegram',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_telegram" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _enableSmsMeta = const VerificationMeta(
    'enableSms',
  );
  @override
  late final GeneratedColumn<bool> enableSms = GeneratedColumn<bool>(
    'enable_sms',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_sms" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _includeBankInfoInMessagesMeta =
      const VerificationMeta('includeBankInfoInMessages');
  @override
  late final GeneratedColumn<bool> includeBankInfoInMessages =
      GeneratedColumn<bool>(
        'include_bank_info_in_messages',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("include_bank_info_in_messages" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _nextInvoiceNumberMeta = const VerificationMeta(
    'nextInvoiceNumber',
  );
  @override
  late final GeneratedColumn<int> nextInvoiceNumber = GeneratedColumn<int>(
    'next_invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _invoiceSeqYearMeta = const VerificationMeta(
    'invoiceSeqYear',
  );
  @override
  late final GeneratedColumn<int> invoiceSeqYear = GeneratedColumn<int>(
    'invoice_seq_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    mechanicName,
    phone,
    address,
    morningHour,
    afternoonHour,
    nightHour,
    enableWhatsApp,
    enableTelegram,
    enableSms,
    includeBankInfoInMessages,
    nextInvoiceNumber,
    invoiceSeqYear,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workshops';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkshopRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mechanic_name')) {
      context.handle(
        _mechanicNameMeta,
        mechanicName.isAcceptableOrUnknown(
          data['mechanic_name']!,
          _mechanicNameMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('morning_hour')) {
      context.handle(
        _morningHourMeta,
        morningHour.isAcceptableOrUnknown(
          data['morning_hour']!,
          _morningHourMeta,
        ),
      );
    }
    if (data.containsKey('afternoon_hour')) {
      context.handle(
        _afternoonHourMeta,
        afternoonHour.isAcceptableOrUnknown(
          data['afternoon_hour']!,
          _afternoonHourMeta,
        ),
      );
    }
    if (data.containsKey('night_hour')) {
      context.handle(
        _nightHourMeta,
        nightHour.isAcceptableOrUnknown(data['night_hour']!, _nightHourMeta),
      );
    }
    if (data.containsKey('enable_whats_app')) {
      context.handle(
        _enableWhatsAppMeta,
        enableWhatsApp.isAcceptableOrUnknown(
          data['enable_whats_app']!,
          _enableWhatsAppMeta,
        ),
      );
    }
    if (data.containsKey('enable_telegram')) {
      context.handle(
        _enableTelegramMeta,
        enableTelegram.isAcceptableOrUnknown(
          data['enable_telegram']!,
          _enableTelegramMeta,
        ),
      );
    }
    if (data.containsKey('enable_sms')) {
      context.handle(
        _enableSmsMeta,
        enableSms.isAcceptableOrUnknown(data['enable_sms']!, _enableSmsMeta),
      );
    }
    if (data.containsKey('include_bank_info_in_messages')) {
      context.handle(
        _includeBankInfoInMessagesMeta,
        includeBankInfoInMessages.isAcceptableOrUnknown(
          data['include_bank_info_in_messages']!,
          _includeBankInfoInMessagesMeta,
        ),
      );
    }
    if (data.containsKey('next_invoice_number')) {
      context.handle(
        _nextInvoiceNumberMeta,
        nextInvoiceNumber.isAcceptableOrUnknown(
          data['next_invoice_number']!,
          _nextInvoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('invoice_seq_year')) {
      context.handle(
        _invoiceSeqYearMeta,
        invoiceSeqYear.isAcceptableOrUnknown(
          data['invoice_seq_year']!,
          _invoiceSeqYearMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkshopRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkshopRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mechanicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mechanic_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      morningHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_hour'],
      )!,
      afternoonHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}afternoon_hour'],
      )!,
      nightHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_hour'],
      )!,
      enableWhatsApp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_whats_app'],
      )!,
      enableTelegram: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_telegram'],
      )!,
      enableSms: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_sms'],
      )!,
      includeBankInfoInMessages: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_bank_info_in_messages'],
      )!,
      nextInvoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_invoice_number'],
      )!,
      invoiceSeqYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_seq_year'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkshopsTable createAlias(String alias) {
    return $WorkshopsTable(attachedDatabase, alias);
  }
}

class WorkshopRow extends DataClass implements Insertable<WorkshopRow> {
  final String id;
  final String name;
  final String? mechanicName;
  final String? phone;
  final String? address;
  final int morningHour;
  final int afternoonHour;
  final int nightHour;
  final bool enableWhatsApp;
  final bool enableTelegram;
  final bool enableSms;
  final bool includeBankInfoInMessages;
  final int nextInvoiceNumber;

  /// سال شمسی جاری برای شمارندهٔ ترتیبی فاکتور.
  final int? invoiceSeqYear;
  final DateTime createdAt;
  const WorkshopRow({
    required this.id,
    required this.name,
    this.mechanicName,
    this.phone,
    this.address,
    required this.morningHour,
    required this.afternoonHour,
    required this.nightHour,
    required this.enableWhatsApp,
    required this.enableTelegram,
    required this.enableSms,
    required this.includeBankInfoInMessages,
    required this.nextInvoiceNumber,
    this.invoiceSeqYear,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mechanicName != null) {
      map['mechanic_name'] = Variable<String>(mechanicName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['morning_hour'] = Variable<int>(morningHour);
    map['afternoon_hour'] = Variable<int>(afternoonHour);
    map['night_hour'] = Variable<int>(nightHour);
    map['enable_whats_app'] = Variable<bool>(enableWhatsApp);
    map['enable_telegram'] = Variable<bool>(enableTelegram);
    map['enable_sms'] = Variable<bool>(enableSms);
    map['include_bank_info_in_messages'] = Variable<bool>(
      includeBankInfoInMessages,
    );
    map['next_invoice_number'] = Variable<int>(nextInvoiceNumber);
    if (!nullToAbsent || invoiceSeqYear != null) {
      map['invoice_seq_year'] = Variable<int>(invoiceSeqYear);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkshopsCompanion toCompanion(bool nullToAbsent) {
    return WorkshopsCompanion(
      id: Value(id),
      name: Value(name),
      mechanicName: mechanicName == null && nullToAbsent
          ? const Value.absent()
          : Value(mechanicName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      morningHour: Value(morningHour),
      afternoonHour: Value(afternoonHour),
      nightHour: Value(nightHour),
      enableWhatsApp: Value(enableWhatsApp),
      enableTelegram: Value(enableTelegram),
      enableSms: Value(enableSms),
      includeBankInfoInMessages: Value(includeBankInfoInMessages),
      nextInvoiceNumber: Value(nextInvoiceNumber),
      invoiceSeqYear: invoiceSeqYear == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceSeqYear),
      createdAt: Value(createdAt),
    );
  }

  factory WorkshopRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkshopRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mechanicName: serializer.fromJson<String?>(json['mechanicName']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      morningHour: serializer.fromJson<int>(json['morningHour']),
      afternoonHour: serializer.fromJson<int>(json['afternoonHour']),
      nightHour: serializer.fromJson<int>(json['nightHour']),
      enableWhatsApp: serializer.fromJson<bool>(json['enableWhatsApp']),
      enableTelegram: serializer.fromJson<bool>(json['enableTelegram']),
      enableSms: serializer.fromJson<bool>(json['enableSms']),
      includeBankInfoInMessages: serializer.fromJson<bool>(
        json['includeBankInfoInMessages'],
      ),
      nextInvoiceNumber: serializer.fromJson<int>(json['nextInvoiceNumber']),
      invoiceSeqYear: serializer.fromJson<int?>(json['invoiceSeqYear']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mechanicName': serializer.toJson<String?>(mechanicName),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'morningHour': serializer.toJson<int>(morningHour),
      'afternoonHour': serializer.toJson<int>(afternoonHour),
      'nightHour': serializer.toJson<int>(nightHour),
      'enableWhatsApp': serializer.toJson<bool>(enableWhatsApp),
      'enableTelegram': serializer.toJson<bool>(enableTelegram),
      'enableSms': serializer.toJson<bool>(enableSms),
      'includeBankInfoInMessages': serializer.toJson<bool>(
        includeBankInfoInMessages,
      ),
      'nextInvoiceNumber': serializer.toJson<int>(nextInvoiceNumber),
      'invoiceSeqYear': serializer.toJson<int?>(invoiceSeqYear),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkshopRow copyWith({
    String? id,
    String? name,
    Value<String?> mechanicName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    int? morningHour,
    int? afternoonHour,
    int? nightHour,
    bool? enableWhatsApp,
    bool? enableTelegram,
    bool? enableSms,
    bool? includeBankInfoInMessages,
    int? nextInvoiceNumber,
    Value<int?> invoiceSeqYear = const Value.absent(),
    DateTime? createdAt,
  }) => WorkshopRow(
    id: id ?? this.id,
    name: name ?? this.name,
    mechanicName: mechanicName.present ? mechanicName.value : this.mechanicName,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    morningHour: morningHour ?? this.morningHour,
    afternoonHour: afternoonHour ?? this.afternoonHour,
    nightHour: nightHour ?? this.nightHour,
    enableWhatsApp: enableWhatsApp ?? this.enableWhatsApp,
    enableTelegram: enableTelegram ?? this.enableTelegram,
    enableSms: enableSms ?? this.enableSms,
    includeBankInfoInMessages:
        includeBankInfoInMessages ?? this.includeBankInfoInMessages,
    nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
    invoiceSeqYear: invoiceSeqYear.present
        ? invoiceSeqYear.value
        : this.invoiceSeqYear,
    createdAt: createdAt ?? this.createdAt,
  );
  WorkshopRow copyWithCompanion(WorkshopsCompanion data) {
    return WorkshopRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mechanicName: data.mechanicName.present
          ? data.mechanicName.value
          : this.mechanicName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      morningHour: data.morningHour.present
          ? data.morningHour.value
          : this.morningHour,
      afternoonHour: data.afternoonHour.present
          ? data.afternoonHour.value
          : this.afternoonHour,
      nightHour: data.nightHour.present ? data.nightHour.value : this.nightHour,
      enableWhatsApp: data.enableWhatsApp.present
          ? data.enableWhatsApp.value
          : this.enableWhatsApp,
      enableTelegram: data.enableTelegram.present
          ? data.enableTelegram.value
          : this.enableTelegram,
      enableSms: data.enableSms.present ? data.enableSms.value : this.enableSms,
      includeBankInfoInMessages: data.includeBankInfoInMessages.present
          ? data.includeBankInfoInMessages.value
          : this.includeBankInfoInMessages,
      nextInvoiceNumber: data.nextInvoiceNumber.present
          ? data.nextInvoiceNumber.value
          : this.nextInvoiceNumber,
      invoiceSeqYear: data.invoiceSeqYear.present
          ? data.invoiceSeqYear.value
          : this.invoiceSeqYear,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkshopRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mechanicName: $mechanicName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('morningHour: $morningHour, ')
          ..write('afternoonHour: $afternoonHour, ')
          ..write('nightHour: $nightHour, ')
          ..write('enableWhatsApp: $enableWhatsApp, ')
          ..write('enableTelegram: $enableTelegram, ')
          ..write('enableSms: $enableSms, ')
          ..write('includeBankInfoInMessages: $includeBankInfoInMessages, ')
          ..write('nextInvoiceNumber: $nextInvoiceNumber, ')
          ..write('invoiceSeqYear: $invoiceSeqYear, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    mechanicName,
    phone,
    address,
    morningHour,
    afternoonHour,
    nightHour,
    enableWhatsApp,
    enableTelegram,
    enableSms,
    includeBankInfoInMessages,
    nextInvoiceNumber,
    invoiceSeqYear,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkshopRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.mechanicName == this.mechanicName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.morningHour == this.morningHour &&
          other.afternoonHour == this.afternoonHour &&
          other.nightHour == this.nightHour &&
          other.enableWhatsApp == this.enableWhatsApp &&
          other.enableTelegram == this.enableTelegram &&
          other.enableSms == this.enableSms &&
          other.includeBankInfoInMessages == this.includeBankInfoInMessages &&
          other.nextInvoiceNumber == this.nextInvoiceNumber &&
          other.invoiceSeqYear == this.invoiceSeqYear &&
          other.createdAt == this.createdAt);
}

class WorkshopsCompanion extends UpdateCompanion<WorkshopRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> mechanicName;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int> morningHour;
  final Value<int> afternoonHour;
  final Value<int> nightHour;
  final Value<bool> enableWhatsApp;
  final Value<bool> enableTelegram;
  final Value<bool> enableSms;
  final Value<bool> includeBankInfoInMessages;
  final Value<int> nextInvoiceNumber;
  final Value<int?> invoiceSeqYear;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkshopsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mechanicName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.afternoonHour = const Value.absent(),
    this.nightHour = const Value.absent(),
    this.enableWhatsApp = const Value.absent(),
    this.enableTelegram = const Value.absent(),
    this.enableSms = const Value.absent(),
    this.includeBankInfoInMessages = const Value.absent(),
    this.nextInvoiceNumber = const Value.absent(),
    this.invoiceSeqYear = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkshopsCompanion.insert({
    required String id,
    required String name,
    this.mechanicName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.afternoonHour = const Value.absent(),
    this.nightHour = const Value.absent(),
    this.enableWhatsApp = const Value.absent(),
    this.enableTelegram = const Value.absent(),
    this.enableSms = const Value.absent(),
    this.includeBankInfoInMessages = const Value.absent(),
    this.nextInvoiceNumber = const Value.absent(),
    this.invoiceSeqYear = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<WorkshopRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mechanicName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? morningHour,
    Expression<int>? afternoonHour,
    Expression<int>? nightHour,
    Expression<bool>? enableWhatsApp,
    Expression<bool>? enableTelegram,
    Expression<bool>? enableSms,
    Expression<bool>? includeBankInfoInMessages,
    Expression<int>? nextInvoiceNumber,
    Expression<int>? invoiceSeqYear,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mechanicName != null) 'mechanic_name': mechanicName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (morningHour != null) 'morning_hour': morningHour,
      if (afternoonHour != null) 'afternoon_hour': afternoonHour,
      if (nightHour != null) 'night_hour': nightHour,
      if (enableWhatsApp != null) 'enable_whats_app': enableWhatsApp,
      if (enableTelegram != null) 'enable_telegram': enableTelegram,
      if (enableSms != null) 'enable_sms': enableSms,
      if (includeBankInfoInMessages != null)
        'include_bank_info_in_messages': includeBankInfoInMessages,
      if (nextInvoiceNumber != null) 'next_invoice_number': nextInvoiceNumber,
      if (invoiceSeqYear != null) 'invoice_seq_year': invoiceSeqYear,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkshopsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? mechanicName,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int>? morningHour,
    Value<int>? afternoonHour,
    Value<int>? nightHour,
    Value<bool>? enableWhatsApp,
    Value<bool>? enableTelegram,
    Value<bool>? enableSms,
    Value<bool>? includeBankInfoInMessages,
    Value<int>? nextInvoiceNumber,
    Value<int?>? invoiceSeqYear,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WorkshopsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mechanicName: mechanicName ?? this.mechanicName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      morningHour: morningHour ?? this.morningHour,
      afternoonHour: afternoonHour ?? this.afternoonHour,
      nightHour: nightHour ?? this.nightHour,
      enableWhatsApp: enableWhatsApp ?? this.enableWhatsApp,
      enableTelegram: enableTelegram ?? this.enableTelegram,
      enableSms: enableSms ?? this.enableSms,
      includeBankInfoInMessages:
          includeBankInfoInMessages ?? this.includeBankInfoInMessages,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      invoiceSeqYear: invoiceSeqYear ?? this.invoiceSeqYear,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mechanicName.present) {
      map['mechanic_name'] = Variable<String>(mechanicName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (morningHour.present) {
      map['morning_hour'] = Variable<int>(morningHour.value);
    }
    if (afternoonHour.present) {
      map['afternoon_hour'] = Variable<int>(afternoonHour.value);
    }
    if (nightHour.present) {
      map['night_hour'] = Variable<int>(nightHour.value);
    }
    if (enableWhatsApp.present) {
      map['enable_whats_app'] = Variable<bool>(enableWhatsApp.value);
    }
    if (enableTelegram.present) {
      map['enable_telegram'] = Variable<bool>(enableTelegram.value);
    }
    if (enableSms.present) {
      map['enable_sms'] = Variable<bool>(enableSms.value);
    }
    if (includeBankInfoInMessages.present) {
      map['include_bank_info_in_messages'] = Variable<bool>(
        includeBankInfoInMessages.value,
      );
    }
    if (nextInvoiceNumber.present) {
      map['next_invoice_number'] = Variable<int>(nextInvoiceNumber.value);
    }
    if (invoiceSeqYear.present) {
      map['invoice_seq_year'] = Variable<int>(invoiceSeqYear.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkshopsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mechanicName: $mechanicName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('morningHour: $morningHour, ')
          ..write('afternoonHour: $afternoonHour, ')
          ..write('nightHour: $nightHour, ')
          ..write('enableWhatsApp: $enableWhatsApp, ')
          ..write('enableTelegram: $enableTelegram, ')
          ..write('enableSms: $enableSms, ')
          ..write('includeBankInfoInMessages: $includeBankInfoInMessages, ')
          ..write('nextInvoiceNumber: $nextInvoiceNumber, ')
          ..write('invoiceSeqYear: $invoiceSeqYear, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BankAccountsTable extends BankAccounts
    with TableInfo<$BankAccountsTable, BankAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workshopIdMeta = const VerificationMeta(
    'workshopId',
  );
  @override
  late final GeneratedColumn<String> workshopId = GeneratedColumn<String>(
    'workshop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workshops (id)',
    ),
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountHolderNameMeta = const VerificationMeta(
    'accountHolderName',
  );
  @override
  late final GeneratedColumn<String> accountHolderName =
      GeneratedColumn<String>(
        'account_holder_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardNumberMeta = const VerificationMeta(
    'cardNumber',
  );
  @override
  late final GeneratedColumn<String> cardNumber = GeneratedColumn<String>(
    'card_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workshopId,
    bankName,
    accountHolderName,
    accountNumber,
    cardNumber,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workshop_id')) {
      context.handle(
        _workshopIdMeta,
        workshopId.isAcceptableOrUnknown(data['workshop_id']!, _workshopIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workshopIdMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('account_holder_name')) {
      context.handle(
        _accountHolderNameMeta,
        accountHolderName.isAcceptableOrUnknown(
          data['account_holder_name']!,
          _accountHolderNameMeta,
        ),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('card_number')) {
      context.handle(
        _cardNumberMeta,
        cardNumber.isAcceptableOrUnknown(data['card_number']!, _cardNumberMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workshopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workshop_id'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      accountHolderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_holder_name'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      cardNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_number'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BankAccountsTable createAlias(String alias) {
    return $BankAccountsTable(attachedDatabase, alias);
  }
}

class BankAccountRow extends DataClass implements Insertable<BankAccountRow> {
  final String id;
  final String workshopId;
  final String bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? cardNumber;
  final int sortOrder;
  final DateTime createdAt;
  const BankAccountRow({
    required this.id,
    required this.workshopId,
    required this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.cardNumber,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workshop_id'] = Variable<String>(workshopId);
    map['bank_name'] = Variable<String>(bankName);
    if (!nullToAbsent || accountHolderName != null) {
      map['account_holder_name'] = Variable<String>(accountHolderName);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || cardNumber != null) {
      map['card_number'] = Variable<String>(cardNumber);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BankAccountsCompanion toCompanion(bool nullToAbsent) {
    return BankAccountsCompanion(
      id: Value(id),
      workshopId: Value(workshopId),
      bankName: Value(bankName),
      accountHolderName: accountHolderName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountHolderName),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      cardNumber: cardNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cardNumber),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory BankAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankAccountRow(
      id: serializer.fromJson<String>(json['id']),
      workshopId: serializer.fromJson<String>(json['workshopId']),
      bankName: serializer.fromJson<String>(json['bankName']),
      accountHolderName: serializer.fromJson<String?>(
        json['accountHolderName'],
      ),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      cardNumber: serializer.fromJson<String?>(json['cardNumber']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workshopId': serializer.toJson<String>(workshopId),
      'bankName': serializer.toJson<String>(bankName),
      'accountHolderName': serializer.toJson<String?>(accountHolderName),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'cardNumber': serializer.toJson<String?>(cardNumber),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BankAccountRow copyWith({
    String? id,
    String? workshopId,
    String? bankName,
    Value<String?> accountHolderName = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<String?> cardNumber = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => BankAccountRow(
    id: id ?? this.id,
    workshopId: workshopId ?? this.workshopId,
    bankName: bankName ?? this.bankName,
    accountHolderName: accountHolderName.present
        ? accountHolderName.value
        : this.accountHolderName,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    cardNumber: cardNumber.present ? cardNumber.value : this.cardNumber,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  BankAccountRow copyWithCompanion(BankAccountsCompanion data) {
    return BankAccountRow(
      id: data.id.present ? data.id.value : this.id,
      workshopId: data.workshopId.present
          ? data.workshopId.value
          : this.workshopId,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      accountHolderName: data.accountHolderName.present
          ? data.accountHolderName.value
          : this.accountHolderName,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      cardNumber: data.cardNumber.present
          ? data.cardNumber.value
          : this.cardNumber,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankAccountRow(')
          ..write('id: $id, ')
          ..write('workshopId: $workshopId, ')
          ..write('bankName: $bankName, ')
          ..write('accountHolderName: $accountHolderName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workshopId,
    bankName,
    accountHolderName,
    accountNumber,
    cardNumber,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankAccountRow &&
          other.id == this.id &&
          other.workshopId == this.workshopId &&
          other.bankName == this.bankName &&
          other.accountHolderName == this.accountHolderName &&
          other.accountNumber == this.accountNumber &&
          other.cardNumber == this.cardNumber &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class BankAccountsCompanion extends UpdateCompanion<BankAccountRow> {
  final Value<String> id;
  final Value<String> workshopId;
  final Value<String> bankName;
  final Value<String?> accountHolderName;
  final Value<String?> accountNumber;
  final Value<String?> cardNumber;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BankAccountsCompanion({
    this.id = const Value.absent(),
    this.workshopId = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountHolderName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BankAccountsCompanion.insert({
    required String id,
    required String workshopId,
    required String bankName,
    this.accountHolderName = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workshopId = Value(workshopId),
       bankName = Value(bankName),
       createdAt = Value(createdAt);
  static Insertable<BankAccountRow> custom({
    Expression<String>? id,
    Expression<String>? workshopId,
    Expression<String>? bankName,
    Expression<String>? accountHolderName,
    Expression<String>? accountNumber,
    Expression<String>? cardNumber,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workshopId != null) 'workshop_id': workshopId,
      if (bankName != null) 'bank_name': bankName,
      if (accountHolderName != null) 'account_holder_name': accountHolderName,
      if (accountNumber != null) 'account_number': accountNumber,
      if (cardNumber != null) 'card_number': cardNumber,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BankAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? workshopId,
    Value<String>? bankName,
    Value<String?>? accountHolderName,
    Value<String?>? accountNumber,
    Value<String?>? cardNumber,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BankAccountsCompanion(
      id: id ?? this.id,
      workshopId: workshopId ?? this.workshopId,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workshopId.present) {
      map['workshop_id'] = Variable<String>(workshopId.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (accountHolderName.present) {
      map['account_holder_name'] = Variable<String>(accountHolderName.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankAccountsCompanion(')
          ..write('id: $id, ')
          ..write('workshopId: $workshopId, ')
          ..write('bankName: $bankName, ')
          ..write('accountHolderName: $accountHolderName, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    phone,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final String id;
  final String? fullName;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CustomerRow({
    required this.id,
    this.fullName,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      phone: serializer.fromJson<String?>(json['phone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String?>(fullName),
      'phone': serializer.toJson<String?>(phone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CustomerRow copyWith({
    String? id,
    Value<String?> fullName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomerRow(
    id: id ?? this.id,
    fullName: fullName.present ? fullName.value : this.fullName,
    phone: phone.present ? phone.value : this.phone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, phone, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<String> id;
  final Value<String?> fullName;
  final Value<String?> phone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomerRow> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String?>? fullName,
    Value<String?>? phone,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _plateNormalizedMeta = const VerificationMeta(
    'plateNormalized',
  );
  @override
  late final GeneratedColumn<String> plateNormalized = GeneratedColumn<String>(
    'plate_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _plateDisplayMeta = const VerificationMeta(
    'plateDisplay',
  );
  @override
  late final GeneratedColumn<String> plateDisplay = GeneratedColumn<String>(
    'plate_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trimMeta = const VerificationMeta('trim');
  @override
  late final GeneratedColumn<String> trim = GeneratedColumn<String>(
    'trim',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productionYearMeta = const VerificationMeta(
    'productionYear',
  );
  @override
  late final GeneratedColumn<int> productionYear = GeneratedColumn<int>(
    'production_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMileageMeta = const VerificationMeta(
    'lastMileage',
  );
  @override
  late final GeneratedColumn<int> lastMileage = GeneratedColumn<int>(
    'last_mileage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    plateNormalized,
    plateDisplay,
    manufacturer,
    model,
    trim,
    productionYear,
    lastMileage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('plate_normalized')) {
      context.handle(
        _plateNormalizedMeta,
        plateNormalized.isAcceptableOrUnknown(
          data['plate_normalized']!,
          _plateNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plateNormalizedMeta);
    }
    if (data.containsKey('plate_display')) {
      context.handle(
        _plateDisplayMeta,
        plateDisplay.isAcceptableOrUnknown(
          data['plate_display']!,
          _plateDisplayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plateDisplayMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('trim')) {
      context.handle(
        _trimMeta,
        trim.isAcceptableOrUnknown(data['trim']!, _trimMeta),
      );
    }
    if (data.containsKey('production_year')) {
      context.handle(
        _productionYearMeta,
        productionYear.isAcceptableOrUnknown(
          data['production_year']!,
          _productionYearMeta,
        ),
      );
    }
    if (data.containsKey('last_mileage')) {
      context.handle(
        _lastMileageMeta,
        lastMileage.isAcceptableOrUnknown(
          data['last_mileage']!,
          _lastMileageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      plateNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate_normalized'],
      )!,
      plateDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate_display'],
      )!,
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      trim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trim'],
      ),
      productionYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}production_year'],
      ),
      lastMileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_mileage'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleRow extends DataClass implements Insertable<VehicleRow> {
  final String id;
  final String? customerId;
  final String plateNormalized;
  final String plateDisplay;
  final String? manufacturer;
  final String? model;
  final String? trim;
  final int? productionYear;
  final int? lastMileage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VehicleRow({
    required this.id,
    this.customerId,
    required this.plateNormalized,
    required this.plateDisplay,
    this.manufacturer,
    this.model,
    this.trim,
    this.productionYear,
    this.lastMileage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['plate_normalized'] = Variable<String>(plateNormalized);
    map['plate_display'] = Variable<String>(plateDisplay);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || trim != null) {
      map['trim'] = Variable<String>(trim);
    }
    if (!nullToAbsent || productionYear != null) {
      map['production_year'] = Variable<int>(productionYear);
    }
    if (!nullToAbsent || lastMileage != null) {
      map['last_mileage'] = Variable<int>(lastMileage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      plateNormalized: Value(plateNormalized),
      plateDisplay: Value(plateDisplay),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      trim: trim == null && nullToAbsent ? const Value.absent() : Value(trim),
      productionYear: productionYear == null && nullToAbsent
          ? const Value.absent()
          : Value(productionYear),
      lastMileage: lastMileage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMileage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleRow(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      plateNormalized: serializer.fromJson<String>(json['plateNormalized']),
      plateDisplay: serializer.fromJson<String>(json['plateDisplay']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      model: serializer.fromJson<String?>(json['model']),
      trim: serializer.fromJson<String?>(json['trim']),
      productionYear: serializer.fromJson<int?>(json['productionYear']),
      lastMileage: serializer.fromJson<int?>(json['lastMileage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'plateNormalized': serializer.toJson<String>(plateNormalized),
      'plateDisplay': serializer.toJson<String>(plateDisplay),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'model': serializer.toJson<String?>(model),
      'trim': serializer.toJson<String?>(trim),
      'productionYear': serializer.toJson<int?>(productionYear),
      'lastMileage': serializer.toJson<int?>(lastMileage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VehicleRow copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    String? plateNormalized,
    String? plateDisplay,
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> trim = const Value.absent(),
    Value<int?> productionYear = const Value.absent(),
    Value<int?> lastMileage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VehicleRow(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    plateNormalized: plateNormalized ?? this.plateNormalized,
    plateDisplay: plateDisplay ?? this.plateDisplay,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    model: model.present ? model.value : this.model,
    trim: trim.present ? trim.value : this.trim,
    productionYear: productionYear.present
        ? productionYear.value
        : this.productionYear,
    lastMileage: lastMileage.present ? lastMileage.value : this.lastMileage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VehicleRow copyWithCompanion(VehiclesCompanion data) {
    return VehicleRow(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      plateNormalized: data.plateNormalized.present
          ? data.plateNormalized.value
          : this.plateNormalized,
      plateDisplay: data.plateDisplay.present
          ? data.plateDisplay.value
          : this.plateDisplay,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      model: data.model.present ? data.model.value : this.model,
      trim: data.trim.present ? data.trim.value : this.trim,
      productionYear: data.productionYear.present
          ? data.productionYear.value
          : this.productionYear,
      lastMileage: data.lastMileage.present
          ? data.lastMileage.value
          : this.lastMileage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleRow(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('plateNormalized: $plateNormalized, ')
          ..write('plateDisplay: $plateDisplay, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('productionYear: $productionYear, ')
          ..write('lastMileage: $lastMileage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    plateNormalized,
    plateDisplay,
    manufacturer,
    model,
    trim,
    productionYear,
    lastMileage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleRow &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.plateNormalized == this.plateNormalized &&
          other.plateDisplay == this.plateDisplay &&
          other.manufacturer == this.manufacturer &&
          other.model == this.model &&
          other.trim == this.trim &&
          other.productionYear == this.productionYear &&
          other.lastMileage == this.lastMileage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehiclesCompanion extends UpdateCompanion<VehicleRow> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String> plateNormalized;
  final Value<String> plateDisplay;
  final Value<String?> manufacturer;
  final Value<String?> model;
  final Value<String?> trim;
  final Value<int?> productionYear;
  final Value<int?> lastMileage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.plateNormalized = const Value.absent(),
    this.plateDisplay = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.trim = const Value.absent(),
    this.productionYear = const Value.absent(),
    this.lastMileage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required String plateNormalized,
    required String plateDisplay,
    this.manufacturer = const Value.absent(),
    this.model = const Value.absent(),
    this.trim = const Value.absent(),
    this.productionYear = const Value.absent(),
    this.lastMileage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plateNormalized = Value(plateNormalized),
       plateDisplay = Value(plateDisplay),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VehicleRow> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? plateNormalized,
    Expression<String>? plateDisplay,
    Expression<String>? manufacturer,
    Expression<String>? model,
    Expression<String>? trim,
    Expression<int>? productionYear,
    Expression<int>? lastMileage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (plateNormalized != null) 'plate_normalized': plateNormalized,
      if (plateDisplay != null) 'plate_display': plateDisplay,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (trim != null) 'trim': trim,
      if (productionYear != null) 'production_year': productionYear,
      if (lastMileage != null) 'last_mileage': lastMileage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<String>? plateNormalized,
    Value<String>? plateDisplay,
    Value<String?>? manufacturer,
    Value<String?>? model,
    Value<String?>? trim,
    Value<int?>? productionYear,
    Value<int?>? lastMileage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      plateNormalized: plateNormalized ?? this.plateNormalized,
      plateDisplay: plateDisplay ?? this.plateDisplay,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      trim: trim ?? this.trim,
      productionYear: productionYear ?? this.productionYear,
      lastMileage: lastMileage ?? this.lastMileage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (plateNormalized.present) {
      map['plate_normalized'] = Variable<String>(plateNormalized.value);
    }
    if (plateDisplay.present) {
      map['plate_display'] = Variable<String>(plateDisplay.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (trim.present) {
      map['trim'] = Variable<String>(trim.value);
    }
    if (productionYear.present) {
      map['production_year'] = Variable<int>(productionYear.value);
    }
    if (lastMileage.present) {
      map['last_mileage'] = Variable<int>(lastMileage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('plateNormalized: $plateNormalized, ')
          ..write('plateDisplay: $plateDisplay, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('productionYear: $productionYear, ')
          ..write('lastMileage: $lastMileage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceCategoriesTable extends ServiceCategories
    with TableInfo<$ServiceCategoriesTable, ServiceCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    iconKey,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
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
  ServiceCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ServiceCategoriesTable createAlias(String alias) {
    return $ServiceCategoriesTable(attachedDatabase, alias);
  }
}

class ServiceCategoryRow extends DataClass
    implements Insertable<ServiceCategoryRow> {
  final String id;
  final String title;
  final String iconKey;
  final int sortOrder;
  final bool isActive;
  const ServiceCategoryRow({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['icon_key'] = Variable<String>(iconKey);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ServiceCategoriesCompanion(
      id: Value(id),
      title: Value(title),
      iconKey: Value(iconKey),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory ServiceCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'iconKey': serializer.toJson<String>(iconKey),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ServiceCategoryRow copyWith({
    String? id,
    String? title,
    String? iconKey,
    int? sortOrder,
    bool? isActive,
  }) => ServiceCategoryRow(
    id: id ?? this.id,
    title: title ?? this.title,
    iconKey: iconKey ?? this.iconKey,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  ServiceCategoryRow copyWithCompanion(ServiceCategoriesCompanion data) {
    return ServiceCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoryRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, iconKey, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCategoryRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.iconKey == this.iconKey &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ServiceCategoriesCompanion extends UpdateCompanion<ServiceCategoryRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> iconKey;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceCategoriesCompanion.insert({
    required String id,
    required String title,
    required String iconKey,
    required int sortOrder,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       iconKey = Value(iconKey),
       sortOrder = Value(sortOrder);
  static Insertable<ServiceCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? iconKey,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (iconKey != null) 'icon_key': iconKey,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? iconKey,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return ServiceCategoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      iconKey: iconKey ?? this.iconKey,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, PartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedTitleMeta = const VerificationMeta(
    'normalizedTitle',
  );
  @override
  late final GeneratedColumn<String> normalizedTitle = GeneratedColumn<String>(
    'normalized_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceCategoryIdMeta = const VerificationMeta(
    'serviceCategoryId',
  );
  @override
  late final GeneratedColumn<String> serviceCategoryId =
      GeneratedColumn<String>(
        'service_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES service_categories (id)',
        ),
      );
  static const VerificationMeta _vehicleModelMeta = const VerificationMeta(
    'vehicleModel',
  );
  @override
  late final GeneratedColumn<String> vehicleModel = GeneratedColumn<String>(
    'vehicle_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    normalizedTitle,
    serviceCategoryId,
    vehicleModel,
    brand,
    usageCount,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('normalized_title')) {
      context.handle(
        _normalizedTitleMeta,
        normalizedTitle.isAcceptableOrUnknown(
          data['normalized_title']!,
          _normalizedTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedTitleMeta);
    }
    if (data.containsKey('service_category_id')) {
      context.handle(
        _serviceCategoryIdMeta,
        serviceCategoryId.isAcceptableOrUnknown(
          data['service_category_id']!,
          _serviceCategoryIdMeta,
        ),
      );
    }
    if (data.containsKey('vehicle_model')) {
      context.handle(
        _vehicleModelMeta,
        vehicleModel.isAcceptableOrUnknown(
          data['vehicle_model']!,
          _vehicleModelMeta,
        ),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      normalizedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_title'],
      )!,
      serviceCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_category_id'],
      ),
      vehicleModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_model'],
      ),
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class PartRow extends DataClass implements Insertable<PartRow> {
  final String id;
  final String title;
  final String normalizedTitle;
  final String? serviceCategoryId;
  final String? vehicleModel;
  final String? brand;
  final int usageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PartRow({
    required this.id,
    required this.title,
    required this.normalizedTitle,
    this.serviceCategoryId,
    this.vehicleModel,
    this.brand,
    required this.usageCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['normalized_title'] = Variable<String>(normalizedTitle);
    if (!nullToAbsent || serviceCategoryId != null) {
      map['service_category_id'] = Variable<String>(serviceCategoryId);
    }
    if (!nullToAbsent || vehicleModel != null) {
      map['vehicle_model'] = Variable<String>(vehicleModel);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['usage_count'] = Variable<int>(usageCount);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      title: Value(title),
      normalizedTitle: Value(normalizedTitle),
      serviceCategoryId: serviceCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceCategoryId),
      vehicleModel: vehicleModel == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleModel),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      usageCount: Value(usageCount),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PartRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      normalizedTitle: serializer.fromJson<String>(json['normalizedTitle']),
      serviceCategoryId: serializer.fromJson<String?>(
        json['serviceCategoryId'],
      ),
      vehicleModel: serializer.fromJson<String?>(json['vehicleModel']),
      brand: serializer.fromJson<String?>(json['brand']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'normalizedTitle': serializer.toJson<String>(normalizedTitle),
      'serviceCategoryId': serializer.toJson<String?>(serviceCategoryId),
      'vehicleModel': serializer.toJson<String?>(vehicleModel),
      'brand': serializer.toJson<String?>(brand),
      'usageCount': serializer.toJson<int>(usageCount),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PartRow copyWith({
    String? id,
    String? title,
    String? normalizedTitle,
    Value<String?> serviceCategoryId = const Value.absent(),
    Value<String?> vehicleModel = const Value.absent(),
    Value<String?> brand = const Value.absent(),
    int? usageCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PartRow(
    id: id ?? this.id,
    title: title ?? this.title,
    normalizedTitle: normalizedTitle ?? this.normalizedTitle,
    serviceCategoryId: serviceCategoryId.present
        ? serviceCategoryId.value
        : this.serviceCategoryId,
    vehicleModel: vehicleModel.present ? vehicleModel.value : this.vehicleModel,
    brand: brand.present ? brand.value : this.brand,
    usageCount: usageCount ?? this.usageCount,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PartRow copyWithCompanion(PartsCompanion data) {
    return PartRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      normalizedTitle: data.normalizedTitle.present
          ? data.normalizedTitle.value
          : this.normalizedTitle,
      serviceCategoryId: data.serviceCategoryId.present
          ? data.serviceCategoryId.value
          : this.serviceCategoryId,
      vehicleModel: data.vehicleModel.present
          ? data.vehicleModel.value
          : this.vehicleModel,
      brand: data.brand.present ? data.brand.value : this.brand,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('serviceCategoryId: $serviceCategoryId, ')
          ..write('vehicleModel: $vehicleModel, ')
          ..write('brand: $brand, ')
          ..write('usageCount: $usageCount, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    normalizedTitle,
    serviceCategoryId,
    vehicleModel,
    brand,
    usageCount,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.normalizedTitle == this.normalizedTitle &&
          other.serviceCategoryId == this.serviceCategoryId &&
          other.vehicleModel == this.vehicleModel &&
          other.brand == this.brand &&
          other.usageCount == this.usageCount &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartsCompanion extends UpdateCompanion<PartRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> normalizedTitle;
  final Value<String?> serviceCategoryId;
  final Value<String?> vehicleModel;
  final Value<String?> brand;
  final Value<int> usageCount;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.normalizedTitle = const Value.absent(),
    this.serviceCategoryId = const Value.absent(),
    this.vehicleModel = const Value.absent(),
    this.brand = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartsCompanion.insert({
    required String id,
    required String title,
    required String normalizedTitle,
    this.serviceCategoryId = const Value.absent(),
    this.vehicleModel = const Value.absent(),
    this.brand = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       normalizedTitle = Value(normalizedTitle),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PartRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? normalizedTitle,
    Expression<String>? serviceCategoryId,
    Expression<String>? vehicleModel,
    Expression<String>? brand,
    Expression<int>? usageCount,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (normalizedTitle != null) 'normalized_title': normalizedTitle,
      if (serviceCategoryId != null) 'service_category_id': serviceCategoryId,
      if (vehicleModel != null) 'vehicle_model': vehicleModel,
      if (brand != null) 'brand': brand,
      if (usageCount != null) 'usage_count': usageCount,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? normalizedTitle,
    Value<String?>? serviceCategoryId,
    Value<String?>? vehicleModel,
    Value<String?>? brand,
    Value<int>? usageCount,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      normalizedTitle: normalizedTitle ?? this.normalizedTitle,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      brand: brand ?? this.brand,
      usageCount: usageCount ?? this.usageCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (normalizedTitle.present) {
      map['normalized_title'] = Variable<String>(normalizedTitle.value);
    }
    if (serviceCategoryId.present) {
      map['service_category_id'] = Variable<String>(serviceCategoryId.value);
    }
    if (vehicleModel.present) {
      map['vehicle_model'] = Variable<String>(vehicleModel.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('serviceCategoryId: $serviceCategoryId, ')
          ..write('vehicleModel: $vehicleModel, ')
          ..write('brand: $brand, ')
          ..write('usageCount: $usageCount, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairOrdersTable extends RepairOrders
    with TableInfo<$RepairOrdersTable, RepairOrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _complaintTextMeta = const VerificationMeta(
    'complaintText',
  );
  @override
  late final GeneratedColumn<String> complaintText = GeneratedColumn<String>(
    'complaint_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mileageMeta = const VerificationMeta(
    'mileage',
  );
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
    'mileage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _laborAmountMeta = const VerificationMeta(
    'laborAmount',
  );
  @override
  late final GeneratedColumn<int> laborAmount = GeneratedColumn<int>(
    'labor_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<int> discountAmount = GeneratedColumn<int>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    customerId,
    status,
    complaintText,
    mileage,
    laborAmount,
    discountAmount,
    paymentStatus,
    paidAmount,
    invoiceNumber,
    cancelReason,
    createdAt,
    completedAt,
    deliveredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairOrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('complaint_text')) {
      context.handle(
        _complaintTextMeta,
        complaintText.isAcceptableOrUnknown(
          data['complaint_text']!,
          _complaintTextMeta,
        ),
      );
    }
    if (data.containsKey('mileage')) {
      context.handle(
        _mileageMeta,
        mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta),
      );
    }
    if (data.containsKey('labor_amount')) {
      context.handle(
        _laborAmountMeta,
        laborAmount.isAcceptableOrUnknown(
          data['labor_amount']!,
          _laborAmountMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {invoiceNumber},
  ];
  @override
  RepairOrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairOrderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      complaintText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}complaint_text'],
      ),
      mileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mileage'],
      ),
      laborAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labor_amount'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount'],
      )!,
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      ),
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
    );
  }

  @override
  $RepairOrdersTable createAlias(String alias) {
    return $RepairOrdersTable(attachedDatabase, alias);
  }
}

class RepairOrderRow extends DataClass implements Insertable<RepairOrderRow> {
  final String id;
  final String vehicleId;
  final String? customerId;
  final String status;
  final String? complaintText;
  final int? mileage;
  final int laborAmount;
  final int discountAmount;
  final String paymentStatus;
  final int paidAmount;
  final String? invoiceNumber;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? deliveredAt;
  const RepairOrderRow({
    required this.id,
    required this.vehicleId,
    this.customerId,
    required this.status,
    this.complaintText,
    this.mileage,
    required this.laborAmount,
    required this.discountAmount,
    required this.paymentStatus,
    required this.paidAmount,
    this.invoiceNumber,
    this.cancelReason,
    required this.createdAt,
    this.completedAt,
    this.deliveredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || complaintText != null) {
      map['complaint_text'] = Variable<String>(complaintText);
    }
    if (!nullToAbsent || mileage != null) {
      map['mileage'] = Variable<int>(mileage);
    }
    map['labor_amount'] = Variable<int>(laborAmount);
    map['discount_amount'] = Variable<int>(discountAmount);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['paid_amount'] = Variable<int>(paidAmount);
    if (!nullToAbsent || invoiceNumber != null) {
      map['invoice_number'] = Variable<String>(invoiceNumber);
    }
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    return map;
  }

  RepairOrdersCompanion toCompanion(bool nullToAbsent) {
    return RepairOrdersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      status: Value(status),
      complaintText: complaintText == null && nullToAbsent
          ? const Value.absent()
          : Value(complaintText),
      mileage: mileage == null && nullToAbsent
          ? const Value.absent()
          : Value(mileage),
      laborAmount: Value(laborAmount),
      discountAmount: Value(discountAmount),
      paymentStatus: Value(paymentStatus),
      paidAmount: Value(paidAmount),
      invoiceNumber: invoiceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceNumber),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
    );
  }

  factory RepairOrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairOrderRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      complaintText: serializer.fromJson<String?>(json['complaintText']),
      mileage: serializer.fromJson<int?>(json['mileage']),
      laborAmount: serializer.fromJson<int>(json['laborAmount']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      invoiceNumber: serializer.fromJson<String?>(json['invoiceNumber']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'customerId': serializer.toJson<String?>(customerId),
      'status': serializer.toJson<String>(status),
      'complaintText': serializer.toJson<String?>(complaintText),
      'mileage': serializer.toJson<int?>(mileage),
      'laborAmount': serializer.toJson<int>(laborAmount),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'invoiceNumber': serializer.toJson<String?>(invoiceNumber),
      'cancelReason': serializer.toJson<String?>(cancelReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
    };
  }

  RepairOrderRow copyWith({
    String? id,
    String? vehicleId,
    Value<String?> customerId = const Value.absent(),
    String? status,
    Value<String?> complaintText = const Value.absent(),
    Value<int?> mileage = const Value.absent(),
    int? laborAmount,
    int? discountAmount,
    String? paymentStatus,
    int? paidAmount,
    Value<String?> invoiceNumber = const Value.absent(),
    Value<String?> cancelReason = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> deliveredAt = const Value.absent(),
  }) => RepairOrderRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    customerId: customerId.present ? customerId.value : this.customerId,
    status: status ?? this.status,
    complaintText: complaintText.present
        ? complaintText.value
        : this.complaintText,
    mileage: mileage.present ? mileage.value : this.mileage,
    laborAmount: laborAmount ?? this.laborAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paidAmount: paidAmount ?? this.paidAmount,
    invoiceNumber: invoiceNumber.present
        ? invoiceNumber.value
        : this.invoiceNumber,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
  );
  RepairOrderRow copyWithCompanion(RepairOrdersCompanion data) {
    return RepairOrderRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      complaintText: data.complaintText.present
          ? data.complaintText.value
          : this.complaintText,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      laborAmount: data.laborAmount.present
          ? data.laborAmount.value
          : this.laborAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairOrderRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('complaintText: $complaintText, ')
          ..write('mileage: $mileage, ')
          ..write('laborAmount: $laborAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    customerId,
    status,
    complaintText,
    mileage,
    laborAmount,
    discountAmount,
    paymentStatus,
    paidAmount,
    invoiceNumber,
    cancelReason,
    createdAt,
    completedAt,
    deliveredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairOrderRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.complaintText == this.complaintText &&
          other.mileage == this.mileage &&
          other.laborAmount == this.laborAmount &&
          other.discountAmount == this.discountAmount &&
          other.paymentStatus == this.paymentStatus &&
          other.paidAmount == this.paidAmount &&
          other.invoiceNumber == this.invoiceNumber &&
          other.cancelReason == this.cancelReason &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt &&
          other.deliveredAt == this.deliveredAt);
}

class RepairOrdersCompanion extends UpdateCompanion<RepairOrderRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String?> customerId;
  final Value<String> status;
  final Value<String?> complaintText;
  final Value<int?> mileage;
  final Value<int> laborAmount;
  final Value<int> discountAmount;
  final Value<String> paymentStatus;
  final Value<int> paidAmount;
  final Value<String?> invoiceNumber;
  final Value<String?> cancelReason;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> deliveredAt;
  final Value<int> rowid;
  const RepairOrdersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.complaintText = const Value.absent(),
    this.mileage = const Value.absent(),
    this.laborAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairOrdersCompanion.insert({
    required String id,
    required String vehicleId,
    this.customerId = const Value.absent(),
    required String status,
    this.complaintText = const Value.absent(),
    this.mileage = const Value.absent(),
    this.laborAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    required String paymentStatus,
    this.paidAmount = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.cancelReason = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       status = Value(status),
       paymentStatus = Value(paymentStatus),
       createdAt = Value(createdAt);
  static Insertable<RepairOrderRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<String>? complaintText,
    Expression<int>? mileage,
    Expression<int>? laborAmount,
    Expression<int>? discountAmount,
    Expression<String>? paymentStatus,
    Expression<int>? paidAmount,
    Expression<String>? invoiceNumber,
    Expression<String>? cancelReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? deliveredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (complaintText != null) 'complaint_text': complaintText,
      if (mileage != null) 'mileage': mileage,
      if (laborAmount != null) 'labor_amount': laborAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String?>? customerId,
    Value<String>? status,
    Value<String?>? complaintText,
    Value<int?>? mileage,
    Value<int>? laborAmount,
    Value<int>? discountAmount,
    Value<String>? paymentStatus,
    Value<int>? paidAmount,
    Value<String?>? invoiceNumber,
    Value<String?>? cancelReason,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? deliveredAt,
    Value<int>? rowid,
  }) {
    return RepairOrdersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      complaintText: complaintText ?? this.complaintText,
      mileage: mileage ?? this.mileage,
      laborAmount: laborAmount ?? this.laborAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidAmount: paidAmount ?? this.paidAmount,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (complaintText.present) {
      map['complaint_text'] = Variable<String>(complaintText.value);
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (laborAmount.present) {
      map['labor_amount'] = Variable<int>(laborAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairOrdersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('complaintText: $complaintText, ')
          ..write('mileage: $mileage, ')
          ..write('laborAmount: $laborAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairServicesTable extends RepairServices
    with TableInfo<$RepairServicesTable, RepairServiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairOrderId,
    title,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairServiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repairOrderIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepairServiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairServiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RepairServicesTable createAlias(String alias) {
    return $RepairServicesTable(attachedDatabase, alias);
  }
}

class RepairServiceRow extends DataClass
    implements Insertable<RepairServiceRow> {
  final String id;
  final String repairOrderId;
  final String title;
  final int amount;
  final DateTime createdAt;
  const RepairServiceRow({
    required this.id,
    required this.repairOrderId,
    required this.title,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_order_id'] = Variable<String>(repairOrderId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RepairServicesCompanion toCompanion(bool nullToAbsent) {
    return RepairServicesCompanion(
      id: Value(id),
      repairOrderId: Value(repairOrderId),
      title: Value(title),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory RepairServiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairServiceRow(
      id: serializer.fromJson<String>(json['id']),
      repairOrderId: serializer.fromJson<String>(json['repairOrderId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairOrderId': serializer.toJson<String>(repairOrderId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RepairServiceRow copyWith({
    String? id,
    String? repairOrderId,
    String? title,
    int? amount,
    DateTime? createdAt,
  }) => RepairServiceRow(
    id: id ?? this.id,
    repairOrderId: repairOrderId ?? this.repairOrderId,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  RepairServiceRow copyWithCompanion(RepairServicesCompanion data) {
    return RepairServiceRow(
      id: data.id.present ? data.id.value : this.id,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairServiceRow(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, repairOrderId, title, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairServiceRow &&
          other.id == this.id &&
          other.repairOrderId == this.repairOrderId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class RepairServicesCompanion extends UpdateCompanion<RepairServiceRow> {
  final Value<String> id;
  final Value<String> repairOrderId;
  final Value<String> title;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RepairServicesCompanion({
    this.id = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairServicesCompanion.insert({
    required String id,
    required String repairOrderId,
    required String title,
    this.amount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairOrderId = Value(repairOrderId),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<RepairServiceRow> custom({
    Expression<String>? id,
    Expression<String>? repairOrderId,
    Expression<String>? title,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairServicesCompanion copyWith({
    Value<String>? id,
    Value<String>? repairOrderId,
    Value<String>? title,
    Value<int>? amount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RepairServicesCompanion(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairServicesCompanion(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairPartsTable extends RepairParts
    with TableInfo<$RepairPartsTable, RepairPartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _partTitleSnapshotMeta = const VerificationMeta(
    'partTitleSnapshot',
  );
  @override
  late final GeneratedColumn<String> partTitleSnapshot =
      GeneratedColumn<String>(
        'part_title_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _brandSnapshotMeta = const VerificationMeta(
    'brandSnapshot',
  );
  @override
  late final GeneratedColumn<String> brandSnapshot = GeneratedColumn<String>(
    'brand_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suppliedByMeta = const VerificationMeta(
    'suppliedBy',
  );
  @override
  late final GeneratedColumn<String> suppliedBy = GeneratedColumn<String>(
    'supplied_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairOrderId,
    partId,
    partTitleSnapshot,
    brandSnapshot,
    quantity,
    unitPrice,
    suppliedBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairPartRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repairOrderIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('part_title_snapshot')) {
      context.handle(
        _partTitleSnapshotMeta,
        partTitleSnapshot.isAcceptableOrUnknown(
          data['part_title_snapshot']!,
          _partTitleSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partTitleSnapshotMeta);
    }
    if (data.containsKey('brand_snapshot')) {
      context.handle(
        _brandSnapshotMeta,
        brandSnapshot.isAcceptableOrUnknown(
          data['brand_snapshot']!,
          _brandSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('supplied_by')) {
      context.handle(
        _suppliedByMeta,
        suppliedBy.isAcceptableOrUnknown(data['supplied_by']!, _suppliedByMeta),
      );
    } else if (isInserting) {
      context.missing(_suppliedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepairPartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairPartRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      ),
      partTitleSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_title_snapshot'],
      )!,
      brandSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_snapshot'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      suppliedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplied_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RepairPartsTable createAlias(String alias) {
    return $RepairPartsTable(attachedDatabase, alias);
  }
}

class RepairPartRow extends DataClass implements Insertable<RepairPartRow> {
  final String id;
  final String repairOrderId;
  final String? partId;
  final String partTitleSnapshot;
  final String? brandSnapshot;
  final int quantity;
  final int unitPrice;
  final String suppliedBy;
  final DateTime createdAt;
  const RepairPartRow({
    required this.id,
    required this.repairOrderId,
    this.partId,
    required this.partTitleSnapshot,
    this.brandSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.suppliedBy,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_order_id'] = Variable<String>(repairOrderId);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<String>(partId);
    }
    map['part_title_snapshot'] = Variable<String>(partTitleSnapshot);
    if (!nullToAbsent || brandSnapshot != null) {
      map['brand_snapshot'] = Variable<String>(brandSnapshot);
    }
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<int>(unitPrice);
    map['supplied_by'] = Variable<String>(suppliedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RepairPartsCompanion toCompanion(bool nullToAbsent) {
    return RepairPartsCompanion(
      id: Value(id),
      repairOrderId: Value(repairOrderId),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      partTitleSnapshot: Value(partTitleSnapshot),
      brandSnapshot: brandSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(brandSnapshot),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      suppliedBy: Value(suppliedBy),
      createdAt: Value(createdAt),
    );
  }

  factory RepairPartRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairPartRow(
      id: serializer.fromJson<String>(json['id']),
      repairOrderId: serializer.fromJson<String>(json['repairOrderId']),
      partId: serializer.fromJson<String?>(json['partId']),
      partTitleSnapshot: serializer.fromJson<String>(json['partTitleSnapshot']),
      brandSnapshot: serializer.fromJson<String?>(json['brandSnapshot']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      suppliedBy: serializer.fromJson<String>(json['suppliedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairOrderId': serializer.toJson<String>(repairOrderId),
      'partId': serializer.toJson<String?>(partId),
      'partTitleSnapshot': serializer.toJson<String>(partTitleSnapshot),
      'brandSnapshot': serializer.toJson<String?>(brandSnapshot),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'suppliedBy': serializer.toJson<String>(suppliedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RepairPartRow copyWith({
    String? id,
    String? repairOrderId,
    Value<String?> partId = const Value.absent(),
    String? partTitleSnapshot,
    Value<String?> brandSnapshot = const Value.absent(),
    int? quantity,
    int? unitPrice,
    String? suppliedBy,
    DateTime? createdAt,
  }) => RepairPartRow(
    id: id ?? this.id,
    repairOrderId: repairOrderId ?? this.repairOrderId,
    partId: partId.present ? partId.value : this.partId,
    partTitleSnapshot: partTitleSnapshot ?? this.partTitleSnapshot,
    brandSnapshot: brandSnapshot.present
        ? brandSnapshot.value
        : this.brandSnapshot,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    suppliedBy: suppliedBy ?? this.suppliedBy,
    createdAt: createdAt ?? this.createdAt,
  );
  RepairPartRow copyWithCompanion(RepairPartsCompanion data) {
    return RepairPartRow(
      id: data.id.present ? data.id.value : this.id,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      partId: data.partId.present ? data.partId.value : this.partId,
      partTitleSnapshot: data.partTitleSnapshot.present
          ? data.partTitleSnapshot.value
          : this.partTitleSnapshot,
      brandSnapshot: data.brandSnapshot.present
          ? data.brandSnapshot.value
          : this.brandSnapshot,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      suppliedBy: data.suppliedBy.present
          ? data.suppliedBy.value
          : this.suppliedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairPartRow(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('partId: $partId, ')
          ..write('partTitleSnapshot: $partTitleSnapshot, ')
          ..write('brandSnapshot: $brandSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('suppliedBy: $suppliedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repairOrderId,
    partId,
    partTitleSnapshot,
    brandSnapshot,
    quantity,
    unitPrice,
    suppliedBy,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairPartRow &&
          other.id == this.id &&
          other.repairOrderId == this.repairOrderId &&
          other.partId == this.partId &&
          other.partTitleSnapshot == this.partTitleSnapshot &&
          other.brandSnapshot == this.brandSnapshot &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.suppliedBy == this.suppliedBy &&
          other.createdAt == this.createdAt);
}

class RepairPartsCompanion extends UpdateCompanion<RepairPartRow> {
  final Value<String> id;
  final Value<String> repairOrderId;
  final Value<String?> partId;
  final Value<String> partTitleSnapshot;
  final Value<String?> brandSnapshot;
  final Value<int> quantity;
  final Value<int> unitPrice;
  final Value<String> suppliedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RepairPartsCompanion({
    this.id = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.partId = const Value.absent(),
    this.partTitleSnapshot = const Value.absent(),
    this.brandSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.suppliedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairPartsCompanion.insert({
    required String id,
    required String repairOrderId,
    this.partId = const Value.absent(),
    required String partTitleSnapshot,
    this.brandSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    required int unitPrice,
    required String suppliedBy,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairOrderId = Value(repairOrderId),
       partTitleSnapshot = Value(partTitleSnapshot),
       unitPrice = Value(unitPrice),
       suppliedBy = Value(suppliedBy),
       createdAt = Value(createdAt);
  static Insertable<RepairPartRow> custom({
    Expression<String>? id,
    Expression<String>? repairOrderId,
    Expression<String>? partId,
    Expression<String>? partTitleSnapshot,
    Expression<String>? brandSnapshot,
    Expression<int>? quantity,
    Expression<int>? unitPrice,
    Expression<String>? suppliedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (partId != null) 'part_id': partId,
      if (partTitleSnapshot != null) 'part_title_snapshot': partTitleSnapshot,
      if (brandSnapshot != null) 'brand_snapshot': brandSnapshot,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (suppliedBy != null) 'supplied_by': suppliedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairPartsCompanion copyWith({
    Value<String>? id,
    Value<String>? repairOrderId,
    Value<String?>? partId,
    Value<String>? partTitleSnapshot,
    Value<String?>? brandSnapshot,
    Value<int>? quantity,
    Value<int>? unitPrice,
    Value<String>? suppliedBy,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RepairPartsCompanion(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      partId: partId ?? this.partId,
      partTitleSnapshot: partTitleSnapshot ?? this.partTitleSnapshot,
      brandSnapshot: brandSnapshot ?? this.brandSnapshot,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      suppliedBy: suppliedBy ?? this.suppliedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (partTitleSnapshot.present) {
      map['part_title_snapshot'] = Variable<String>(partTitleSnapshot.value);
    }
    if (brandSnapshot.present) {
      map['brand_snapshot'] = Variable<String>(brandSnapshot.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (suppliedBy.present) {
      map['supplied_by'] = Variable<String>(suppliedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairPartsCompanion(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('partId: $partId, ')
          ..write('partTitleSnapshot: $partTitleSnapshot, ')
          ..write('brandSnapshot: $brandSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('suppliedBy: $suppliedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartPriceHistoryTable extends PartPriceHistory
    with TableInfo<$PartPriceHistoryTable, PartPriceHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartPriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id)',
    ),
  );
  static const VerificationMeta _partTitleNormalizedMeta =
      const VerificationMeta('partTitleNormalized');
  @override
  late final GeneratedColumn<String> partTitleNormalized =
      GeneratedColumn<String>(
        'part_title_normalized',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _vehicleModelMeta = const VerificationMeta(
    'vehicleModel',
  );
  @override
  late final GeneratedColumn<String> vehicleModel = GeneratedColumn<String>(
    'vehicle_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    partId,
    partTitleNormalized,
    vehicleModel,
    amount,
    repairOrderId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_price_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartPriceHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('part_title_normalized')) {
      context.handle(
        _partTitleNormalizedMeta,
        partTitleNormalized.isAcceptableOrUnknown(
          data['part_title_normalized']!,
          _partTitleNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partTitleNormalizedMeta);
    }
    if (data.containsKey('vehicle_model')) {
      context.handle(
        _vehicleModelMeta,
        vehicleModel.isAcceptableOrUnknown(
          data['vehicle_model']!,
          _vehicleModelMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartPriceHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartPriceHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      ),
      partTitleNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_title_normalized'],
      )!,
      vehicleModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_model'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PartPriceHistoryTable createAlias(String alias) {
    return $PartPriceHistoryTable(attachedDatabase, alias);
  }
}

class PartPriceHistoryRow extends DataClass
    implements Insertable<PartPriceHistoryRow> {
  final String id;
  final String? partId;
  final String partTitleNormalized;
  final String? vehicleModel;
  final int amount;
  final String? repairOrderId;
  final DateTime createdAt;
  const PartPriceHistoryRow({
    required this.id,
    this.partId,
    required this.partTitleNormalized,
    this.vehicleModel,
    required this.amount,
    this.repairOrderId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<String>(partId);
    }
    map['part_title_normalized'] = Variable<String>(partTitleNormalized);
    if (!nullToAbsent || vehicleModel != null) {
      map['vehicle_model'] = Variable<String>(vehicleModel);
    }
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || repairOrderId != null) {
      map['repair_order_id'] = Variable<String>(repairOrderId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PartPriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return PartPriceHistoryCompanion(
      id: Value(id),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      partTitleNormalized: Value(partTitleNormalized),
      vehicleModel: vehicleModel == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleModel),
      amount: Value(amount),
      repairOrderId: repairOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(repairOrderId),
      createdAt: Value(createdAt),
    );
  }

  factory PartPriceHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartPriceHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      partId: serializer.fromJson<String?>(json['partId']),
      partTitleNormalized: serializer.fromJson<String>(
        json['partTitleNormalized'],
      ),
      vehicleModel: serializer.fromJson<String?>(json['vehicleModel']),
      amount: serializer.fromJson<int>(json['amount']),
      repairOrderId: serializer.fromJson<String?>(json['repairOrderId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'partId': serializer.toJson<String?>(partId),
      'partTitleNormalized': serializer.toJson<String>(partTitleNormalized),
      'vehicleModel': serializer.toJson<String?>(vehicleModel),
      'amount': serializer.toJson<int>(amount),
      'repairOrderId': serializer.toJson<String?>(repairOrderId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PartPriceHistoryRow copyWith({
    String? id,
    Value<String?> partId = const Value.absent(),
    String? partTitleNormalized,
    Value<String?> vehicleModel = const Value.absent(),
    int? amount,
    Value<String?> repairOrderId = const Value.absent(),
    DateTime? createdAt,
  }) => PartPriceHistoryRow(
    id: id ?? this.id,
    partId: partId.present ? partId.value : this.partId,
    partTitleNormalized: partTitleNormalized ?? this.partTitleNormalized,
    vehicleModel: vehicleModel.present ? vehicleModel.value : this.vehicleModel,
    amount: amount ?? this.amount,
    repairOrderId: repairOrderId.present
        ? repairOrderId.value
        : this.repairOrderId,
    createdAt: createdAt ?? this.createdAt,
  );
  PartPriceHistoryRow copyWithCompanion(PartPriceHistoryCompanion data) {
    return PartPriceHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      partTitleNormalized: data.partTitleNormalized.present
          ? data.partTitleNormalized.value
          : this.partTitleNormalized,
      vehicleModel: data.vehicleModel.present
          ? data.vehicleModel.value
          : this.vehicleModel,
      amount: data.amount.present ? data.amount.value : this.amount,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartPriceHistoryRow(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('partTitleNormalized: $partTitleNormalized, ')
          ..write('vehicleModel: $vehicleModel, ')
          ..write('amount: $amount, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    partTitleNormalized,
    vehicleModel,
    amount,
    repairOrderId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartPriceHistoryRow &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.partTitleNormalized == this.partTitleNormalized &&
          other.vehicleModel == this.vehicleModel &&
          other.amount == this.amount &&
          other.repairOrderId == this.repairOrderId &&
          other.createdAt == this.createdAt);
}

class PartPriceHistoryCompanion extends UpdateCompanion<PartPriceHistoryRow> {
  final Value<String> id;
  final Value<String?> partId;
  final Value<String> partTitleNormalized;
  final Value<String?> vehicleModel;
  final Value<int> amount;
  final Value<String?> repairOrderId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PartPriceHistoryCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.partTitleNormalized = const Value.absent(),
    this.vehicleModel = const Value.absent(),
    this.amount = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartPriceHistoryCompanion.insert({
    required String id,
    this.partId = const Value.absent(),
    required String partTitleNormalized,
    this.vehicleModel = const Value.absent(),
    required int amount,
    this.repairOrderId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       partTitleNormalized = Value(partTitleNormalized),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<PartPriceHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? partId,
    Expression<String>? partTitleNormalized,
    Expression<String>? vehicleModel,
    Expression<int>? amount,
    Expression<String>? repairOrderId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (partTitleNormalized != null)
        'part_title_normalized': partTitleNormalized,
      if (vehicleModel != null) 'vehicle_model': vehicleModel,
      if (amount != null) 'amount': amount,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartPriceHistoryCompanion copyWith({
    Value<String>? id,
    Value<String?>? partId,
    Value<String>? partTitleNormalized,
    Value<String?>? vehicleModel,
    Value<int>? amount,
    Value<String?>? repairOrderId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PartPriceHistoryCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      partTitleNormalized: partTitleNormalized ?? this.partTitleNormalized,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      amount: amount ?? this.amount,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (partTitleNormalized.present) {
      map['part_title_normalized'] = Variable<String>(
        partTitleNormalized.value,
      );
    }
    if (vehicleModel.present) {
      map['vehicle_model'] = Variable<String>(vehicleModel.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartPriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('partTitleNormalized: $partTitleNormalized, ')
          ..write('vehicleModel: $vehicleModel, ')
          ..write('amount: $amount, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueMileageMeta = const VerificationMeta(
    'dueMileage',
  );
  @override
  late final GeneratedColumn<int> dueMileage = GeneratedColumn<int>(
    'due_mileage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNotifiedAtMeta = const VerificationMeta(
    'lastNotifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastNotifiedAt =
      GeneratedColumn<DateTime>(
        'last_notified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastNotificationKindMeta =
      const VerificationMeta('lastNotificationKind');
  @override
  late final GeneratedColumn<String> lastNotificationKind =
      GeneratedColumn<String>(
        'last_notification_kind',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalMileageMeta = const VerificationMeta(
    'intervalMileage',
  );
  @override
  late final GeneratedColumn<int> intervalMileage = GeneratedColumn<int>(
    'interval_mileage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    repairOrderId,
    title,
    dueDate,
    dueMileage,
    status,
    createdAt,
    lastNotifiedAt,
    lastNotificationKind,
    intervalDays,
    intervalMileage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_mileage')) {
      context.handle(
        _dueMileageMeta,
        dueMileage.isAcceptableOrUnknown(data['due_mileage']!, _dueMileageMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_notified_at')) {
      context.handle(
        _lastNotifiedAtMeta,
        lastNotifiedAt.isAcceptableOrUnknown(
          data['last_notified_at']!,
          _lastNotifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_notification_kind')) {
      context.handle(
        _lastNotificationKindMeta,
        lastNotificationKind.isAcceptableOrUnknown(
          data['last_notification_kind']!,
          _lastNotificationKindMeta,
        ),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('interval_mileage')) {
      context.handle(
        _intervalMileageMeta,
        intervalMileage.isAcceptableOrUnknown(
          data['interval_mileage']!,
          _intervalMileageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueMileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_mileage'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastNotifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_notified_at'],
      ),
      lastNotificationKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_notification_kind'],
      ),
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      ),
      intervalMileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_mileage'],
      ),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String vehicleId;
  final String? repairOrderId;
  final String title;
  final DateTime? dueDate;
  final int? dueMileage;
  final String status;
  final DateTime createdAt;

  /// آخرین زمان ارسال اعلان (برای جلوگیری از تکرار).
  final DateTime? lastNotifiedAt;

  /// نوع آخرین اعلان: date | mileage
  final String? lastNotificationKind;
  final int? intervalDays;
  final int? intervalMileage;
  const ReminderRow({
    required this.id,
    required this.vehicleId,
    this.repairOrderId,
    required this.title,
    this.dueDate,
    this.dueMileage,
    required this.status,
    required this.createdAt,
    this.lastNotifiedAt,
    this.lastNotificationKind,
    this.intervalDays,
    this.intervalMileage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || repairOrderId != null) {
      map['repair_order_id'] = Variable<String>(repairOrderId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueMileage != null) {
      map['due_mileage'] = Variable<int>(dueMileage);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastNotifiedAt != null) {
      map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt);
    }
    if (!nullToAbsent || lastNotificationKind != null) {
      map['last_notification_kind'] = Variable<String>(lastNotificationKind);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || intervalMileage != null) {
      map['interval_mileage'] = Variable<int>(intervalMileage);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      repairOrderId: repairOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(repairOrderId),
      title: Value(title),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueMileage: dueMileage == null && nullToAbsent
          ? const Value.absent()
          : Value(dueMileage),
      status: Value(status),
      createdAt: Value(createdAt),
      lastNotifiedAt: lastNotifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotifiedAt),
      lastNotificationKind: lastNotificationKind == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNotificationKind),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      intervalMileage: intervalMileage == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMileage),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      repairOrderId: serializer.fromJson<String?>(json['repairOrderId']),
      title: serializer.fromJson<String>(json['title']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueMileage: serializer.fromJson<int?>(json['dueMileage']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastNotifiedAt: serializer.fromJson<DateTime?>(json['lastNotifiedAt']),
      lastNotificationKind: serializer.fromJson<String?>(
        json['lastNotificationKind'],
      ),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      intervalMileage: serializer.fromJson<int?>(json['intervalMileage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'repairOrderId': serializer.toJson<String?>(repairOrderId),
      'title': serializer.toJson<String>(title),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueMileage': serializer.toJson<int?>(dueMileage),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastNotifiedAt': serializer.toJson<DateTime?>(lastNotifiedAt),
      'lastNotificationKind': serializer.toJson<String?>(lastNotificationKind),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'intervalMileage': serializer.toJson<int?>(intervalMileage),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? vehicleId,
    Value<String?> repairOrderId = const Value.absent(),
    String? title,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<int?> dueMileage = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?> lastNotifiedAt = const Value.absent(),
    Value<String?> lastNotificationKind = const Value.absent(),
    Value<int?> intervalDays = const Value.absent(),
    Value<int?> intervalMileage = const Value.absent(),
  }) => ReminderRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    repairOrderId: repairOrderId.present
        ? repairOrderId.value
        : this.repairOrderId,
    title: title ?? this.title,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueMileage: dueMileage.present ? dueMileage.value : this.dueMileage,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    lastNotifiedAt: lastNotifiedAt.present
        ? lastNotifiedAt.value
        : this.lastNotifiedAt,
    lastNotificationKind: lastNotificationKind.present
        ? lastNotificationKind.value
        : this.lastNotificationKind,
    intervalDays: intervalDays.present ? intervalDays.value : this.intervalDays,
    intervalMileage: intervalMileage.present
        ? intervalMileage.value
        : this.intervalMileage,
  );
  ReminderRow copyWithCompanion(RemindersCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      title: data.title.present ? data.title.value : this.title,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueMileage: data.dueMileage.present
          ? data.dueMileage.value
          : this.dueMileage,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastNotifiedAt: data.lastNotifiedAt.present
          ? data.lastNotifiedAt.value
          : this.lastNotifiedAt,
      lastNotificationKind: data.lastNotificationKind.present
          ? data.lastNotificationKind.value
          : this.lastNotificationKind,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      intervalMileage: data.intervalMileage.present
          ? data.intervalMileage.value
          : this.intervalMileage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueMileage: $dueMileage, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('lastNotificationKind: $lastNotificationKind, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('intervalMileage: $intervalMileage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    repairOrderId,
    title,
    dueDate,
    dueMileage,
    status,
    createdAt,
    lastNotifiedAt,
    lastNotificationKind,
    intervalDays,
    intervalMileage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.repairOrderId == this.repairOrderId &&
          other.title == this.title &&
          other.dueDate == this.dueDate &&
          other.dueMileage == this.dueMileage &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.lastNotifiedAt == this.lastNotifiedAt &&
          other.lastNotificationKind == this.lastNotificationKind &&
          other.intervalDays == this.intervalDays &&
          other.intervalMileage == this.intervalMileage);
}

class RemindersCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String?> repairOrderId;
  final Value<String> title;
  final Value<DateTime?> dueDate;
  final Value<int?> dueMileage;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastNotifiedAt;
  final Value<String?> lastNotificationKind;
  final Value<int?> intervalDays;
  final Value<int?> intervalMileage;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueMileage = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastNotifiedAt = const Value.absent(),
    this.lastNotificationKind = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.intervalMileage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String vehicleId,
    this.repairOrderId = const Value.absent(),
    required String title,
    this.dueDate = const Value.absent(),
    this.dueMileage = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.lastNotifiedAt = const Value.absent(),
    this.lastNotificationKind = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.intervalMileage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       title = Value(title),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? repairOrderId,
    Expression<String>? title,
    Expression<DateTime>? dueDate,
    Expression<int>? dueMileage,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastNotifiedAt,
    Expression<String>? lastNotificationKind,
    Expression<int>? intervalDays,
    Expression<int>? intervalMileage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate,
      if (dueMileage != null) 'due_mileage': dueMileage,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (lastNotifiedAt != null) 'last_notified_at': lastNotifiedAt,
      if (lastNotificationKind != null)
        'last_notification_kind': lastNotificationKind,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (intervalMileage != null) 'interval_mileage': intervalMileage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String?>? repairOrderId,
    Value<String>? title,
    Value<DateTime?>? dueDate,
    Value<int?>? dueMileage,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastNotifiedAt,
    Value<String?>? lastNotificationKind,
    Value<int?>? intervalDays,
    Value<int?>? intervalMileage,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      dueMileage: dueMileage ?? this.dueMileage,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
      lastNotificationKind: lastNotificationKind ?? this.lastNotificationKind,
      intervalDays: intervalDays ?? this.intervalDays,
      intervalMileage: intervalMileage ?? this.intervalMileage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueMileage.present) {
      map['due_mileage'] = Variable<int>(dueMileage.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastNotifiedAt.present) {
      map['last_notified_at'] = Variable<DateTime>(lastNotifiedAt.value);
    }
    if (lastNotificationKind.present) {
      map['last_notification_kind'] = Variable<String>(
        lastNotificationKind.value,
      );
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (intervalMileage.present) {
      map['interval_mileage'] = Variable<int>(intervalMileage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueMileage: $dueMileage, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastNotifiedAt: $lastNotifiedAt, ')
          ..write('lastNotificationKind: $lastNotificationKind, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('intervalMileage: $intervalMileage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentTransactionsTable extends PaymentTransactions
    with TableInfo<$PaymentTransactionsTable, PaymentTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackingCodeMeta = const VerificationMeta(
    'trackingCode',
  );
  @override
  late final GeneratedColumn<String> trackingCode = GeneratedColumn<String>(
    'tracking_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairOrderId,
    amount,
    paidAt,
    method,
    note,
    trackingCode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repairOrderIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('tracking_code')) {
      context.handle(
        _trackingCodeMeta,
        trackingCode.isAcceptableOrUnknown(
          data['tracking_code']!,
          _trackingCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      trackingCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentTransactionsTable createAlias(String alias) {
    return $PaymentTransactionsTable(attachedDatabase, alias);
  }
}

class PaymentTransactionRow extends DataClass
    implements Insertable<PaymentTransactionRow> {
  final String id;
  final String repairOrderId;
  final int amount;
  final DateTime paidAt;
  final String method;
  final String? note;
  final String? trackingCode;
  final DateTime createdAt;
  const PaymentTransactionRow({
    required this.id,
    required this.repairOrderId,
    required this.amount,
    required this.paidAt,
    required this.method,
    this.note,
    this.trackingCode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_order_id'] = Variable<String>(repairOrderId);
    map['amount'] = Variable<int>(amount);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || trackingCode != null) {
      map['tracking_code'] = Variable<String>(trackingCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentTransactionsCompanion toCompanion(bool nullToAbsent) {
    return PaymentTransactionsCompanion(
      id: Value(id),
      repairOrderId: Value(repairOrderId),
      amount: Value(amount),
      paidAt: Value(paidAt),
      method: Value(method),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      trackingCode: trackingCode == null && nullToAbsent
          ? const Value.absent()
          : Value(trackingCode),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      repairOrderId: serializer.fromJson<String>(json['repairOrderId']),
      amount: serializer.fromJson<int>(json['amount']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      method: serializer.fromJson<String>(json['method']),
      note: serializer.fromJson<String?>(json['note']),
      trackingCode: serializer.fromJson<String?>(json['trackingCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairOrderId': serializer.toJson<String>(repairOrderId),
      'amount': serializer.toJson<int>(amount),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'method': serializer.toJson<String>(method),
      'note': serializer.toJson<String?>(note),
      'trackingCode': serializer.toJson<String?>(trackingCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentTransactionRow copyWith({
    String? id,
    String? repairOrderId,
    int? amount,
    DateTime? paidAt,
    String? method,
    Value<String?> note = const Value.absent(),
    Value<String?> trackingCode = const Value.absent(),
    DateTime? createdAt,
  }) => PaymentTransactionRow(
    id: id ?? this.id,
    repairOrderId: repairOrderId ?? this.repairOrderId,
    amount: amount ?? this.amount,
    paidAt: paidAt ?? this.paidAt,
    method: method ?? this.method,
    note: note.present ? note.value : this.note,
    trackingCode: trackingCode.present ? trackingCode.value : this.trackingCode,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentTransactionRow copyWithCompanion(PaymentTransactionsCompanion data) {
    return PaymentTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      method: data.method.present ? data.method.value : this.method,
      note: data.note.present ? data.note.value : this.note,
      trackingCode: data.trackingCode.present
          ? data.trackingCode.value
          : this.trackingCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentTransactionRow(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('amount: $amount, ')
          ..write('paidAt: $paidAt, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('trackingCode: $trackingCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repairOrderId,
    amount,
    paidAt,
    method,
    note,
    trackingCode,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentTransactionRow &&
          other.id == this.id &&
          other.repairOrderId == this.repairOrderId &&
          other.amount == this.amount &&
          other.paidAt == this.paidAt &&
          other.method == this.method &&
          other.note == this.note &&
          other.trackingCode == this.trackingCode &&
          other.createdAt == this.createdAt);
}

class PaymentTransactionsCompanion
    extends UpdateCompanion<PaymentTransactionRow> {
  final Value<String> id;
  final Value<String> repairOrderId;
  final Value<int> amount;
  final Value<DateTime> paidAt;
  final Value<String> method;
  final Value<String?> note;
  final Value<String?> trackingCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentTransactionsCompanion({
    this.id = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.trackingCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentTransactionsCompanion.insert({
    required String id,
    required String repairOrderId,
    required int amount,
    required DateTime paidAt,
    required String method,
    this.note = const Value.absent(),
    this.trackingCode = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairOrderId = Value(repairOrderId),
       amount = Value(amount),
       paidAt = Value(paidAt),
       method = Value(method),
       createdAt = Value(createdAt);
  static Insertable<PaymentTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? repairOrderId,
    Expression<int>? amount,
    Expression<DateTime>? paidAt,
    Expression<String>? method,
    Expression<String>? note,
    Expression<String>? trackingCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (amount != null) 'amount': amount,
      if (paidAt != null) 'paid_at': paidAt,
      if (method != null) 'method': method,
      if (note != null) 'note': note,
      if (trackingCode != null) 'tracking_code': trackingCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? repairOrderId,
    Value<int>? amount,
    Value<DateTime>? paidAt,
    Value<String>? method,
    Value<String?>? note,
    Value<String?>? trackingCode,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentTransactionsCompanion(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
      method: method ?? this.method,
      note: note ?? this.note,
      trackingCode: trackingCode ?? this.trackingCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (trackingCode.present) {
      map['tracking_code'] = Variable<String>(trackingCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('amount: $amount, ')
          ..write('paidAt: $paidAt, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('trackingCode: $trackingCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepairStatusHistoriesTable extends RepairStatusHistories
    with TableInfo<$RepairStatusHistoriesTable, RepairStatusHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepairStatusHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairOrderId,
    fromStatus,
    toStatus,
    changedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repair_status_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepairStatusHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repairOrderIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepairStatusHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepairStatusHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      ),
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $RepairStatusHistoriesTable createAlias(String alias) {
    return $RepairStatusHistoriesTable(attachedDatabase, alias);
  }
}

class RepairStatusHistoryRow extends DataClass
    implements Insertable<RepairStatusHistoryRow> {
  final String id;
  final String repairOrderId;
  final String? fromStatus;
  final String toStatus;
  final DateTime changedAt;
  final String? note;
  const RepairStatusHistoryRow({
    required this.id,
    required this.repairOrderId,
    this.fromStatus,
    required this.toStatus,
    required this.changedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_order_id'] = Variable<String>(repairOrderId);
    if (!nullToAbsent || fromStatus != null) {
      map['from_status'] = Variable<String>(fromStatus);
    }
    map['to_status'] = Variable<String>(toStatus);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  RepairStatusHistoriesCompanion toCompanion(bool nullToAbsent) {
    return RepairStatusHistoriesCompanion(
      id: Value(id),
      repairOrderId: Value(repairOrderId),
      fromStatus: fromStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(fromStatus),
      toStatus: Value(toStatus),
      changedAt: Value(changedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory RepairStatusHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepairStatusHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      repairOrderId: serializer.fromJson<String>(json['repairOrderId']),
      fromStatus: serializer.fromJson<String?>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairOrderId': serializer.toJson<String>(repairOrderId),
      'fromStatus': serializer.toJson<String?>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  RepairStatusHistoryRow copyWith({
    String? id,
    String? repairOrderId,
    Value<String?> fromStatus = const Value.absent(),
    String? toStatus,
    DateTime? changedAt,
    Value<String?> note = const Value.absent(),
  }) => RepairStatusHistoryRow(
    id: id ?? this.id,
    repairOrderId: repairOrderId ?? this.repairOrderId,
    fromStatus: fromStatus.present ? fromStatus.value : this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    changedAt: changedAt ?? this.changedAt,
    note: note.present ? note.value : this.note,
  );
  RepairStatusHistoryRow copyWithCompanion(
    RepairStatusHistoriesCompanion data,
  ) {
    return RepairStatusHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepairStatusHistoryRow(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedAt: $changedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, repairOrderId, fromStatus, toStatus, changedAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepairStatusHistoryRow &&
          other.id == this.id &&
          other.repairOrderId == this.repairOrderId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.changedAt == this.changedAt &&
          other.note == this.note);
}

class RepairStatusHistoriesCompanion
    extends UpdateCompanion<RepairStatusHistoryRow> {
  final Value<String> id;
  final Value<String> repairOrderId;
  final Value<String?> fromStatus;
  final Value<String> toStatus;
  final Value<DateTime> changedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const RepairStatusHistoriesCompanion({
    this.id = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepairStatusHistoriesCompanion.insert({
    required String id,
    required String repairOrderId,
    this.fromStatus = const Value.absent(),
    required String toStatus,
    required DateTime changedAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairOrderId = Value(repairOrderId),
       toStatus = Value(toStatus),
       changedAt = Value(changedAt);
  static Insertable<RepairStatusHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? repairOrderId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<DateTime>? changedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (changedAt != null) 'changed_at': changedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepairStatusHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? repairOrderId,
    Value<String?>? fromStatus,
    Value<String>? toStatus,
    Value<DateTime>? changedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return RepairStatusHistoriesCompanion(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedAt: changedAt ?? this.changedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepairStatusHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedAt: $changedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehicleMileageLogsTable extends VehicleMileageLogs
    with TableInfo<$VehicleMileageLogsTable, VehicleMileageLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehicleMileageLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _mileageMeta = const VerificationMeta(
    'mileage',
  );
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
    'mileage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    repairOrderId,
    mileage,
    recordedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicle_mileage_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleMileageLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('mileage')) {
      context.handle(
        _mileageMeta,
        mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta),
      );
    } else if (isInserting) {
      context.missing(_mileageMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleMileageLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleMileageLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      ),
      mileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mileage'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $VehicleMileageLogsTable createAlias(String alias) {
    return $VehicleMileageLogsTable(attachedDatabase, alias);
  }
}

class VehicleMileageLogRow extends DataClass
    implements Insertable<VehicleMileageLogRow> {
  final String id;
  final String vehicleId;
  final String? repairOrderId;
  final int mileage;
  final DateTime recordedAt;
  final String? note;
  const VehicleMileageLogRow({
    required this.id,
    required this.vehicleId,
    this.repairOrderId,
    required this.mileage,
    required this.recordedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || repairOrderId != null) {
      map['repair_order_id'] = Variable<String>(repairOrderId);
    }
    map['mileage'] = Variable<int>(mileage);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  VehicleMileageLogsCompanion toCompanion(bool nullToAbsent) {
    return VehicleMileageLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      repairOrderId: repairOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(repairOrderId),
      mileage: Value(mileage),
      recordedAt: Value(recordedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory VehicleMileageLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleMileageLogRow(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      repairOrderId: serializer.fromJson<String?>(json['repairOrderId']),
      mileage: serializer.fromJson<int>(json['mileage']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'repairOrderId': serializer.toJson<String?>(repairOrderId),
      'mileage': serializer.toJson<int>(mileage),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  VehicleMileageLogRow copyWith({
    String? id,
    String? vehicleId,
    Value<String?> repairOrderId = const Value.absent(),
    int? mileage,
    DateTime? recordedAt,
    Value<String?> note = const Value.absent(),
  }) => VehicleMileageLogRow(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    repairOrderId: repairOrderId.present
        ? repairOrderId.value
        : this.repairOrderId,
    mileage: mileage ?? this.mileage,
    recordedAt: recordedAt ?? this.recordedAt,
    note: note.present ? note.value : this.note,
  );
  VehicleMileageLogRow copyWithCompanion(VehicleMileageLogsCompanion data) {
    return VehicleMileageLogRow(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleMileageLogRow(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('mileage: $mileage, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vehicleId, repairOrderId, mileage, recordedAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleMileageLogRow &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.repairOrderId == this.repairOrderId &&
          other.mileage == this.mileage &&
          other.recordedAt == this.recordedAt &&
          other.note == this.note);
}

class VehicleMileageLogsCompanion
    extends UpdateCompanion<VehicleMileageLogRow> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String?> repairOrderId;
  final Value<int> mileage;
  final Value<DateTime> recordedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const VehicleMileageLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.mileage = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehicleMileageLogsCompanion.insert({
    required String id,
    required String vehicleId,
    this.repairOrderId = const Value.absent(),
    required int mileage,
    required DateTime recordedAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       mileage = Value(mileage),
       recordedAt = Value(recordedAt);
  static Insertable<VehicleMileageLogRow> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? repairOrderId,
    Expression<int>? mileage,
    Expression<DateTime>? recordedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (mileage != null) 'mileage': mileage,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehicleMileageLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String?>? repairOrderId,
    Value<int>? mileage,
    Value<DateTime>? recordedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return VehicleMileageLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      mileage: mileage ?? this.mileage,
      recordedAt: recordedAt ?? this.recordedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehicleMileageLogsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('mileage: $mileage, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssistantMessagesTable extends AssistantMessages
    with TableInfo<$AssistantMessagesTable, AssistantMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssistantMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repairOrderIdMeta = const VerificationMeta(
    'repairOrderId',
  );
  @override
  late final GeneratedColumn<String> repairOrderId = GeneratedColumn<String>(
    'repair_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES repair_orders (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repairOrderId,
    role,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assistant_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssistantMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repair_order_id')) {
      context.handle(
        _repairOrderIdMeta,
        repairOrderId.isAcceptableOrUnknown(
          data['repair_order_id']!,
          _repairOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repairOrderIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssistantMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssistantMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repairOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repair_order_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AssistantMessagesTable createAlias(String alias) {
    return $AssistantMessagesTable(attachedDatabase, alias);
  }
}

class AssistantMessageRow extends DataClass
    implements Insertable<AssistantMessageRow> {
  final String id;
  final String repairOrderId;

  /// user | assistant
  final String role;

  /// متن سؤال کاربر یا JSON پاسخ ساخت‌یافته
  final String content;
  final DateTime createdAt;
  const AssistantMessageRow({
    required this.id,
    required this.repairOrderId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repair_order_id'] = Variable<String>(repairOrderId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AssistantMessagesCompanion toCompanion(bool nullToAbsent) {
    return AssistantMessagesCompanion(
      id: Value(id),
      repairOrderId: Value(repairOrderId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory AssistantMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssistantMessageRow(
      id: serializer.fromJson<String>(json['id']),
      repairOrderId: serializer.fromJson<String>(json['repairOrderId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repairOrderId': serializer.toJson<String>(repairOrderId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AssistantMessageRow copyWith({
    String? id,
    String? repairOrderId,
    String? role,
    String? content,
    DateTime? createdAt,
  }) => AssistantMessageRow(
    id: id ?? this.id,
    repairOrderId: repairOrderId ?? this.repairOrderId,
    role: role ?? this.role,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  AssistantMessageRow copyWithCompanion(AssistantMessagesCompanion data) {
    return AssistantMessageRow(
      id: data.id.present ? data.id.value : this.id,
      repairOrderId: data.repairOrderId.present
          ? data.repairOrderId.value
          : this.repairOrderId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssistantMessageRow(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, repairOrderId, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssistantMessageRow &&
          other.id == this.id &&
          other.repairOrderId == this.repairOrderId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class AssistantMessagesCompanion extends UpdateCompanion<AssistantMessageRow> {
  final Value<String> id;
  final Value<String> repairOrderId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AssistantMessagesCompanion({
    this.id = const Value.absent(),
    this.repairOrderId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssistantMessagesCompanion.insert({
    required String id,
    required String repairOrderId,
    required String role,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repairOrderId = Value(repairOrderId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<AssistantMessageRow> custom({
    Expression<String>? id,
    Expression<String>? repairOrderId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repairOrderId != null) 'repair_order_id': repairOrderId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssistantMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? repairOrderId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AssistantMessagesCompanion(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repairOrderId.present) {
      map['repair_order_id'] = Variable<String>(repairOrderId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssistantMessagesCompanion(')
          ..write('id: $id, ')
          ..write('repairOrderId: $repairOrderId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkshopsTable workshops = $WorkshopsTable(this);
  late final $BankAccountsTable bankAccounts = $BankAccountsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $ServiceCategoriesTable serviceCategories =
      $ServiceCategoriesTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $RepairOrdersTable repairOrders = $RepairOrdersTable(this);
  late final $RepairServicesTable repairServices = $RepairServicesTable(this);
  late final $RepairPartsTable repairParts = $RepairPartsTable(this);
  late final $PartPriceHistoryTable partPriceHistory = $PartPriceHistoryTable(
    this,
  );
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $PaymentTransactionsTable paymentTransactions =
      $PaymentTransactionsTable(this);
  late final $RepairStatusHistoriesTable repairStatusHistories =
      $RepairStatusHistoriesTable(this);
  late final $VehicleMileageLogsTable vehicleMileageLogs =
      $VehicleMileageLogsTable(this);
  late final $AssistantMessagesTable assistantMessages =
      $AssistantMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workshops,
    bankAccounts,
    customers,
    vehicles,
    serviceCategories,
    parts,
    repairOrders,
    repairServices,
    repairParts,
    partPriceHistory,
    reminders,
    paymentTransactions,
    repairStatusHistories,
    vehicleMileageLogs,
    assistantMessages,
  ];
}

typedef $$WorkshopsTableCreateCompanionBuilder =
    WorkshopsCompanion Function({
      required String id,
      required String name,
      Value<String?> mechanicName,
      Value<String?> phone,
      Value<String?> address,
      Value<int> morningHour,
      Value<int> afternoonHour,
      Value<int> nightHour,
      Value<bool> enableWhatsApp,
      Value<bool> enableTelegram,
      Value<bool> enableSms,
      Value<bool> includeBankInfoInMessages,
      Value<int> nextInvoiceNumber,
      Value<int?> invoiceSeqYear,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WorkshopsTableUpdateCompanionBuilder =
    WorkshopsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> mechanicName,
      Value<String?> phone,
      Value<String?> address,
      Value<int> morningHour,
      Value<int> afternoonHour,
      Value<int> nightHour,
      Value<bool> enableWhatsApp,
      Value<bool> enableTelegram,
      Value<bool> enableSms,
      Value<bool> includeBankInfoInMessages,
      Value<int> nextInvoiceNumber,
      Value<int?> invoiceSeqYear,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$WorkshopsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkshopsTable, WorkshopRow> {
  $$WorkshopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BankAccountsTable, List<BankAccountRow>>
  _bankAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankAccounts,
    aliasName: 'workshops__id__bank_accounts__workshop_id',
  );

  $$BankAccountsTableProcessedTableManager get bankAccountsRefs {
    final manager = $$BankAccountsTableTableManager(
      $_db,
      $_db.bankAccounts,
    ).filter((f) => f.workshopId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bankAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkshopsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mechanicName => $composableBuilder(
    column: $table.mechanicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get afternoonHour => $composableBuilder(
    column: $table.afternoonHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightHour => $composableBuilder(
    column: $table.nightHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableWhatsApp => $composableBuilder(
    column: $table.enableWhatsApp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableTelegram => $composableBuilder(
    column: $table.enableTelegram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableSms => $composableBuilder(
    column: $table.enableSms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeBankInfoInMessages => $composableBuilder(
    column: $table.includeBankInfoInMessages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextInvoiceNumber => $composableBuilder(
    column: $table.nextInvoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get invoiceSeqYear => $composableBuilder(
    column: $table.invoiceSeqYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bankAccountsRefs(
    Expression<bool> Function($$BankAccountsTableFilterComposer f) f,
  ) {
    final $$BankAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.workshopId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableFilterComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkshopsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mechanicName => $composableBuilder(
    column: $table.mechanicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get afternoonHour => $composableBuilder(
    column: $table.afternoonHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightHour => $composableBuilder(
    column: $table.nightHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableWhatsApp => $composableBuilder(
    column: $table.enableWhatsApp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableTelegram => $composableBuilder(
    column: $table.enableTelegram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableSms => $composableBuilder(
    column: $table.enableSms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeBankInfoInMessages => $composableBuilder(
    column: $table.includeBankInfoInMessages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextInvoiceNumber => $composableBuilder(
    column: $table.nextInvoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invoiceSeqYear => $composableBuilder(
    column: $table.invoiceSeqYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkshopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkshopsTable> {
  $$WorkshopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mechanicName => $composableBuilder(
    column: $table.mechanicName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get afternoonHour => $composableBuilder(
    column: $table.afternoonHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightHour =>
      $composableBuilder(column: $table.nightHour, builder: (column) => column);

  GeneratedColumn<bool> get enableWhatsApp => $composableBuilder(
    column: $table.enableWhatsApp,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableTelegram => $composableBuilder(
    column: $table.enableTelegram,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableSms =>
      $composableBuilder(column: $table.enableSms, builder: (column) => column);

  GeneratedColumn<bool> get includeBankInfoInMessages => $composableBuilder(
    column: $table.includeBankInfoInMessages,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextInvoiceNumber => $composableBuilder(
    column: $table.nextInvoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get invoiceSeqYear => $composableBuilder(
    column: $table.invoiceSeqYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> bankAccountsRefs<T extends Object>(
    Expression<T> Function($$BankAccountsTableAnnotationComposer a) f,
  ) {
    final $$BankAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankAccounts,
      getReferencedColumn: (t) => t.workshopId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.bankAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkshopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkshopsTable,
          WorkshopRow,
          $$WorkshopsTableFilterComposer,
          $$WorkshopsTableOrderingComposer,
          $$WorkshopsTableAnnotationComposer,
          $$WorkshopsTableCreateCompanionBuilder,
          $$WorkshopsTableUpdateCompanionBuilder,
          (WorkshopRow, $$WorkshopsTableReferences),
          WorkshopRow,
          PrefetchHooks Function({bool bankAccountsRefs})
        > {
  $$WorkshopsTableTableManager(_$AppDatabase db, $WorkshopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkshopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkshopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkshopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> mechanicName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> afternoonHour = const Value.absent(),
                Value<int> nightHour = const Value.absent(),
                Value<bool> enableWhatsApp = const Value.absent(),
                Value<bool> enableTelegram = const Value.absent(),
                Value<bool> enableSms = const Value.absent(),
                Value<bool> includeBankInfoInMessages = const Value.absent(),
                Value<int> nextInvoiceNumber = const Value.absent(),
                Value<int?> invoiceSeqYear = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkshopsCompanion(
                id: id,
                name: name,
                mechanicName: mechanicName,
                phone: phone,
                address: address,
                morningHour: morningHour,
                afternoonHour: afternoonHour,
                nightHour: nightHour,
                enableWhatsApp: enableWhatsApp,
                enableTelegram: enableTelegram,
                enableSms: enableSms,
                includeBankInfoInMessages: includeBankInfoInMessages,
                nextInvoiceNumber: nextInvoiceNumber,
                invoiceSeqYear: invoiceSeqYear,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> mechanicName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> afternoonHour = const Value.absent(),
                Value<int> nightHour = const Value.absent(),
                Value<bool> enableWhatsApp = const Value.absent(),
                Value<bool> enableTelegram = const Value.absent(),
                Value<bool> enableSms = const Value.absent(),
                Value<bool> includeBankInfoInMessages = const Value.absent(),
                Value<int> nextInvoiceNumber = const Value.absent(),
                Value<int?> invoiceSeqYear = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkshopsCompanion.insert(
                id: id,
                name: name,
                mechanicName: mechanicName,
                phone: phone,
                address: address,
                morningHour: morningHour,
                afternoonHour: afternoonHour,
                nightHour: nightHour,
                enableWhatsApp: enableWhatsApp,
                enableTelegram: enableTelegram,
                enableSms: enableSms,
                includeBankInfoInMessages: includeBankInfoInMessages,
                nextInvoiceNumber: nextInvoiceNumber,
                invoiceSeqYear: invoiceSeqYear,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkshopsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bankAccountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bankAccountsRefs) db.bankAccounts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bankAccountsRefs)
                    await $_getPrefetchedData<
                      WorkshopRow,
                      $WorkshopsTable,
                      BankAccountRow
                    >(
                      currentTable: table,
                      referencedTable: $$WorkshopsTableReferences
                          ._bankAccountsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkshopsTableReferences(
                            db,
                            table,
                            p0,
                          ).bankAccountsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workshopId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkshopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkshopsTable,
      WorkshopRow,
      $$WorkshopsTableFilterComposer,
      $$WorkshopsTableOrderingComposer,
      $$WorkshopsTableAnnotationComposer,
      $$WorkshopsTableCreateCompanionBuilder,
      $$WorkshopsTableUpdateCompanionBuilder,
      (WorkshopRow, $$WorkshopsTableReferences),
      WorkshopRow,
      PrefetchHooks Function({bool bankAccountsRefs})
    >;
typedef $$BankAccountsTableCreateCompanionBuilder =
    BankAccountsCompanion Function({
      required String id,
      required String workshopId,
      required String bankName,
      Value<String?> accountHolderName,
      Value<String?> accountNumber,
      Value<String?> cardNumber,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BankAccountsTableUpdateCompanionBuilder =
    BankAccountsCompanion Function({
      Value<String> id,
      Value<String> workshopId,
      Value<String> bankName,
      Value<String?> accountHolderName,
      Value<String?> accountNumber,
      Value<String?> cardNumber,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BankAccountsTableReferences
    extends BaseReferences<_$AppDatabase, $BankAccountsTable, BankAccountRow> {
  $$BankAccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkshopsTable _workshopIdTable(_$AppDatabase db) =>
      db.workshops.createAlias('bank_accounts__workshop_id__workshops__id');

  $$WorkshopsTableProcessedTableManager get workshopId {
    final $_column = $_itemColumn<String>('workshop_id')!;

    final manager = $$WorkshopsTableTableManager(
      $_db,
      $_db.workshops,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workshopIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BankAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountHolderName => $composableBuilder(
    column: $table.accountHolderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkshopsTableFilterComposer get workshopId {
    final $$WorkshopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workshopId,
      referencedTable: $db.workshops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkshopsTableFilterComposer(
            $db: $db,
            $table: $db.workshops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountHolderName => $composableBuilder(
    column: $table.accountHolderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkshopsTableOrderingComposer get workshopId {
    final $$WorkshopsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workshopId,
      referencedTable: $db.workshops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkshopsTableOrderingComposer(
            $db: $db,
            $table: $db.workshops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankAccountsTable> {
  $$BankAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get accountHolderName => $composableBuilder(
    column: $table.accountHolderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardNumber => $composableBuilder(
    column: $table.cardNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorkshopsTableAnnotationComposer get workshopId {
    final $$WorkshopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workshopId,
      referencedTable: $db.workshops,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkshopsTableAnnotationComposer(
            $db: $db,
            $table: $db.workshops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankAccountsTable,
          BankAccountRow,
          $$BankAccountsTableFilterComposer,
          $$BankAccountsTableOrderingComposer,
          $$BankAccountsTableAnnotationComposer,
          $$BankAccountsTableCreateCompanionBuilder,
          $$BankAccountsTableUpdateCompanionBuilder,
          (BankAccountRow, $$BankAccountsTableReferences),
          BankAccountRow,
          PrefetchHooks Function({bool workshopId})
        > {
  $$BankAccountsTableTableManager(_$AppDatabase db, $BankAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workshopId = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String?> accountHolderName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> cardNumber = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BankAccountsCompanion(
                id: id,
                workshopId: workshopId,
                bankName: bankName,
                accountHolderName: accountHolderName,
                accountNumber: accountNumber,
                cardNumber: cardNumber,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workshopId,
                required String bankName,
                Value<String?> accountHolderName = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> cardNumber = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BankAccountsCompanion.insert(
                id: id,
                workshopId: workshopId,
                bankName: bankName,
                accountHolderName: accountHolderName,
                accountNumber: accountNumber,
                cardNumber: cardNumber,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BankAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workshopId = false}) {
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
                    if (workshopId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workshopId,
                                referencedTable: $$BankAccountsTableReferences
                                    ._workshopIdTable(db),
                                referencedColumn: $$BankAccountsTableReferences
                                    ._workshopIdTable(db)
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

typedef $$BankAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankAccountsTable,
      BankAccountRow,
      $$BankAccountsTableFilterComposer,
      $$BankAccountsTableOrderingComposer,
      $$BankAccountsTableAnnotationComposer,
      $$BankAccountsTableCreateCompanionBuilder,
      $$BankAccountsTableUpdateCompanionBuilder,
      (BankAccountRow, $$BankAccountsTableReferences),
      BankAccountRow,
      PrefetchHooks Function({bool workshopId})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      Value<String?> fullName,
      Value<String?> phone,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String?> fullName,
      Value<String?> phone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerRow> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiclesTable, List<VehicleRow>>
  _vehiclesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: 'customers__id__vehicles__customer_id',
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepairOrdersTable, List<RepairOrderRow>>
  _repairOrdersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repairOrders,
    aliasName: 'customers__id__repair_orders__customer_id',
  );

  $$RepairOrdersTableProcessedTableManager get repairOrdersRefs {
    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_repairOrdersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.customerId,
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

  Expression<bool> repairOrdersRefs(
    Expression<bool> Function($$RepairOrdersTableFilterComposer f) f,
  ) {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.customerId,
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

  Expression<T> repairOrdersRefs<T extends Object>(
    Expression<T> Function($$RepairOrdersTableAnnotationComposer a) f,
  ) {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRow,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerRow, $$CustomersTableReferences),
          CustomerRow,
          PrefetchHooks Function({bool vehiclesRefs, bool repairOrdersRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                fullName: fullName,
                phone: phone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> fullName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                fullName: fullName,
                phone: phone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehiclesRefs = false, repairOrdersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (vehiclesRefs) db.vehicles,
                    if (repairOrdersRefs) db.repairOrders,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (vehiclesRefs)
                        await $_getPrefetchedData<
                          CustomerRow,
                          $CustomersTable,
                          VehicleRow
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._vehiclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).vehiclesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (repairOrdersRefs)
                        await $_getPrefetchedData<
                          CustomerRow,
                          $CustomersTable,
                          RepairOrderRow
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._repairOrdersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).repairOrdersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
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

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRow,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerRow, $$CustomersTableReferences),
      CustomerRow,
      PrefetchHooks Function({bool vehiclesRefs, bool repairOrdersRefs})
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      Value<String?> customerId,
      required String plateNormalized,
      required String plateDisplay,
      Value<String?> manufacturer,
      Value<String?> model,
      Value<String?> trim,
      Value<int?> productionYear,
      Value<int?> lastMileage,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<String> plateNormalized,
      Value<String> plateDisplay,
      Value<String?> manufacturer,
      Value<String?> model,
      Value<String?> trim,
      Value<int?> productionYear,
      Value<int?> lastMileage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, VehicleRow> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('vehicles__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RepairOrdersTable, List<RepairOrderRow>>
  _repairOrdersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repairOrders,
    aliasName: 'vehicles__id__repair_orders__vehicle_id',
  );

  $$RepairOrdersTableProcessedTableManager get repairOrdersRefs {
    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_repairOrdersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<ReminderRow>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'vehicles__id__reminders__vehicle_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $VehicleMileageLogsTable,
    List<VehicleMileageLogRow>
  >
  _vehicleMileageLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vehicleMileageLogs,
        aliasName: 'vehicles__id__vehicle_mileage_logs__vehicle_id',
      );

  $$VehicleMileageLogsTableProcessedTableManager get vehicleMileageLogsRefs {
    final manager = $$VehicleMileageLogsTableTableManager(
      $_db,
      $_db.vehicleMileageLogs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vehicleMileageLogsRefsTable($_db),
    );
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plateNormalized => $composableBuilder(
    column: $table.plateNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plateDisplay => $composableBuilder(
    column: $table.plateDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastMileage => $composableBuilder(
    column: $table.lastMileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> repairOrdersRefs(
    Expression<bool> Function($$RepairOrdersTableFilterComposer f) f,
  ) {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vehicleMileageLogsRefs(
    Expression<bool> Function($$VehicleMileageLogsTableFilterComposer f) f,
  ) {
    final $$VehicleMileageLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicleMileageLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehicleMileageLogsTableFilterComposer(
            $db: $db,
            $table: $db.vehicleMileageLogs,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plateNormalized => $composableBuilder(
    column: $table.plateNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plateDisplay => $composableBuilder(
    column: $table.plateDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastMileage => $composableBuilder(
    column: $table.lastMileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plateNormalized => $composableBuilder(
    column: $table.plateNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plateDisplay => $composableBuilder(
    column: $table.plateDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get trim =>
      $composableBuilder(column: $table.trim, builder: (column) => column);

  GeneratedColumn<int> get productionYear => $composableBuilder(
    column: $table.productionYear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastMileage => $composableBuilder(
    column: $table.lastMileage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> repairOrdersRefs<T extends Object>(
    Expression<T> Function($$RepairOrdersTableAnnotationComposer a) f,
  ) {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vehicleMileageLogsRefs<T extends Object>(
    Expression<T> Function($$VehicleMileageLogsTableAnnotationComposer a) f,
  ) {
    final $$VehicleMileageLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vehicleMileageLogs,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VehicleMileageLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.vehicleMileageLogs,
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
          VehicleRow,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (VehicleRow, $$VehiclesTableReferences),
          VehicleRow,
          PrefetchHooks Function({
            bool customerId,
            bool repairOrdersRefs,
            bool remindersRefs,
            bool vehicleMileageLogsRefs,
          })
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
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> plateNormalized = const Value.absent(),
                Value<String> plateDisplay = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                Value<int?> productionYear = const Value.absent(),
                Value<int?> lastMileage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                customerId: customerId,
                plateNormalized: plateNormalized,
                plateDisplay: plateDisplay,
                manufacturer: manufacturer,
                model: model,
                trim: trim,
                productionYear: productionYear,
                lastMileage: lastMileage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required String plateNormalized,
                required String plateDisplay,
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                Value<int?> productionYear = const Value.absent(),
                Value<int?> lastMileage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                customerId: customerId,
                plateNormalized: plateNormalized,
                plateDisplay: plateDisplay,
                manufacturer: manufacturer,
                model: model,
                trim: trim,
                productionYear: productionYear,
                lastMileage: lastMileage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
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
              ({
                customerId = false,
                repairOrdersRefs = false,
                remindersRefs = false,
                vehicleMileageLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (repairOrdersRefs) db.repairOrders,
                    if (remindersRefs) db.reminders,
                    if (vehicleMileageLogsRefs) db.vehicleMileageLogs,
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
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$VehiclesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$VehiclesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (repairOrdersRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          RepairOrderRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._repairOrdersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).repairOrdersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          ReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vehicleMileageLogsRefs)
                        await $_getPrefetchedData<
                          VehicleRow,
                          $VehiclesTable,
                          VehicleMileageLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._vehicleMileageLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).vehicleMileageLogsRefs,
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
      VehicleRow,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (VehicleRow, $$VehiclesTableReferences),
      VehicleRow,
      PrefetchHooks Function({
        bool customerId,
        bool repairOrdersRefs,
        bool remindersRefs,
        bool vehicleMileageLogsRefs,
      })
    >;
typedef $$ServiceCategoriesTableCreateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      required String id,
      required String title,
      required String iconKey,
      required int sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$ServiceCategoriesTableUpdateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> iconKey,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$ServiceCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ServiceCategoriesTable,
          ServiceCategoryRow
        > {
  $$ServiceCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$PartsTable, List<PartRow>> _partsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.parts,
    aliasName: 'service_categories__id__parts__service_category_id',
  );

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts).filter(
      (f) => f.serviceCategoryId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> partsRefs(
    Expression<bool> Function($$PartsTableFilterComposer f) f,
  ) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.serviceCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> partsRefs<T extends Object>(
    Expression<T> Function($$PartsTableAnnotationComposer a) f,
  ) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.serviceCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceCategoriesTable,
          ServiceCategoryRow,
          $$ServiceCategoriesTableFilterComposer,
          $$ServiceCategoriesTableOrderingComposer,
          $$ServiceCategoriesTableAnnotationComposer,
          $$ServiceCategoriesTableCreateCompanionBuilder,
          $$ServiceCategoriesTableUpdateCompanionBuilder,
          (ServiceCategoryRow, $$ServiceCategoriesTableReferences),
          ServiceCategoryRow,
          PrefetchHooks Function({bool partsRefs})
        > {
  $$ServiceCategoriesTableTableManager(
    _$AppDatabase db,
    $ServiceCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceCategoriesCompanion(
                id: id,
                title: title,
                iconKey: iconKey,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String iconKey,
                required int sortOrder,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceCategoriesCompanion.insert(
                id: id,
                title: title,
                iconKey: iconKey,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partsRefs) db.parts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partsRefs)
                    await $_getPrefetchedData<
                      ServiceCategoryRow,
                      $ServiceCategoriesTable,
                      PartRow
                    >(
                      currentTable: table,
                      referencedTable: $$ServiceCategoriesTableReferences
                          ._partsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ServiceCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).partsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.serviceCategoryId == item.id,
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

typedef $$ServiceCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceCategoriesTable,
      ServiceCategoryRow,
      $$ServiceCategoriesTableFilterComposer,
      $$ServiceCategoriesTableOrderingComposer,
      $$ServiceCategoriesTableAnnotationComposer,
      $$ServiceCategoriesTableCreateCompanionBuilder,
      $$ServiceCategoriesTableUpdateCompanionBuilder,
      (ServiceCategoryRow, $$ServiceCategoriesTableReferences),
      ServiceCategoryRow,
      PrefetchHooks Function({bool partsRefs})
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      required String id,
      required String title,
      required String normalizedTitle,
      Value<String?> serviceCategoryId,
      Value<String?> vehicleModel,
      Value<String?> brand,
      Value<int> usageCount,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> normalizedTitle,
      Value<String?> serviceCategoryId,
      Value<String?> vehicleModel,
      Value<String?> brand,
      Value<int> usageCount,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, PartRow> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceCategoriesTable _serviceCategoryIdTable(_$AppDatabase db) => db
      .serviceCategories
      .createAlias('parts__service_category_id__service_categories__id');

  $$ServiceCategoriesTableProcessedTableManager? get serviceCategoryId {
    final $_column = $_itemColumn<String>('service_category_id');
    if ($_column == null) return null;
    final manager = $$ServiceCategoriesTableTableManager(
      $_db,
      $_db.serviceCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RepairPartsTable, List<RepairPartRow>>
  _repairPartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repairParts,
    aliasName: 'parts__id__repair_parts__part_id',
  );

  $$RepairPartsTableProcessedTableManager get repairPartsRefs {
    final manager = $$RepairPartsTableTableManager(
      $_db,
      $_db.repairParts,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_repairPartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartPriceHistoryTable, List<PartPriceHistoryRow>>
  _partPriceHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partPriceHistory,
    aliasName: 'parts__id__part_price_history__part_id',
  );

  $$PartPriceHistoryTableProcessedTableManager get partPriceHistoryRefs {
    final manager = $$PartPriceHistoryTableTableManager(
      $_db,
      $_db.partPriceHistory,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _partPriceHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceCategoriesTableFilterComposer get serviceCategoryId {
    final $$ServiceCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceCategoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> repairPartsRefs(
    Expression<bool> Function($$RepairPartsTableFilterComposer f) f,
  ) {
    final $$RepairPartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairParts,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairPartsTableFilterComposer(
            $db: $db,
            $table: $db.repairParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partPriceHistoryRefs(
    Expression<bool> Function($$PartPriceHistoryTableFilterComposer f) f,
  ) {
    final $$PartPriceHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partPriceHistory,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartPriceHistoryTableFilterComposer(
            $db: $db,
            $table: $db.partPriceHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceCategoriesTableOrderingComposer get serviceCategoryId {
    final $$ServiceCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceCategoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ServiceCategoriesTableAnnotationComposer get serviceCategoryId {
    final $$ServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.serviceCategoryId,
          referencedTable: $db.serviceCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> repairPartsRefs<T extends Object>(
    Expression<T> Function($$RepairPartsTableAnnotationComposer a) f,
  ) {
    final $$RepairPartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairParts,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairPartsTableAnnotationComposer(
            $db: $db,
            $table: $db.repairParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partPriceHistoryRefs<T extends Object>(
    Expression<T> Function($$PartPriceHistoryTableAnnotationComposer a) f,
  ) {
    final $$PartPriceHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partPriceHistory,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartPriceHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.partPriceHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartsTable,
          PartRow,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (PartRow, $$PartsTableReferences),
          PartRow,
          PrefetchHooks Function({
            bool serviceCategoryId,
            bool repairPartsRefs,
            bool partPriceHistoryRefs,
          })
        > {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> normalizedTitle = const Value.absent(),
                Value<String?> serviceCategoryId = const Value.absent(),
                Value<String?> vehicleModel = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                title: title,
                normalizedTitle: normalizedTitle,
                serviceCategoryId: serviceCategoryId,
                vehicleModel: vehicleModel,
                brand: brand,
                usageCount: usageCount,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String normalizedTitle,
                Value<String?> serviceCategoryId = const Value.absent(),
                Value<String?> vehicleModel = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                title: title,
                normalizedTitle: normalizedTitle,
                serviceCategoryId: serviceCategoryId,
                vehicleModel: vehicleModel,
                brand: brand,
                usageCount: usageCount,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                serviceCategoryId = false,
                repairPartsRefs = false,
                partPriceHistoryRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (repairPartsRefs) db.repairParts,
                    if (partPriceHistoryRefs) db.partPriceHistory,
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
                        if (serviceCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceCategoryId,
                                    referencedTable: $$PartsTableReferences
                                        ._serviceCategoryIdTable(db),
                                    referencedColumn: $$PartsTableReferences
                                        ._serviceCategoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (repairPartsRefs)
                        await $_getPrefetchedData<
                          PartRow,
                          $PartsTable,
                          RepairPartRow
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._repairPartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).repairPartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partPriceHistoryRefs)
                        await $_getPrefetchedData<
                          PartRow,
                          $PartsTable,
                          PartPriceHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._partPriceHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).partPriceHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
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

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartsTable,
      PartRow,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (PartRow, $$PartsTableReferences),
      PartRow,
      PrefetchHooks Function({
        bool serviceCategoryId,
        bool repairPartsRefs,
        bool partPriceHistoryRefs,
      })
    >;
typedef $$RepairOrdersTableCreateCompanionBuilder =
    RepairOrdersCompanion Function({
      required String id,
      required String vehicleId,
      Value<String?> customerId,
      required String status,
      Value<String?> complaintText,
      Value<int?> mileage,
      Value<int> laborAmount,
      Value<int> discountAmount,
      required String paymentStatus,
      Value<int> paidAmount,
      Value<String?> invoiceNumber,
      Value<String?> cancelReason,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deliveredAt,
      Value<int> rowid,
    });
typedef $$RepairOrdersTableUpdateCompanionBuilder =
    RepairOrdersCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String?> customerId,
      Value<String> status,
      Value<String?> complaintText,
      Value<int?> mileage,
      Value<int> laborAmount,
      Value<int> discountAmount,
      Value<String> paymentStatus,
      Value<int> paidAmount,
      Value<String?> invoiceNumber,
      Value<String?> cancelReason,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deliveredAt,
      Value<int> rowid,
    });

final class $$RepairOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $RepairOrdersTable, RepairOrderRow> {
  $$RepairOrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('repair_orders__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

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

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('repair_orders__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RepairServicesTable, List<RepairServiceRow>>
  _repairServicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repairServices,
    aliasName: 'repair_orders__id__repair_services__repair_order_id',
  );

  $$RepairServicesTableProcessedTableManager get repairServicesRefs {
    final manager = $$RepairServicesTableTableManager(
      $_db,
      $_db.repairServices,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_repairServicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepairPartsTable, List<RepairPartRow>>
  _repairPartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repairParts,
    aliasName: 'repair_orders__id__repair_parts__repair_order_id',
  );

  $$RepairPartsTableProcessedTableManager get repairPartsRefs {
    final manager = $$RepairPartsTableTableManager(
      $_db,
      $_db.repairParts,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_repairPartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartPriceHistoryTable, List<PartPriceHistoryRow>>
  _partPriceHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partPriceHistory,
    aliasName: 'repair_orders__id__part_price_history__repair_order_id',
  );

  $$PartPriceHistoryTableProcessedTableManager get partPriceHistoryRefs {
    final manager = $$PartPriceHistoryTableTableManager(
      $_db,
      $_db.partPriceHistory,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _partPriceHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<ReminderRow>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'repair_orders__id__reminders__repair_order_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PaymentTransactionsTable,
    List<PaymentTransactionRow>
  >
  _paymentTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentTransactions,
        aliasName: 'repair_orders__id__payment_transactions__repair_order_id',
      );

  $$PaymentTransactionsTableProcessedTableManager get paymentTransactionsRefs {
    final manager = $$PaymentTransactionsTableTableManager(
      $_db,
      $_db.paymentTransactions,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _paymentTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RepairStatusHistoriesTable,
    List<RepairStatusHistoryRow>
  >
  _repairStatusHistoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.repairStatusHistories,
        aliasName:
            'repair_orders__id__repair_status_histories__repair_order_id',
      );

  $$RepairStatusHistoriesTableProcessedTableManager
  get repairStatusHistoriesRefs {
    final manager = $$RepairStatusHistoriesTableTableManager(
      $_db,
      $_db.repairStatusHistories,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _repairStatusHistoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $VehicleMileageLogsTable,
    List<VehicleMileageLogRow>
  >
  _vehicleMileageLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vehicleMileageLogs,
        aliasName: 'repair_orders__id__vehicle_mileage_logs__repair_order_id',
      );

  $$VehicleMileageLogsTableProcessedTableManager get vehicleMileageLogsRefs {
    final manager = $$VehicleMileageLogsTableTableManager(
      $_db,
      $_db.vehicleMileageLogs,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vehicleMileageLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AssistantMessagesTable, List<AssistantMessageRow>>
  _assistantMessagesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.assistantMessages,
        aliasName: 'repair_orders__id__assistant_messages__repair_order_id',
      );

  $$AssistantMessagesTableProcessedTableManager get assistantMessagesRefs {
    final manager = $$AssistantMessagesTableTableManager(
      $_db,
      $_db.assistantMessages,
    ).filter((f) => f.repairOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _assistantMessagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RepairOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $RepairOrdersTable> {
  $$RepairOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get complaintText => $composableBuilder(
    column: $table.complaintText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get laborAmount => $composableBuilder(
    column: $table.laborAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );

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

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> repairServicesRefs(
    Expression<bool> Function($$RepairServicesTableFilterComposer f) f,
  ) {
    final $$RepairServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairServices,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairServicesTableFilterComposer(
            $db: $db,
            $table: $db.repairServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repairPartsRefs(
    Expression<bool> Function($$RepairPartsTableFilterComposer f) f,
  ) {
    final $$RepairPartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairParts,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairPartsTableFilterComposer(
            $db: $db,
            $table: $db.repairParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partPriceHistoryRefs(
    Expression<bool> Function($$PartPriceHistoryTableFilterComposer f) f,
  ) {
    final $$PartPriceHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partPriceHistory,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartPriceHistoryTableFilterComposer(
            $db: $db,
            $table: $db.partPriceHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentTransactionsRefs(
    Expression<bool> Function($$PaymentTransactionsTableFilterComposer f) f,
  ) {
    final $$PaymentTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentTransactions,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.paymentTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repairStatusHistoriesRefs(
    Expression<bool> Function($$RepairStatusHistoriesTableFilterComposer f) f,
  ) {
    final $$RepairStatusHistoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.repairStatusHistories,
          getReferencedColumn: (t) => t.repairOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RepairStatusHistoriesTableFilterComposer(
                $db: $db,
                $table: $db.repairStatusHistories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> vehicleMileageLogsRefs(
    Expression<bool> Function($$VehicleMileageLogsTableFilterComposer f) f,
  ) {
    final $$VehicleMileageLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicleMileageLogs,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehicleMileageLogsTableFilterComposer(
            $db: $db,
            $table: $db.vehicleMileageLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assistantMessagesRefs(
    Expression<bool> Function($$AssistantMessagesTableFilterComposer f) f,
  ) {
    final $$AssistantMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assistantMessages,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssistantMessagesTableFilterComposer(
            $db: $db,
            $table: $db.assistantMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RepairOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairOrdersTable> {
  $$RepairOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get complaintText => $composableBuilder(
    column: $table.complaintText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get laborAmount => $composableBuilder(
    column: $table.laborAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );

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

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairOrdersTable> {
  $$RepairOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get complaintText => $composableBuilder(
    column: $table.complaintText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<int> get laborAmount => $composableBuilder(
    column: $table.laborAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );

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

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> repairServicesRefs<T extends Object>(
    Expression<T> Function($$RepairServicesTableAnnotationComposer a) f,
  ) {
    final $$RepairServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairServices,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.repairServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> repairPartsRefs<T extends Object>(
    Expression<T> Function($$RepairPartsTableAnnotationComposer a) f,
  ) {
    final $$RepairPartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repairParts,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairPartsTableAnnotationComposer(
            $db: $db,
            $table: $db.repairParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partPriceHistoryRefs<T extends Object>(
    Expression<T> Function($$PartPriceHistoryTableAnnotationComposer a) f,
  ) {
    final $$PartPriceHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partPriceHistory,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartPriceHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.partPriceHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.repairOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentTransactionsRefs<T extends Object>(
    Expression<T> Function($$PaymentTransactionsTableAnnotationComposer a) f,
  ) {
    final $$PaymentTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentTransactions,
          getReferencedColumn: (t) => t.repairOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> repairStatusHistoriesRefs<T extends Object>(
    Expression<T> Function($$RepairStatusHistoriesTableAnnotationComposer a) f,
  ) {
    final $$RepairStatusHistoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.repairStatusHistories,
          getReferencedColumn: (t) => t.repairOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RepairStatusHistoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.repairStatusHistories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> vehicleMileageLogsRefs<T extends Object>(
    Expression<T> Function($$VehicleMileageLogsTableAnnotationComposer a) f,
  ) {
    final $$VehicleMileageLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vehicleMileageLogs,
          getReferencedColumn: (t) => t.repairOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VehicleMileageLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.vehicleMileageLogs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> assistantMessagesRefs<T extends Object>(
    Expression<T> Function($$AssistantMessagesTableAnnotationComposer a) f,
  ) {
    final $$AssistantMessagesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.assistantMessages,
          getReferencedColumn: (t) => t.repairOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AssistantMessagesTableAnnotationComposer(
                $db: $db,
                $table: $db.assistantMessages,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RepairOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairOrdersTable,
          RepairOrderRow,
          $$RepairOrdersTableFilterComposer,
          $$RepairOrdersTableOrderingComposer,
          $$RepairOrdersTableAnnotationComposer,
          $$RepairOrdersTableCreateCompanionBuilder,
          $$RepairOrdersTableUpdateCompanionBuilder,
          (RepairOrderRow, $$RepairOrdersTableReferences),
          RepairOrderRow,
          PrefetchHooks Function({
            bool vehicleId,
            bool customerId,
            bool repairServicesRefs,
            bool repairPartsRefs,
            bool partPriceHistoryRefs,
            bool remindersRefs,
            bool paymentTransactionsRefs,
            bool repairStatusHistoriesRefs,
            bool vehicleMileageLogsRefs,
            bool assistantMessagesRefs,
          })
        > {
  $$RepairOrdersTableTableManager(_$AppDatabase db, $RepairOrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> complaintText = const Value.absent(),
                Value<int?> mileage = const Value.absent(),
                Value<int> laborAmount = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairOrdersCompanion(
                id: id,
                vehicleId: vehicleId,
                customerId: customerId,
                status: status,
                complaintText: complaintText,
                mileage: mileage,
                laborAmount: laborAmount,
                discountAmount: discountAmount,
                paymentStatus: paymentStatus,
                paidAmount: paidAmount,
                invoiceNumber: invoiceNumber,
                cancelReason: cancelReason,
                createdAt: createdAt,
                completedAt: completedAt,
                deliveredAt: deliveredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                Value<String?> customerId = const Value.absent(),
                required String status,
                Value<String?> complaintText = const Value.absent(),
                Value<int?> mileage = const Value.absent(),
                Value<int> laborAmount = const Value.absent(),
                Value<int> discountAmount = const Value.absent(),
                required String paymentStatus,
                Value<int> paidAmount = const Value.absent(),
                Value<String?> invoiceNumber = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairOrdersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                customerId: customerId,
                status: status,
                complaintText: complaintText,
                mileage: mileage,
                laborAmount: laborAmount,
                discountAmount: discountAmount,
                paymentStatus: paymentStatus,
                paidAmount: paidAmount,
                invoiceNumber: invoiceNumber,
                cancelReason: cancelReason,
                createdAt: createdAt,
                completedAt: completedAt,
                deliveredAt: deliveredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepairOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                vehicleId = false,
                customerId = false,
                repairServicesRefs = false,
                repairPartsRefs = false,
                partPriceHistoryRefs = false,
                remindersRefs = false,
                paymentTransactionsRefs = false,
                repairStatusHistoriesRefs = false,
                vehicleMileageLogsRefs = false,
                assistantMessagesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (repairServicesRefs) db.repairServices,
                    if (repairPartsRefs) db.repairParts,
                    if (partPriceHistoryRefs) db.partPriceHistory,
                    if (remindersRefs) db.reminders,
                    if (paymentTransactionsRefs) db.paymentTransactions,
                    if (repairStatusHistoriesRefs) db.repairStatusHistories,
                    if (vehicleMileageLogsRefs) db.vehicleMileageLogs,
                    if (assistantMessagesRefs) db.assistantMessages,
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
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$RepairOrdersTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$RepairOrdersTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$RepairOrdersTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$RepairOrdersTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (repairServicesRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          RepairServiceRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._repairServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).repairServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (repairPartsRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          RepairPartRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._repairPartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).repairPartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partPriceHistoryRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          PartPriceHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._partPriceHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).partPriceHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          ReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentTransactionsRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          PaymentTransactionRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._paymentTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (repairStatusHistoriesRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          RepairStatusHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._repairStatusHistoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).repairStatusHistoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vehicleMileageLogsRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          VehicleMileageLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._vehicleMileageLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).vehicleMileageLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (assistantMessagesRefs)
                        await $_getPrefetchedData<
                          RepairOrderRow,
                          $RepairOrdersTable,
                          AssistantMessageRow
                        >(
                          currentTable: table,
                          referencedTable: $$RepairOrdersTableReferences
                              ._assistantMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RepairOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).assistantMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.repairOrderId == item.id,
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

typedef $$RepairOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairOrdersTable,
      RepairOrderRow,
      $$RepairOrdersTableFilterComposer,
      $$RepairOrdersTableOrderingComposer,
      $$RepairOrdersTableAnnotationComposer,
      $$RepairOrdersTableCreateCompanionBuilder,
      $$RepairOrdersTableUpdateCompanionBuilder,
      (RepairOrderRow, $$RepairOrdersTableReferences),
      RepairOrderRow,
      PrefetchHooks Function({
        bool vehicleId,
        bool customerId,
        bool repairServicesRefs,
        bool repairPartsRefs,
        bool partPriceHistoryRefs,
        bool remindersRefs,
        bool paymentTransactionsRefs,
        bool repairStatusHistoriesRefs,
        bool vehicleMileageLogsRefs,
        bool assistantMessagesRefs,
      })
    >;
typedef $$RepairServicesTableCreateCompanionBuilder =
    RepairServicesCompanion Function({
      required String id,
      required String repairOrderId,
      required String title,
      Value<int> amount,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RepairServicesTableUpdateCompanionBuilder =
    RepairServicesCompanion Function({
      Value<String> id,
      Value<String> repairOrderId,
      Value<String> title,
      Value<int> amount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RepairServicesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RepairServicesTable, RepairServiceRow> {
  $$RepairServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('repair_services__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id')!;

    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepairServicesTableFilterComposer
    extends Composer<_$AppDatabase, $RepairServicesTable> {
  $$RepairServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairServicesTable> {
  $$RepairServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairServicesTable> {
  $$RepairServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairServicesTable,
          RepairServiceRow,
          $$RepairServicesTableFilterComposer,
          $$RepairServicesTableOrderingComposer,
          $$RepairServicesTableAnnotationComposer,
          $$RepairServicesTableCreateCompanionBuilder,
          $$RepairServicesTableUpdateCompanionBuilder,
          (RepairServiceRow, $$RepairServicesTableReferences),
          RepairServiceRow,
          PrefetchHooks Function({bool repairOrderId})
        > {
  $$RepairServicesTableTableManager(
    _$AppDatabase db,
    $RepairServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairOrderId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairServicesCompanion(
                id: id,
                repairOrderId: repairOrderId,
                title: title,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairOrderId,
                required String title,
                Value<int> amount = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RepairServicesCompanion.insert(
                id: id,
                repairOrderId: repairOrderId,
                title: title,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepairServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repairOrderId = false}) {
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
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable: $$RepairServicesTableReferences
                                    ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$RepairServicesTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$RepairServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairServicesTable,
      RepairServiceRow,
      $$RepairServicesTableFilterComposer,
      $$RepairServicesTableOrderingComposer,
      $$RepairServicesTableAnnotationComposer,
      $$RepairServicesTableCreateCompanionBuilder,
      $$RepairServicesTableUpdateCompanionBuilder,
      (RepairServiceRow, $$RepairServicesTableReferences),
      RepairServiceRow,
      PrefetchHooks Function({bool repairOrderId})
    >;
typedef $$RepairPartsTableCreateCompanionBuilder =
    RepairPartsCompanion Function({
      required String id,
      required String repairOrderId,
      Value<String?> partId,
      required String partTitleSnapshot,
      Value<String?> brandSnapshot,
      Value<int> quantity,
      required int unitPrice,
      required String suppliedBy,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RepairPartsTableUpdateCompanionBuilder =
    RepairPartsCompanion Function({
      Value<String> id,
      Value<String> repairOrderId,
      Value<String?> partId,
      Value<String> partTitleSnapshot,
      Value<String?> brandSnapshot,
      Value<int> quantity,
      Value<int> unitPrice,
      Value<String> suppliedBy,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RepairPartsTableReferences
    extends BaseReferences<_$AppDatabase, $RepairPartsTable, RepairPartRow> {
  $$RepairPartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('repair_parts__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id')!;

    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('repair_parts__part_id__parts__id');

  $$PartsTableProcessedTableManager? get partId {
    final $_column = $_itemColumn<String>('part_id');
    if ($_column == null) return null;
    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepairPartsTableFilterComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partTitleSnapshot => $composableBuilder(
    column: $table.partTitleSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suppliedBy => $composableBuilder(
    column: $table.suppliedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partTitleSnapshot => $composableBuilder(
    column: $table.partTitleSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suppliedBy => $composableBuilder(
    column: $table.suppliedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairPartsTable> {
  $$RepairPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get partTitleSnapshot => $composableBuilder(
    column: $table.partTitleSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brandSnapshot => $composableBuilder(
    column: $table.brandSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get suppliedBy => $composableBuilder(
    column: $table.suppliedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairPartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairPartsTable,
          RepairPartRow,
          $$RepairPartsTableFilterComposer,
          $$RepairPartsTableOrderingComposer,
          $$RepairPartsTableAnnotationComposer,
          $$RepairPartsTableCreateCompanionBuilder,
          $$RepairPartsTableUpdateCompanionBuilder,
          (RepairPartRow, $$RepairPartsTableReferences),
          RepairPartRow,
          PrefetchHooks Function({bool repairOrderId, bool partId})
        > {
  $$RepairPartsTableTableManager(_$AppDatabase db, $RepairPartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepairPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepairPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairOrderId = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                Value<String> partTitleSnapshot = const Value.absent(),
                Value<String?> brandSnapshot = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<String> suppliedBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairPartsCompanion(
                id: id,
                repairOrderId: repairOrderId,
                partId: partId,
                partTitleSnapshot: partTitleSnapshot,
                brandSnapshot: brandSnapshot,
                quantity: quantity,
                unitPrice: unitPrice,
                suppliedBy: suppliedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairOrderId,
                Value<String?> partId = const Value.absent(),
                required String partTitleSnapshot,
                Value<String?> brandSnapshot = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                required int unitPrice,
                required String suppliedBy,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RepairPartsCompanion.insert(
                id: id,
                repairOrderId: repairOrderId,
                partId: partId,
                partTitleSnapshot: partTitleSnapshot,
                brandSnapshot: brandSnapshot,
                quantity: quantity,
                unitPrice: unitPrice,
                suppliedBy: suppliedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepairPartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repairOrderId = false, partId = false}) {
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
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable: $$RepairPartsTableReferences
                                    ._repairOrderIdTable(db),
                                referencedColumn: $$RepairPartsTableReferences
                                    ._repairOrderIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$RepairPartsTableReferences
                                    ._partIdTable(db),
                                referencedColumn: $$RepairPartsTableReferences
                                    ._partIdTable(db)
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

typedef $$RepairPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairPartsTable,
      RepairPartRow,
      $$RepairPartsTableFilterComposer,
      $$RepairPartsTableOrderingComposer,
      $$RepairPartsTableAnnotationComposer,
      $$RepairPartsTableCreateCompanionBuilder,
      $$RepairPartsTableUpdateCompanionBuilder,
      (RepairPartRow, $$RepairPartsTableReferences),
      RepairPartRow,
      PrefetchHooks Function({bool repairOrderId, bool partId})
    >;
typedef $$PartPriceHistoryTableCreateCompanionBuilder =
    PartPriceHistoryCompanion Function({
      required String id,
      Value<String?> partId,
      required String partTitleNormalized,
      Value<String?> vehicleModel,
      required int amount,
      Value<String?> repairOrderId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PartPriceHistoryTableUpdateCompanionBuilder =
    PartPriceHistoryCompanion Function({
      Value<String> id,
      Value<String?> partId,
      Value<String> partTitleNormalized,
      Value<String?> vehicleModel,
      Value<int> amount,
      Value<String?> repairOrderId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PartPriceHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PartPriceHistoryTable,
          PartPriceHistoryRow
        > {
  $$PartPriceHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('part_price_history__part_id__parts__id');

  $$PartsTableProcessedTableManager? get partId {
    final $_column = $_itemColumn<String>('part_id');
    if ($_column == null) return null;
    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('part_price_history__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager? get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id');
    if ($_column == null) return null;
    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartPriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PartPriceHistoryTable> {
  $$PartPriceHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partTitleNormalized => $composableBuilder(
    column: $table.partTitleNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartPriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PartPriceHistoryTable> {
  $$PartPriceHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partTitleNormalized => $composableBuilder(
    column: $table.partTitleNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartPriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartPriceHistoryTable> {
  $$PartPriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get partTitleNormalized => $composableBuilder(
    column: $table.partTitleNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehicleModel => $composableBuilder(
    column: $table.vehicleModel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartPriceHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartPriceHistoryTable,
          PartPriceHistoryRow,
          $$PartPriceHistoryTableFilterComposer,
          $$PartPriceHistoryTableOrderingComposer,
          $$PartPriceHistoryTableAnnotationComposer,
          $$PartPriceHistoryTableCreateCompanionBuilder,
          $$PartPriceHistoryTableUpdateCompanionBuilder,
          (PartPriceHistoryRow, $$PartPriceHistoryTableReferences),
          PartPriceHistoryRow,
          PrefetchHooks Function({bool partId, bool repairOrderId})
        > {
  $$PartPriceHistoryTableTableManager(
    _$AppDatabase db,
    $PartPriceHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartPriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartPriceHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartPriceHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                Value<String> partTitleNormalized = const Value.absent(),
                Value<String?> vehicleModel = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> repairOrderId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartPriceHistoryCompanion(
                id: id,
                partId: partId,
                partTitleNormalized: partTitleNormalized,
                vehicleModel: vehicleModel,
                amount: amount,
                repairOrderId: repairOrderId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> partId = const Value.absent(),
                required String partTitleNormalized,
                Value<String?> vehicleModel = const Value.absent(),
                required int amount,
                Value<String?> repairOrderId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PartPriceHistoryCompanion.insert(
                id: id,
                partId: partId,
                partTitleNormalized: partTitleNormalized,
                vehicleModel: vehicleModel,
                amount: amount,
                repairOrderId: repairOrderId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartPriceHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false, repairOrderId = false}) {
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
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable:
                                    $$PartPriceHistoryTableReferences
                                        ._partIdTable(db),
                                referencedColumn:
                                    $$PartPriceHistoryTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable:
                                    $$PartPriceHistoryTableReferences
                                        ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$PartPriceHistoryTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$PartPriceHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartPriceHistoryTable,
      PartPriceHistoryRow,
      $$PartPriceHistoryTableFilterComposer,
      $$PartPriceHistoryTableOrderingComposer,
      $$PartPriceHistoryTableAnnotationComposer,
      $$PartPriceHistoryTableCreateCompanionBuilder,
      $$PartPriceHistoryTableUpdateCompanionBuilder,
      (PartPriceHistoryRow, $$PartPriceHistoryTableReferences),
      PartPriceHistoryRow,
      PrefetchHooks Function({bool partId, bool repairOrderId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String vehicleId,
      Value<String?> repairOrderId,
      required String title,
      Value<DateTime?> dueDate,
      Value<int?> dueMileage,
      required String status,
      required DateTime createdAt,
      Value<DateTime?> lastNotifiedAt,
      Value<String?> lastNotificationKind,
      Value<int?> intervalDays,
      Value<int?> intervalMileage,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String?> repairOrderId,
      Value<String> title,
      Value<DateTime?> dueDate,
      Value<int?> dueMileage,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> lastNotifiedAt,
      Value<String?> lastNotificationKind,
      Value<int?> intervalDays,
      Value<int?> intervalMileage,
      Value<int> rowid,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, ReminderRow> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('reminders__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

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

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('reminders__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager? get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id');
    if ($_column == null) return null;
    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueMileage => $composableBuilder(
    column: $table.dueMileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNotificationKind => $composableBuilder(
    column: $table.lastNotificationKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMileage => $composableBuilder(
    column: $table.intervalMileage,
    builder: (column) => ColumnFilters(column),
  );

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

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueMileage => $composableBuilder(
    column: $table.dueMileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNotificationKind => $composableBuilder(
    column: $table.lastNotificationKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMileage => $composableBuilder(
    column: $table.intervalMileage,
    builder: (column) => ColumnOrderings(column),
  );

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

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueMileage => $composableBuilder(
    column: $table.dueMileage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastNotifiedAt => $composableBuilder(
    column: $table.lastNotifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNotificationKind => $composableBuilder(
    column: $table.lastNotificationKind,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalMileage => $composableBuilder(
    column: $table.intervalMileage,
    builder: (column) => column,
  );

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

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          ReminderRow,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (ReminderRow, $$RemindersTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool vehicleId, bool repairOrderId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String?> repairOrderId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueMileage = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastNotifiedAt = const Value.absent(),
                Value<String?> lastNotificationKind = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> intervalMileage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                repairOrderId: repairOrderId,
                title: title,
                dueDate: dueDate,
                dueMileage: dueMileage,
                status: status,
                createdAt: createdAt,
                lastNotifiedAt: lastNotifiedAt,
                lastNotificationKind: lastNotificationKind,
                intervalDays: intervalDays,
                intervalMileage: intervalMileage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                Value<String?> repairOrderId = const Value.absent(),
                required String title,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueMileage = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<DateTime?> lastNotifiedAt = const Value.absent(),
                Value<String?> lastNotificationKind = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> intervalMileage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                repairOrderId: repairOrderId,
                title: title,
                dueDate: dueDate,
                dueMileage: dueMileage,
                status: status,
                createdAt: createdAt,
                lastNotifiedAt: lastNotifiedAt,
                lastNotificationKind: lastNotificationKind,
                intervalDays: intervalDays,
                intervalMileage: intervalMileage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, repairOrderId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$RemindersTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable: $$RemindersTableReferences
                                    ._repairOrderIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._repairOrderIdTable(db)
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

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      ReminderRow,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (ReminderRow, $$RemindersTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool vehicleId, bool repairOrderId})
    >;
typedef $$PaymentTransactionsTableCreateCompanionBuilder =
    PaymentTransactionsCompanion Function({
      required String id,
      required String repairOrderId,
      required int amount,
      required DateTime paidAt,
      required String method,
      Value<String?> note,
      Value<String?> trackingCode,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PaymentTransactionsTableUpdateCompanionBuilder =
    PaymentTransactionsCompanion Function({
      Value<String> id,
      Value<String> repairOrderId,
      Value<int> amount,
      Value<DateTime> paidAt,
      Value<String> method,
      Value<String?> note,
      Value<String?> trackingCode,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PaymentTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentTransactionsTable,
          PaymentTransactionRow
        > {
  $$PaymentTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('payment_transactions__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id')!;

    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentTransactionsTable> {
  $$PaymentTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingCode => $composableBuilder(
    column: $table.trackingCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentTransactionsTable> {
  $$PaymentTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingCode => $composableBuilder(
    column: $table.trackingCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentTransactionsTable> {
  $$PaymentTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get trackingCode => $composableBuilder(
    column: $table.trackingCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentTransactionsTable,
          PaymentTransactionRow,
          $$PaymentTransactionsTableFilterComposer,
          $$PaymentTransactionsTableOrderingComposer,
          $$PaymentTransactionsTableAnnotationComposer,
          $$PaymentTransactionsTableCreateCompanionBuilder,
          $$PaymentTransactionsTableUpdateCompanionBuilder,
          (PaymentTransactionRow, $$PaymentTransactionsTableReferences),
          PaymentTransactionRow,
          PrefetchHooks Function({bool repairOrderId})
        > {
  $$PaymentTransactionsTableTableManager(
    _$AppDatabase db,
    $PaymentTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaymentTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairOrderId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> trackingCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentTransactionsCompanion(
                id: id,
                repairOrderId: repairOrderId,
                amount: amount,
                paidAt: paidAt,
                method: method,
                note: note,
                trackingCode: trackingCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairOrderId,
                required int amount,
                required DateTime paidAt,
                required String method,
                Value<String?> note = const Value.absent(),
                Value<String?> trackingCode = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentTransactionsCompanion.insert(
                id: id,
                repairOrderId: repairOrderId,
                amount: amount,
                paidAt: paidAt,
                method: method,
                note: note,
                trackingCode: trackingCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repairOrderId = false}) {
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
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable:
                                    $$PaymentTransactionsTableReferences
                                        ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$PaymentTransactionsTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$PaymentTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentTransactionsTable,
      PaymentTransactionRow,
      $$PaymentTransactionsTableFilterComposer,
      $$PaymentTransactionsTableOrderingComposer,
      $$PaymentTransactionsTableAnnotationComposer,
      $$PaymentTransactionsTableCreateCompanionBuilder,
      $$PaymentTransactionsTableUpdateCompanionBuilder,
      (PaymentTransactionRow, $$PaymentTransactionsTableReferences),
      PaymentTransactionRow,
      PrefetchHooks Function({bool repairOrderId})
    >;
typedef $$RepairStatusHistoriesTableCreateCompanionBuilder =
    RepairStatusHistoriesCompanion Function({
      required String id,
      required String repairOrderId,
      Value<String?> fromStatus,
      required String toStatus,
      required DateTime changedAt,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$RepairStatusHistoriesTableUpdateCompanionBuilder =
    RepairStatusHistoriesCompanion Function({
      Value<String> id,
      Value<String> repairOrderId,
      Value<String?> fromStatus,
      Value<String> toStatus,
      Value<DateTime> changedAt,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$RepairStatusHistoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RepairStatusHistoriesTable,
          RepairStatusHistoryRow
        > {
  $$RepairStatusHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) =>
      db.repairOrders.createAlias(
        'repair_status_histories__repair_order_id__repair_orders__id',
      );

  $$RepairOrdersTableProcessedTableManager get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id')!;

    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepairStatusHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $RepairStatusHistoriesTable> {
  $$RepairStatusHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairStatusHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RepairStatusHistoriesTable> {
  $$RepairStatusHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairStatusHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepairStatusHistoriesTable> {
  $$RepairStatusHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepairStatusHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepairStatusHistoriesTable,
          RepairStatusHistoryRow,
          $$RepairStatusHistoriesTableFilterComposer,
          $$RepairStatusHistoriesTableOrderingComposer,
          $$RepairStatusHistoriesTableAnnotationComposer,
          $$RepairStatusHistoriesTableCreateCompanionBuilder,
          $$RepairStatusHistoriesTableUpdateCompanionBuilder,
          (RepairStatusHistoryRow, $$RepairStatusHistoriesTableReferences),
          RepairStatusHistoryRow,
          PrefetchHooks Function({bool repairOrderId})
        > {
  $$RepairStatusHistoriesTableTableManager(
    _$AppDatabase db,
    $RepairStatusHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepairStatusHistoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RepairStatusHistoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RepairStatusHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairOrderId = const Value.absent(),
                Value<String?> fromStatus = const Value.absent(),
                Value<String> toStatus = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairStatusHistoriesCompanion(
                id: id,
                repairOrderId: repairOrderId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedAt: changedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairOrderId,
                Value<String?> fromStatus = const Value.absent(),
                required String toStatus,
                required DateTime changedAt,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepairStatusHistoriesCompanion.insert(
                id: id,
                repairOrderId: repairOrderId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedAt: changedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RepairStatusHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repairOrderId = false}) {
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
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable:
                                    $$RepairStatusHistoriesTableReferences
                                        ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$RepairStatusHistoriesTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$RepairStatusHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepairStatusHistoriesTable,
      RepairStatusHistoryRow,
      $$RepairStatusHistoriesTableFilterComposer,
      $$RepairStatusHistoriesTableOrderingComposer,
      $$RepairStatusHistoriesTableAnnotationComposer,
      $$RepairStatusHistoriesTableCreateCompanionBuilder,
      $$RepairStatusHistoriesTableUpdateCompanionBuilder,
      (RepairStatusHistoryRow, $$RepairStatusHistoriesTableReferences),
      RepairStatusHistoryRow,
      PrefetchHooks Function({bool repairOrderId})
    >;
typedef $$VehicleMileageLogsTableCreateCompanionBuilder =
    VehicleMileageLogsCompanion Function({
      required String id,
      required String vehicleId,
      Value<String?> repairOrderId,
      required int mileage,
      required DateTime recordedAt,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$VehicleMileageLogsTableUpdateCompanionBuilder =
    VehicleMileageLogsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String?> repairOrderId,
      Value<int> mileage,
      Value<DateTime> recordedAt,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$VehicleMileageLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VehicleMileageLogsTable,
          VehicleMileageLogRow
        > {
  $$VehicleMileageLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('vehicle_mileage_logs__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

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

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('vehicle_mileage_logs__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager? get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id');
    if ($_column == null) return null;
    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VehicleMileageLogsTableFilterComposer
    extends Composer<_$AppDatabase, $VehicleMileageLogsTable> {
  $$VehicleMileageLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

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

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehicleMileageLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $VehicleMileageLogsTable> {
  $$VehicleMileageLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

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

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehicleMileageLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehicleMileageLogsTable> {
  $$VehicleMileageLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

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

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VehicleMileageLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehicleMileageLogsTable,
          VehicleMileageLogRow,
          $$VehicleMileageLogsTableFilterComposer,
          $$VehicleMileageLogsTableOrderingComposer,
          $$VehicleMileageLogsTableAnnotationComposer,
          $$VehicleMileageLogsTableCreateCompanionBuilder,
          $$VehicleMileageLogsTableUpdateCompanionBuilder,
          (VehicleMileageLogRow, $$VehicleMileageLogsTableReferences),
          VehicleMileageLogRow,
          PrefetchHooks Function({bool vehicleId, bool repairOrderId})
        > {
  $$VehicleMileageLogsTableTableManager(
    _$AppDatabase db,
    $VehicleMileageLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehicleMileageLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehicleMileageLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehicleMileageLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String?> repairOrderId = const Value.absent(),
                Value<int> mileage = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehicleMileageLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                repairOrderId: repairOrderId,
                mileage: mileage,
                recordedAt: recordedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                Value<String?> repairOrderId = const Value.absent(),
                required int mileage,
                required DateTime recordedAt,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehicleMileageLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                repairOrderId: repairOrderId,
                mileage: mileage,
                recordedAt: recordedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehicleMileageLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, repairOrderId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable:
                                    $$VehicleMileageLogsTableReferences
                                        ._vehicleIdTable(db),
                                referencedColumn:
                                    $$VehicleMileageLogsTableReferences
                                        ._vehicleIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable:
                                    $$VehicleMileageLogsTableReferences
                                        ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$VehicleMileageLogsTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$VehicleMileageLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehicleMileageLogsTable,
      VehicleMileageLogRow,
      $$VehicleMileageLogsTableFilterComposer,
      $$VehicleMileageLogsTableOrderingComposer,
      $$VehicleMileageLogsTableAnnotationComposer,
      $$VehicleMileageLogsTableCreateCompanionBuilder,
      $$VehicleMileageLogsTableUpdateCompanionBuilder,
      (VehicleMileageLogRow, $$VehicleMileageLogsTableReferences),
      VehicleMileageLogRow,
      PrefetchHooks Function({bool vehicleId, bool repairOrderId})
    >;
typedef $$AssistantMessagesTableCreateCompanionBuilder =
    AssistantMessagesCompanion Function({
      required String id,
      required String repairOrderId,
      required String role,
      required String content,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AssistantMessagesTableUpdateCompanionBuilder =
    AssistantMessagesCompanion Function({
      Value<String> id,
      Value<String> repairOrderId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AssistantMessagesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AssistantMessagesTable,
          AssistantMessageRow
        > {
  $$AssistantMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RepairOrdersTable _repairOrderIdTable(_$AppDatabase db) => db
      .repairOrders
      .createAlias('assistant_messages__repair_order_id__repair_orders__id');

  $$RepairOrdersTableProcessedTableManager get repairOrderId {
    final $_column = $_itemColumn<String>('repair_order_id')!;

    final manager = $$RepairOrdersTableTableManager(
      $_db,
      $_db.repairOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repairOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssistantMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $AssistantMessagesTable> {
  $$AssistantMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RepairOrdersTableFilterComposer get repairOrderId {
    final $$RepairOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableFilterComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistantMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssistantMessagesTable> {
  $$AssistantMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RepairOrdersTableOrderingComposer get repairOrderId {
    final $$RepairOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistantMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssistantMessagesTable> {
  $$AssistantMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RepairOrdersTableAnnotationComposer get repairOrderId {
    final $$RepairOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.repairOrderId,
      referencedTable: $db.repairOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepairOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.repairOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistantMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssistantMessagesTable,
          AssistantMessageRow,
          $$AssistantMessagesTableFilterComposer,
          $$AssistantMessagesTableOrderingComposer,
          $$AssistantMessagesTableAnnotationComposer,
          $$AssistantMessagesTableCreateCompanionBuilder,
          $$AssistantMessagesTableUpdateCompanionBuilder,
          (AssistantMessageRow, $$AssistantMessagesTableReferences),
          AssistantMessageRow,
          PrefetchHooks Function({bool repairOrderId})
        > {
  $$AssistantMessagesTableTableManager(
    _$AppDatabase db,
    $AssistantMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssistantMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssistantMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssistantMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repairOrderId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssistantMessagesCompanion(
                id: id,
                repairOrderId: repairOrderId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repairOrderId,
                required String role,
                required String content,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AssistantMessagesCompanion.insert(
                id: id,
                repairOrderId: repairOrderId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AssistantMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({repairOrderId = false}) {
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
                    if (repairOrderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.repairOrderId,
                                referencedTable:
                                    $$AssistantMessagesTableReferences
                                        ._repairOrderIdTable(db),
                                referencedColumn:
                                    $$AssistantMessagesTableReferences
                                        ._repairOrderIdTable(db)
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

typedef $$AssistantMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssistantMessagesTable,
      AssistantMessageRow,
      $$AssistantMessagesTableFilterComposer,
      $$AssistantMessagesTableOrderingComposer,
      $$AssistantMessagesTableAnnotationComposer,
      $$AssistantMessagesTableCreateCompanionBuilder,
      $$AssistantMessagesTableUpdateCompanionBuilder,
      (AssistantMessageRow, $$AssistantMessagesTableReferences),
      AssistantMessageRow,
      PrefetchHooks Function({bool repairOrderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkshopsTableTableManager get workshops =>
      $$WorkshopsTableTableManager(_db, _db.workshops);
  $$BankAccountsTableTableManager get bankAccounts =>
      $$BankAccountsTableTableManager(_db, _db.bankAccounts);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$ServiceCategoriesTableTableManager get serviceCategories =>
      $$ServiceCategoriesTableTableManager(_db, _db.serviceCategories);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$RepairOrdersTableTableManager get repairOrders =>
      $$RepairOrdersTableTableManager(_db, _db.repairOrders);
  $$RepairServicesTableTableManager get repairServices =>
      $$RepairServicesTableTableManager(_db, _db.repairServices);
  $$RepairPartsTableTableManager get repairParts =>
      $$RepairPartsTableTableManager(_db, _db.repairParts);
  $$PartPriceHistoryTableTableManager get partPriceHistory =>
      $$PartPriceHistoryTableTableManager(_db, _db.partPriceHistory);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$PaymentTransactionsTableTableManager get paymentTransactions =>
      $$PaymentTransactionsTableTableManager(_db, _db.paymentTransactions);
  $$RepairStatusHistoriesTableTableManager get repairStatusHistories =>
      $$RepairStatusHistoriesTableTableManager(_db, _db.repairStatusHistories);
  $$VehicleMileageLogsTableTableManager get vehicleMileageLogs =>
      $$VehicleMileageLogsTableTableManager(_db, _db.vehicleMileageLogs);
  $$AssistantMessagesTableTableManager get assistantMessages =>
      $$AssistantMessagesTableTableManager(_db, _db.assistantMessages);
}

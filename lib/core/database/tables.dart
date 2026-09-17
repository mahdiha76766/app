import 'package:drift/drift.dart';

/// کارگاه
@DataClassName('WorkshopRow')
class Workshops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get mechanicName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get morningHour => integer().withDefault(const Constant(9))();
  IntColumn get afternoonHour => integer().withDefault(const Constant(17))();
  IntColumn get nightHour => integer().withDefault(const Constant(20))();
  BoolColumn get enableWhatsApp =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get enableTelegram =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get enableSms => boolean().withDefault(const Constant(false))();
  BoolColumn get includeBankInfoInMessages =>
      boolean().withDefault(const Constant(false))();
  IntColumn get nextInvoiceNumber =>
      integer().withDefault(const Constant(1))();
  /// سال شمسی جاری برای شمارندهٔ ترتیبی فاکتور.
  IntColumn get invoiceSeqYear => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// حساب‌های بانکی تعمیرگاه برای فاکتور و پیام
@DataClassName('BankAccountRow')
class BankAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get workshopId => text().references(Workshops, #id)();
  TextColumn get bankName => text()();
  TextColumn get accountHolderName => text().nullable()();
  TextColumn get accountNumber => text().nullable()();
  TextColumn get cardNumber => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// مشتری
@DataClassName('CustomerRow')
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().nullable()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// خودرو
@DataClassName('VehicleRow')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get plateNormalized => text().unique()();
  TextColumn get plateDisplay => text()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get trim => text().nullable()();
  IntColumn get productionYear => integer().nullable()();
  IntColumn get lastMileage => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// دسته خدمات
@DataClassName('ServiceCategoryRow')
class ServiceCategories extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get iconKey => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// کاتالوگ قطعات
@DataClassName('PartRow')
class Parts extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get normalizedTitle => text()();
  TextColumn get serviceCategoryId =>
      text().nullable().references(ServiceCategories, #id)();
  TextColumn get vehicleModel => text().nullable()();
  TextColumn get brand => text().nullable()();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// سفارش تعمیر
@DataClassName('RepairOrderRow')
class RepairOrders extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get status => text()();
  TextColumn get complaintText => text().nullable()();
  IntColumn get mileage => integer().nullable()();
  IntColumn get laborAmount => integer().withDefault(const Constant(0))();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  TextColumn get paymentStatus => text()();
  IntColumn get paidAmount => integer().withDefault(const Constant(0))();
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get cancelReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {invoiceNumber},
      ];
}

/// تاریخچه تغییر وضعیت تعمیر
@DataClassName('RepairStatusHistoryRow')
class RepairStatusHistories extends Table {
  TextColumn get id => text()();
  TextColumn get repairOrderId => text().references(RepairOrders, #id)();
  TextColumn get fromStatus => text().nullable()();
  TextColumn get toStatus => text()();
  DateTimeColumn get changedAt => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// تاریخچه کارکرد خودرو در مراجعات
@DataClassName('VehicleMileageLogRow')
class VehicleMileageLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get repairOrderId =>
      text().nullable().references(RepairOrders, #id)();
  IntColumn get mileage => integer()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// تراکنش‌های پرداخت فاکتور
@DataClassName('PaymentTransactionRow')
class PaymentTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get repairOrderId => text().references(RepairOrders, #id)();
  IntColumn get amount => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get method => text()();
  TextColumn get note => text().nullable()();
  TextColumn get trackingCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// خدمات ثبت‌شده روی تعمیر
@DataClassName('RepairServiceRow')
class RepairServices extends Table {
  TextColumn get id => text()();
  TextColumn get repairOrderId => text().references(RepairOrders, #id)();
  TextColumn get title => text()();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// قطعات ثبت‌شده روی تعمیر
@DataClassName('RepairPartRow')
class RepairParts extends Table {
  TextColumn get id => text()();
  TextColumn get repairOrderId => text().references(RepairOrders, #id)();
  TextColumn get partId => text().nullable().references(Parts, #id)();
  TextColumn get partTitleSnapshot => text()();
  TextColumn get brandSnapshot => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get unitPrice => integer()();
  TextColumn get suppliedBy => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// تاریخچه قیمت قطعه
@DataClassName('PartPriceHistoryRow')
class PartPriceHistory extends Table {
  TextColumn get id => text()();
  TextColumn get partId => text().nullable().references(Parts, #id)();
  TextColumn get partTitleNormalized => text()();
  TextColumn get vehicleModel => text().nullable()();
  IntColumn get amount => integer()();
  TextColumn get repairOrderId =>
      text().nullable().references(RepairOrders, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// یادآوری
@DataClassName('ReminderRow')
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get repairOrderId =>
      text().nullable().references(RepairOrders, #id)();
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get dueMileage => integer().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  /// آخرین زمان ارسال اعلان (برای جلوگیری از تکرار).
  DateTimeColumn get lastNotifiedAt => dateTime().nullable()();
  /// نوع آخرین اعلان: date | mileage
  TextColumn get lastNotificationKind => text().nullable()();
  IntColumn get intervalDays => integer().nullable()();
  IntColumn get intervalMileage => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// پیام‌های گفتگوی دستیار هوشمند (متصل به تعمیر)
@DataClassName('AssistantMessageRow')
class AssistantMessages extends Table {
  TextColumn get id => text()();
  TextColumn get repairOrderId => text().references(RepairOrders, #id)();
  /// user | assistant
  TextColumn get role => text()();
  /// متن سؤال کاربر یا JSON پاسخ ساخت‌یافته
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

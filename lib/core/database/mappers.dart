import 'package:drift/drift.dart';

import '../../features/parts/domain/entities/part.dart';
import '../../features/parts/domain/entities/service_category.dart';
import '../../features/reminders/domain/entities/reminder.dart';
import '../../features/repair_orders/domain/entities/repair_order.dart';
import '../../features/repair_orders/domain/entities/repair_part.dart';
import '../../features/repair_orders/domain/entities/repair_service.dart';
import '../../features/settings/domain/entities/workshop.dart';
import '../../features/vehicles/domain/entities/customer.dart';
import '../../features/vehicles/domain/entities/vehicle.dart';
import 'enums.dart';
import 'app_database.dart';

extension WorkshopMapper on Workshop {
  WorkshopsCompanion toCompanion() {
    return WorkshopsCompanion.insert(
      id: id,
      name: name,
      mechanicName: Value(mechanicName),
      phone: Value(phone),
      address: Value(address),
      morningHour: Value(morningHour),
      afternoonHour: Value(afternoonHour),
      nightHour: Value(nightHour),
      enableWhatsApp: Value(enableWhatsApp),
      enableTelegram: Value(enableTelegram),
      enableSms: Value(enableSms),
      includeBankInfoInMessages: Value(includeBankInfoInMessages),
      nextInvoiceNumber: Value(nextInvoiceNumber),
      invoiceSeqYear: Value(invoiceSeqYear),
      createdAt: createdAt,
    );
  }
}

extension WorkshopRowMapper on WorkshopRow {
  Workshop toDomain() {
    return Workshop(
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
    );
  }
}

extension CustomerMapper on Customer {
  CustomersCompanion toCompanion() {
    return CustomersCompanion.insert(
      id: id,
      fullName: Value(fullName),
      phone: Value(phone),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CustomerRowMapper on CustomerRow {
  Customer toDomain() {
    return Customer(
      id: id,
      fullName: fullName,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension VehicleMapper on Vehicle {
  VehiclesCompanion toCompanion() {
    return VehiclesCompanion.insert(
      id: id,
      customerId: Value(customerId),
      plateNormalized: plateNormalized,
      plateDisplay: plateDisplay,
      manufacturer: Value(manufacturer),
      model: Value(model),
      trim: Value(trim),
      productionYear: Value(productionYear),
      lastMileage: Value(lastMileage),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension VehicleRowMapper on VehicleRow {
  Vehicle toDomain() {
    return Vehicle(
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
    );
  }
}

extension ServiceCategoryRowMapper on ServiceCategoryRow {
  ServiceCategory toDomain() {
    return ServiceCategory(
      id: id,
      title: title,
      iconKey: iconKey,
      sortOrder: sortOrder,
      isActive: isActive,
    );
  }
}

extension PartMapper on Part {
  PartsCompanion toCompanion() {
    return PartsCompanion.insert(
      id: id,
      title: title,
      normalizedTitle: normalizedTitle,
      serviceCategoryId: Value(serviceCategoryId),
      vehicleModel: Value(vehicleModel),
      brand: Value(brand),
      usageCount: Value(usageCount),
      isActive: Value(isActive),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension PartRowMapper on PartRow {
  Part toDomain() {
    return Part(
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
    );
  }
}

extension RepairOrderMapper on RepairOrder {
  RepairOrdersCompanion toCompanion() {
    return RepairOrdersCompanion.insert(
      id: id,
      vehicleId: vehicleId,
      customerId: Value(customerId),
      status: status.value,
      complaintText: Value(complaintText),
      mileage: Value(mileage),
      laborAmount: Value(laborAmount),
      discountAmount: Value(discountAmount),
      paymentStatus: paymentStatus.value,
      paidAmount: Value(paidAmount),
      invoiceNumber: Value(invoiceNumber),
      cancelReason: Value(cancelReason),
      createdAt: createdAt,
      completedAt: Value(completedAt),
      deliveredAt: Value(deliveredAt),
    );
  }
}

extension RepairOrderRowMapper on RepairOrderRow {
  RepairOrder toDomain() {
    return RepairOrder(
      id: id,
      vehicleId: vehicleId,
      customerId: customerId,
      status: RepairOrderStatus.fromValue(status),
      complaintText: complaintText,
      mileage: mileage,
      laborAmount: laborAmount,
      discountAmount: discountAmount,
      paymentStatus: PaymentStatus.fromValue(paymentStatus),
      paidAmount: paidAmount,
      invoiceNumber: invoiceNumber,
      cancelReason: cancelReason,
      createdAt: createdAt,
      completedAt: completedAt,
      deliveredAt: deliveredAt,
    );
  }
}

extension RepairPartMapper on RepairPart {
  RepairPartsCompanion toCompanion() {
    return RepairPartsCompanion.insert(
      id: id,
      repairOrderId: repairOrderId,
      partId: Value(partId),
      partTitleSnapshot: partTitleSnapshot,
      brandSnapshot: Value(brandSnapshot),
      quantity: Value(quantity),
      unitPrice: unitPrice,
      suppliedBy: suppliedBy.value,
      createdAt: createdAt,
    );
  }
}

extension RepairPartRowMapper on RepairPartRow {
  RepairPart toDomain() {
    return RepairPart(
      id: id,
      repairOrderId: repairOrderId,
      partId: partId,
      partTitleSnapshot: partTitleSnapshot,
      brandSnapshot: brandSnapshot,
      quantity: quantity,
      unitPrice: unitPrice,
      suppliedBy: PartSuppliedBy.fromValue(suppliedBy),
      createdAt: createdAt,
    );
  }
}

extension RepairServiceMapper on RepairService {
  RepairServicesCompanion toCompanion() {
    return RepairServicesCompanion.insert(
      id: id,
      repairOrderId: repairOrderId,
      title: title,
      amount: Value(amount),
      createdAt: createdAt,
    );
  }
}

extension RepairServiceRowMapper on RepairServiceRow {
  RepairService toDomain() {
    return RepairService(
      id: id,
      repairOrderId: repairOrderId,
      title: title,
      amount: amount,
      createdAt: createdAt,
    );
  }
}

extension ReminderMapper on Reminder {
  RemindersCompanion toCompanion() {
    return RemindersCompanion.insert(
      id: id,
      vehicleId: vehicleId,
      repairOrderId: Value(repairOrderId),
      title: title,
      dueDate: Value(dueDate),
      dueMileage: Value(dueMileage),
      status: status.value,
      createdAt: createdAt,
      lastNotifiedAt: Value(lastNotifiedAt),
      lastNotificationKind: Value(lastNotificationKind),
      intervalDays: Value(intervalDays),
      intervalMileage: Value(intervalMileage),
    );
  }
}

extension ReminderRowMapper on ReminderRow {
  Reminder toDomain() {
    return Reminder(
      id: id,
      vehicleId: vehicleId,
      repairOrderId: repairOrderId,
      title: title,
      dueDate: dueDate,
      dueMileage: dueMileage,
      status: ReminderStatus.fromValue(status),
      createdAt: createdAt,
      lastNotifiedAt: lastNotifiedAt,
      lastNotificationKind: lastNotificationKind,
      intervalDays: intervalDays,
      intervalMileage: intervalMileage,
    );
  }
}

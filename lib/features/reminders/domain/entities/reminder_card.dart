import 'reminder.dart';

/// کارت یادآوری همراه اطلاعات مشتری/خودرو برای UI.
class ReminderCard {
  const ReminderCard({
    required this.reminder,
    required this.vehicleModel,
    required this.plateDisplay,
    this.customerName,
    this.phone,
    this.currentMileage,
  });

  final Reminder reminder;
  final String vehicleModel;
  final String plateDisplay;
  final String? customerName;
  final String? phone;
  final int? currentMileage;
}

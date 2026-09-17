/// پاسخ ساخت‌یافته دستیار هوشمند مکانیک.
class AssistantReply {
  const AssistantReply({
    required this.summary,
    required this.possibleCauses,
    required this.followUpQuestions,
    required this.recommendedTests,
    required this.urgency,
    required this.safetyWarning,
    required this.disclaimer,
  });

  final String summary;
  final List<AssistantCause> possibleCauses;
  final List<String> followUpQuestions;
  final List<String> recommendedTests;
  final String urgency; // normal | inspect_soon | stop_vehicle
  final String safetyWarning;
  final String disclaimer;

  factory AssistantReply.fromJson(Map<String, dynamic> json) {
    final causes = (json['possibleCauses'] as List<dynamic>? ?? const [])
        .map((e) => AssistantCause.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return AssistantReply(
      summary: (json['summary'] as String?)?.trim() ?? '',
      possibleCauses: causes,
      followUpQuestions: (json['followUpQuestions'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      recommendedTests: (json['recommendedTests'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      urgency: (json['urgency'] as String?) ?? 'normal',
      safetyWarning: (json['safetyWarning'] as String?)?.trim() ?? '',
      disclaimer: (json['disclaimer'] as String?)?.trim() ??
          'تشخیص نهایی باید توسط تعمیرکار انجام شود.',
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'possibleCauses': [for (final c in possibleCauses) c.toJson()],
        'followUpQuestions': followUpQuestions,
        'recommendedTests': recommendedTests,
        'urgency': urgency,
        'safetyWarning': safetyWarning,
        'disclaimer': disclaimer,
      };

  String get urgencyLabelFa => switch (urgency) {
        'stop_vehicle' => 'توقف خودرو — فوری',
        'inspect_soon' => 'بررسی زودهنگام',
        _ => 'عادی',
      };
}

class AssistantCause {
  const AssistantCause({
    required this.title,
    required this.likelihood,
    required this.reason,
  });

  final String title;
  final String likelihood; // low | medium | high
  final String reason;

  factory AssistantCause.fromJson(Map<String, dynamic> json) {
    return AssistantCause(
      title: (json['title'] as String?)?.trim() ?? '',
      likelihood: (json['likelihood'] as String?) ?? 'medium',
      reason: (json['reason'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'likelihood': likelihood,
        'reason': reason,
      };

  String get likelihoodLabelFa => switch (likelihood) {
        'high' => 'بالا',
        'low' => 'کم',
        _ => 'متوسط',
      };
}

/// زمینهٔ امن خودرو (بدون PII مشتری/پلاک کامل/بانک).
class AssistantVehicleContext {
  const AssistantVehicleContext({
    this.vehicleModel,
    this.mileage,
    this.complaint,
    this.selectedServices = const [],
    this.recentRepairs = const [],
  });

  final String? vehicleModel;
  final int? mileage;
  final String? complaint;
  final List<String> selectedServices;
  final List<AssistantRecentRepair> recentRepairs;

  Map<String, dynamic> toJson() => {
        if (vehicleModel != null && vehicleModel!.trim().isNotEmpty)
          'vehicleModel': vehicleModel!.trim(),
        if (mileage != null) 'mileage': mileage,
        if (complaint != null && complaint!.trim().isNotEmpty)
          'complaint': complaint!.trim(),
        if (selectedServices.isNotEmpty) 'selectedServices': selectedServices,
        if (recentRepairs.isNotEmpty)
          'recentRepairs': [for (final r in recentRepairs) r.toJson()],
      };
}

class AssistantRecentRepair {
  const AssistantRecentRepair({
    required this.summary,
    this.mileage,
  });

  final String summary;
  final int? mileage;

  Map<String, dynamic> toJson() => {
        'summary': summary,
        if (mileage != null) 'mileage': mileage,
      };
}

class AssistantChatMessage {
  const AssistantChatMessage({
    required this.id,
    required this.repairOrderId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.reply,
  });

  final String id;
  final String repairOrderId;
  final String role; // user | assistant
  final String content;
  final DateTime createdAt;
  final AssistantReply? reply;

  bool get isUser => role == 'user';
}

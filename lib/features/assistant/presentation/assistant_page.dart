import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/app_page_app_bar.dart';
import '../../repair_orders/data/providers.dart';
import '../../repair_orders/domain/entities/repair_service.dart';
import '../../vehicles/data/providers.dart';
import '../data/assistant_config.dart';
import '../data/providers.dart';
import '../domain/entities/assistant_models.dart';
import '../domain/repositories/assistant_api_client.dart';
import '../domain/services/assistant_context_builder.dart';

/// صفحه چت متنی دستیار هوشمند (RTL فارسی).
class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key, required this.repairId});

  final String repairId;

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  List<AssistantChatMessage> _messages = const [];
  AssistantVehicleContext? _context;
  bool _loadingHistory = true;
  bool _sending = false;
  String? _errorText;
  String? _errorCode;
  int? _remaining;
  String? _lastFailedQuestion;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loadingHistory = true;
      _errorText = null;
    });
    try {
      final repairRepo = ref.read(repairOrderRepositoryProvider);
      final order = await repairRepo.getById(widget.repairId);
      if (order == null) {
        if (!mounted) return;
        setState(() {
          _loadingHistory = false;
          _errorText = 'تعمیر پیدا نشد.';
        });
        return;
      }

      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
      final services = await repairRepo.getServices(order.id);
      final history = await repairRepo.getHistoryForVehicle(order.vehicleId);
      final servicesById = <String, List<RepairService>>{};
      for (final past in history.take(8)) {
        servicesById[past.id] = await repairRepo.getServices(past.id);
      }

      final contextSafe = AssistantContextBuilder.build(
        vehicle: vehicle,
        order: order,
        services: services,
        recentOrders: history,
        servicesByOrderId: servicesById,
      );

      final messages = await ref
          .read(assistantChatRepositoryProvider)
          .listForRepair(widget.repairId);

      if (!mounted) return;
      setState(() {
        _context = contextSafe;
        _messages = messages;
        _loadingHistory = false;
      });
      _scrollToEnd();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingHistory = false;
        _errorText = 'بارگذاری گفتگو با خطا مواجه شد.';
      });
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send({String? retryQuestion}) async {
    if (_sending) return;
    final question = (retryQuestion ?? _controller.text).trim();
    if (question.isEmpty) return;
    if (question.length > AssistantConfig.maxQuestionChars) {
      setState(() {
        _errorText =
            'سؤال حداکثر ${AssistantConfig.maxQuestionChars} کاراکتر باشد.';
        _errorCode = 'too_long';
      });
      return;
    }

    final ctx = _context;
    if (ctx == null) return;

    setState(() {
      _sending = true;
      _errorText = null;
      _errorCode = null;
      _lastFailedQuestion = null;
    });

    final now = DateTime.now();
    final userId = const Uuid().v4();
    final recentPayload = AssistantContextBuilder.recentMessagesPayload(
      _messages,
      maxPairs: AssistantConfig.recentMessagePairs,
    );

    final alreadySaved = retryQuestion != null &&
        _messages.any((m) => m.isUser && m.content == question);
    if (!alreadySaved) {
      await ref.read(assistantChatRepositoryProvider).appendUserMessage(
            id: userId,
            repairOrderId: widget.repairId,
            content: question,
            createdAt: now,
          );
      setState(() {
        _messages = [
          ..._messages,
          AssistantChatMessage(
            id: userId,
            repairOrderId: widget.repairId,
            role: 'user',
            content: question,
            createdAt: now,
          ),
        ];
        _controller.clear();
      });
      _scrollToEnd();
    }

    try {
      final deviceId = await ref.read(installIdStoreProvider).getOrCreate();
      final result = await ref.read(assistantApiClientProvider).ask(
            deviceId: deviceId,
            question: question,
            vehicleContext: ctx,
            recentMessages: recentPayload,
          );

      final assistantId = const Uuid().v4();
      final at = DateTime.now();
      await ref.read(assistantChatRepositoryProvider).appendAssistantMessage(
            id: assistantId,
            repairOrderId: widget.repairId,
            reply: result.reply,
            createdAt: at,
          );

      if (!mounted) return;
      setState(() {
        _sending = false;
        _remaining = result.remaining;
        _messages = [
          ..._messages,
          AssistantChatMessage(
            id: assistantId,
            repairOrderId: widget.repairId,
            role: 'assistant',
            content: jsonEncode(result.reply.toJson()),
            createdAt: at,
            reply: result.reply,
          ),
        ];
      });
      _scrollToEnd();
    } on AssistantApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _errorText = e.message;
        _errorCode = e.code;
        _remaining = e.remaining;
        _lastFailedQuestion = question;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _errorText = 'خطای ناشناخته در دریافت پاسخ.';
        _errorCode = 'unknown';
        _lastFailedQuestion = question;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppPageAppBar(
        title: 'دستیار هوشمند',
        actions: [
          if (_remaining != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: Center(
                child: Text(
                  'باقیمانده: $_remaining',
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
        ],
      ),
      body: _loadingHistory
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_context != null) _ContextBanner(contextData: _context!),
                Expanded(
                  child: _messages.isEmpty && !_sending
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'سؤال تشخیصی خود را بنویسید.\n'
                              'پاسخ شامل علت‌های احتمالی، تست‌ها و هشدار ایمنی است.\n'
                              'تشخیص نهایی با شماست.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          itemCount: _messages.length + (_sending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_sending && index == _messages.length) {
                              return const _LoadingBubble();
                            }
                            final msg = _messages[index];
                            if (msg.isUser) {
                              return _UserBubble(text: msg.content);
                            }
                            return _AssistantBubble(
                              reply: msg.reply,
                              raw: msg.content,
                            );
                          },
                        ),
                ),
                if (_errorText != null)
                  _ErrorBar(
                    message: _errorText!,
                    code: _errorCode,
                    onRetry: _lastFailedQuestion == null
                        ? null
                        : () => _send(retryQuestion: _lastFailedQuestion),
                  ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            enabled: !_sending,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: InputDecoration(
                              hintText: 'سؤال تشخیصی…',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              counterText: '',
                            ),
                            maxLength: AssistantConfig.maxQuestionChars,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _sending ? null : () => _send(),
                          child: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({required this.contextData});
  final AssistantVehicleContext contextData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <String>[
      if (contextData.vehicleModel != null) contextData.vehicleModel!,
      if (contextData.mileage != null) 'کارکرد ${contextData.mileage}',
      if (contextData.selectedServices.isNotEmpty)
        contextData.selectedServices.take(3).join('، '),
    ];
    return Material(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.directions_car_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                parts.isEmpty
                    ? 'زمینه تعمیر همراه سؤال ارسال می‌شود (بدون پلاک و مشخصات مشتری).'
                    : parts.join(' · '),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _LoadingBubble extends StatelessWidget {
  const _LoadingBubble();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          SizedBox(width: 12),
          Text('در حال دریافت پاسخ…'),
        ],
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({required this.reply, required this.raw});
  final AssistantReply? reply;
  final String raw;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = reply;
    if (r == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Text(raw),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            r.summary,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text('علت‌های احتمالی', style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          for (final c in r.possibleCauses) ...[
            Text('• ${c.title} (${c.likelihoodLabelFa})'),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, bottom: 6),
              child: Text(
                c.reason,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (r.followUpQuestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('سؤال‌های تکمیلی', style: theme.textTheme.labelLarge),
            for (final q in r.followUpQuestions) Text('• $q'),
          ],
          if (r.recommendedTests.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('تست‌های پیشنهادی', style: theme.textTheme.labelLarge),
            for (final t in r.recommendedTests) Text('• $t'),
          ],
          const SizedBox(height: 10),
          Text(
            'فوریت: ${r.urgencyLabelFa}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: r.urgency == 'stop_vehicle'
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (r.safetyWarning.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'ایمنی: ${r.safetyWarning}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            r.disclaimer,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBar extends StatelessWidget {
  const _ErrorBar({
    required this.message,
    this.code,
    this.onRetry,
  });

  final String message;
  final String? code;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.55),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: theme.textTheme.bodyMedium),
            ),
            if (onRetry != null &&
                code != 'quota_exceeded' &&
                code != 'too_long')
              TextButton(
                onPressed: onRetry,
                child: const Text('تلاش مجدد'),
              ),
          ],
        ),
      ),
    );
  }
}

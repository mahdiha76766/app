import 'dart:io';

import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/iranian_plate_input.dart';
import '../../vehicles/presentation/vehicle_lookup_navigator.dart';
import '../domain/entities/plate_recognition_result.dart';

class ConfirmPlateScreen extends ConsumerStatefulWidget {
  const ConfirmPlateScreen({
    super.key,
    required this.result,
  });

  final PlateRecognitionResult result;

  @override
  ConsumerState<ConfirmPlateScreen> createState() => _ConfirmPlateScreenState();
}

class _ConfirmPlateScreenState extends ConsumerState<ConfirmPlateScreen> {
  late IranianPlateValue _plate;
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _plate = IranianPlateValue(
      firstTwoDigits: widget.result.firstTwoDigits,
      middleThreeDigits: widget.result.middleThreeDigits,
      letter: widget.result.letter,
      cityCode: widget.result.cityCode,
    );
  }

  Future<void> _confirm() async {
    if (!_plate.isComplete) {
      setState(() => _errorText = 'لطفاً همه بخش‌های پلاک را کامل کنید.');
      return;
    }
    if (_plate.normalized.isEmpty) {
      setState(() => _errorText = 'پلاک واردشده معتبر نیست.');
      return;
    }

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    try {
      await navigateForPlateLookup(
        ref: ref,
        router: GoRouter.of(context),
        plate: _plate,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
        _errorText = 'خطا در جستجوی خودرو. دوباره تلاش کنید.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final confidencePercent =
        (widget.result.confidence.clamp(0, 1) * 100).round();
    final imageExists = widget.result.imagePath.isNotEmpty &&
        File(widget.result.imagePath).existsSync();

    return Scaffold(
      appBar: const AppPageAppBar(title: 'تأیید پلاک'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            if (imageExists) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 7,
                  child: Image.file(
                    File(widget.result.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              widget.result.hasRecognizedPlate
                  ? 'پلاک را بررسی و در صورت نیاز اصلاح کنید'
                  : 'پلاک پیدا شد؛ شماره را تأیید یا وارد کنید',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (widget.result.confidence > 0) ...[
              const SizedBox(height: 8),
              Text(
                'اطمینان تشخیص: ${PersianDigitFormatter.intToPersian(confidencePercent)}٪',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            IranianPlateInput(
              initialValue: _plate,
              onChanged: (value) {
                setState(() {
                  _plate = value;
                  _errorText = null;
                });
              },
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _confirm,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text('تأیید و ادامه'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: AppTapTargets.large,
              child: OutlinedButton(
                onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                child: const Text('بازگشت به دوربین'),
              ),
            ),
            if (widget.result.rawText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'متن خام: ${widget.result.rawText}',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

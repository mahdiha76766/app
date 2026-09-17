import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../settings/data/providers.dart';
import '../data/providers.dart';
import '../domain/backup_models.dart';
import '../domain/safe_backup_log.dart';

/// بخش مدیریت داده با پشتیبان‌گیری، بازیابی و حذف امن.
class DataManagementSection extends ConsumerStatefulWidget {
  const DataManagementSection({super.key, required this.theme});

  final ThemeData theme;

  @override
  ConsumerState<DataManagementSection> createState() =>
      _DataManagementSectionState();
}

class _DataManagementSectionState extends ConsumerState<DataManagementSection> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return _SettingsCard(
      theme: theme,
      children: [
        _ActionTile(
          icon: Icons.backup_outlined,
          title: 'تهیه نسخه پشتیبان',
          subtitle: 'ذخیره و اشتراک همه اطلاعات برنامه',
          onTap: _busy ? null : _exportBackup,
        ),
        const Divider(height: 1),
        _ActionTile(
          icon: Icons.restore_outlined,
          title: 'بازیابی نسخه پشتیبان',
          subtitle: 'جایگزینی کامل یا ادغام با داده‌های فعلی',
          onTap: _busy ? null : _importBackup,
        ),
        const Divider(height: 1),
        _ActionTile(
          icon: Icons.history_outlined,
          title: 'بازیابی آخرین Snapshot اضطراری',
          subtitle: 'بازگردانی خودکار قبل از آخرین عملیات خطرناک',
          onTap: _busy ? null : _restoreLatestSnapshot,
        ),
        const Divider(height: 1),
        _DangerTile(
          icon: Icons.delete_outline,
          title: 'حذف تمام تاریخچه تعمیرات',
          subtitle: 'سوابق تعمیر، قطعات و فاکتورها',
          onTap: _busy ? null : () => _secureDeleteRepairs(context),
        ),
        const Divider(height: 1),
        _DangerTile(
          icon: Icons.directions_car_outlined,
          title: 'حذف تمام خودروها',
          subtitle: 'خودروها، مشتریان و سوابق مرتبط',
          onTap: _busy ? null : () => _secureDeleteVehicles(context),
        ),
        const Divider(height: 1),
        _DangerTile(
          icon: Icons.warning_amber_outlined,
          title: 'پاکسازی کامل برنامه',
          subtitle: 'غیرقابل بازگشت — نیاز به تأیید متنی',
          onTap: _busy ? null : () => _secureResetAll(context),
        ),
      ],
    );
  }

  Future<void> _exportBackup() async {
    setState(() => _busy = true);
    try {
      final file = await ref.read(backupServiceProvider).exportToFile();
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: 'پشتیبان NediCar',
          text: 'فایل پشتیبان NediCar',
        ),
      );
      if (!mounted) return;
      _snack('نسخه پشتیبان آماده شد.');
    } catch (e) {
      SafeBackupLog.error('export failed', e);
      if (!mounted) return;
      _snack('تهیه پشتیبان با خطا مواجه شد.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) {
      _snack('انتخاب فایل روی این دستگاه پشتیبانی نمی‌شود.', error: true);
      return;
    }

    setState(() => _busy = true);
    try {
      final file = File(path);
      final doc = await ref.read(backupServiceProvider).validateFile(file);
      if (!mounted) return;

      final mode = await _askRestoreMode(doc);
      if (mode == null || !mounted) return;

      final confirmed = await _confirmRestore(doc, mode);
      if (confirmed != true || !mounted) return;

      await ref.read(localSnapshotStoreProvider).createSnapshot(
            reason: 'before-restore',
          );
      await ref.read(backupServiceProvider).restore(doc, mode: mode);
      _invalidateAll();
      if (!mounted) return;
      _snack(
        mode == BackupRestoreMode.replace
            ? 'بازیابی با جایگزینی کامل انجام شد.'
            : 'بازیابی با ادغام انجام شد.',
      );
    } on BackupValidationException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (e) {
      SafeBackupLog.error('import failed', e);
      if (!mounted) return;
      _snack('بازیابی ناموفق بود؛ داده‌های قبلی حفظ شدند.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreLatestSnapshot() async {
    setState(() => _busy = true);
    try {
      final latest = await ref.read(localSnapshotStoreProvider).latestSnapshot();
      if (!mounted) return;
      if (latest == null) {
        _snack('Snapshot اضطراری موجود نیست.', error: true);
        return;
      }
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('بازیابی Snapshot'),
          content: const Text(
            'آخرین نسخه اضطراری محلی جایگزین داده‌های فعلی می‌شود. ادامه می‌دهید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('بازیابی'),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
      await ref.read(localSnapshotStoreProvider).restoreLatest();
      _invalidateAll();
      if (!mounted) return;
      _snack('Snapshot اضطراری بازیابی شد.');
    } on BackupValidationException catch (e) {
      if (!mounted) return;
      _snack(e.message, error: true);
    } catch (e) {
      SafeBackupLog.error('snapshot restore failed', e);
      if (!mounted) return;
      _snack('بازیابی Snapshot ناموفق بود.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<BackupRestoreMode?> _askRestoreMode(NediCarBackupDocument doc) {
    return showModalBottomSheet<BackupRestoreMode>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'نوع بازیابی',
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(_countsSummary(doc)),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: const Text('جایگزینی کامل'),
                  subtitle: const Text('همه داده‌های فعلی پاک و با فایل جایگزین می‌شود'),
                  onTap: () => Navigator.pop(ctx, BackupRestoreMode.replace),
                ),
                ListTile(
                  leading: const Icon(Icons.merge_type),
                  title: const Text('ادغام با داده‌های فعلی'),
                  subtitle: const Text('رکوردهای هم‌شناسه به‌روز می‌شوند؛ تکراری ساخته نمی‌شود'),
                  onTap: () => Navigator.pop(ctx, BackupRestoreMode.merge),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmRestore(
    NediCarBackupDocument doc,
    BackupRestoreMode mode,
  ) {
    final modeLabel = mode == BackupRestoreMode.replace
        ? 'جایگزینی کامل'
        : 'ادغام';
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تأیید بازیابی ($modeLabel)'),
        content: Text(
          '${_countsSummary(doc)}\n\n'
          'تاریخ پشتیبان: ${JalaliDateFormatter.formatWithTime(doc.createdAt.toLocal())}\n'
          'نسخه پشتیبان: ${PersianDigitFormatter.intToPersian(doc.backupVersion)}\n\n'
          '${mode == BackupRestoreMode.replace ? 'داده‌های فعلی حذف می‌شوند.' : 'داده‌های فعلی حفظ و ادغام می‌شوند.'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بازیابی'),
          ),
        ],
      ),
    );
  }

  String _countsSummary(NediCarBackupDocument doc) {
    final c = doc.counts;
    return 'خودرو: ${PersianDigitFormatter.intToPersian(c.vehicles)} · '
        'تعمیر/فاکتور: ${PersianDigitFormatter.intToPersian(c.repairs)} · '
        'یادآوری: ${PersianDigitFormatter.intToPersian(c.reminders)} · '
        'مشتری: ${PersianDigitFormatter.intToPersian(c.customers)}';
  }

  Future<void> _secureDeleteRepairs(BuildContext context) async {
    final step1 = await _confirmDialog(
      title: 'حذف تاریخچه تعمیرات',
      body:
          'تمام تعمیرها، قطعات ثبت‌شده روی تعمیر، فاکتورها و تراکنش‌های پرداخت حذف می‌شوند.\n'
          'این عمل به‌تنهایی قابل بازگشت نیست (مگر Backup/Snapshot داشته باشید).',
      confirmLabel: 'ادامه',
    );
    if (step1 != true || !mounted) return;

    final wantBackup = await _askBackupFirst();
    if (wantBackup == true) {
      await _exportBackup();
      if (!mounted) return;
    } else if (wantBackup == null) {
      return;
    }

    final step2 = await _confirmDialog(
      title: 'تأیید نهایی حذف تعمیرات',
      body: 'آیا از حذف تاریخچه تعمیرات مطمئن هستید؟',
      confirmLabel: 'حذف تعمیرات',
      destructive: true,
    );
    if (step2 != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(localSnapshotStoreProvider)
          .createSnapshot(reason: 'before-delete-repairs');
      await ref.read(appDatabaseForSettingsProvider).deleteAllRepairData();
      _invalidateAll();
      if (!mounted) return;
      _snack('تاریخچه تعمیرات حذف شد.');
    } catch (e) {
      SafeBackupLog.error('delete repairs failed', e);
      if (!mounted) return;
      _snack('حذف با خطا مواجه شد.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _secureDeleteVehicles(BuildContext context) async {
    final step1 = await _confirmDialog(
      title: 'حذف تمام خودروها',
      body:
          'تمام خودروها، مشتریان، تعمیرها، فاکتورها و یادآوری‌ها حذف می‌شوند.\n'
          'تنظیمات تعمیرگاه و حساب‌های بانکی حفظ می‌شوند.',
      confirmLabel: 'ادامه',
    );
    if (step1 != true || !mounted) return;

    final wantBackup = await _askBackupFirst();
    if (wantBackup == true) {
      await _exportBackup();
      if (!mounted) return;
    } else if (wantBackup == null) {
      return;
    }

    final step2 = await _confirmDialog(
      title: 'تأیید نهایی حذف خودروها',
      body: 'همه خودروها و داده‌های مرتبط حذف شوند؟',
      confirmLabel: 'حذف خودروها',
      destructive: true,
    );
    if (step2 != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(localSnapshotStoreProvider)
          .createSnapshot(reason: 'before-delete-vehicles');
      await ref.read(appDatabaseForSettingsProvider).deleteAllVehicleData();
      _invalidateAll();
      if (!mounted) return;
      _snack('تمام خودروها حذف شدند.');
    } catch (e) {
      SafeBackupLog.error('delete vehicles failed', e);
      if (!mounted) return;
      _snack('حذف با خطا مواجه شد.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _secureResetAll(BuildContext context) async {
    final step1 = await _confirmDialog(
      title: 'پاکسازی کامل برنامه',
      body:
          'هشدار جدی: تمام داده‌ها شامل تنظیمات تعمیرگاه، خودروها، مشتریان، '
          'تعمیرها، فاکتورها، پرداخت‌ها، یادآوری‌ها و حساب‌های بانکی حذف می‌شوند.\n\n'
          'این عملیات غیرقابل بازگشت است مگر نسخه پشتیبان داشته باشید.',
      confirmLabel: 'متوجه شدم، ادامه',
      destructive: true,
    );
    if (step1 != true || !mounted) return;

    final wantBackup = await _askBackupFirst(forceRecommend: true);
    if (wantBackup == true) {
      await _exportBackup();
      if (!mounted) return;
    } else if (wantBackup == null) {
      return;
    }

    final typed = await _askTypedConfirm();
    if (typed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(localSnapshotStoreProvider)
          .createSnapshot(reason: 'before-reset-all');
      await ref.read(appDatabaseForSettingsProvider).resetAll();
      _invalidateAll();
      if (!mounted) return;
      _snack('پاکسازی کامل انجام شد.');
    } catch (e) {
      SafeBackupLog.error('reset all failed', e);
      if (!mounted) return;
      _snack('پاکسازی با خطا مواجه شد.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _askBackupFirst({bool forceRecommend = false}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تهیه پشتیبان؟'),
        content: Text(
          forceRecommend
              ? 'قبل از پاکسازی کامل، اکیداً توصیه می‌شود نسخه پشتیبان بگیرید.'
              : 'قبل از حذف، می‌توانید نسخه پشتیبان تهیه کنید.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ادامه بدون پشتیبان'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تهیه پشتیبان'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _askTypedConfirm() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('تأیید متنی پاکسازی'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'برای تأیید، عبارت «${BackupConstants.resetConfirmPhrase}» را وارد کنید.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'عبارت تأیید',
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () {
                final ok = controller.text.trim() ==
                    BackupConstants.resetConfirmPhrase;
                Navigator.pop(ctx, ok);
              },
              child: const Text('پاکسازی کامل'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == false && mounted) {
      // کاربر انصراف داده
      return false;
    }
    if (result != true && mounted) {
      _snack('عبارت تأیید نادرست بود.', error: true);
      return false;
    }
    return result;
  }

  Future<bool?> _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                  )
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  void _invalidateAll() {
    ref.invalidate(workshopProvider);
    ref.invalidate(bankAccountsProvider);
  }

  void _snack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.theme, required this.children});

  final ThemeData theme;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}

class _DangerTile extends StatelessWidget {
  const _DangerTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.error),
      title: Text(
        title,
        style: TextStyle(color: theme.colorScheme.error),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}

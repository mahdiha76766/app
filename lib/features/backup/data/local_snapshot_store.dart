import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/backup_models.dart';
import '../domain/safe_backup_log.dart';
import 'backup_service.dart';

/// Snapshot خودکار محلی قبل از عملیات خطرناک.
class LocalSnapshotStore {
  LocalSnapshotStore(this._backup);

  final BackupService _backup;

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'nedicar_snapshots'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> createSnapshot({String reason = 'auto'}) async {
    final dir = await _dir();
    final stamp = DateTime.now()
        .toLocal()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final safeReason = reason.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final target = File(
      p.join(dir.path, 'snapshot-$safeReason-$stamp.json'),
    );
    final exported = await _backup.exportToFile(directory: dir);
    if (await target.exists()) {
      await target.delete();
    }
    await exported.rename(target.path);
    await _prune();
    SafeBackupLog.info('snapshot created reason=$safeReason');
    return target;
  }

  Future<List<File>> listSnapshots() async {
    final dir = await _dir();
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.json'))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<File?> latestSnapshot() async {
    final files = await listSnapshots();
    return files.isEmpty ? null : files.first;
  }

  Future<void> restoreLatest() async {
    final file = await latestSnapshot();
    if (file == null) {
      throw BackupValidationException('هیچ نسخهٔ اضطراری محلی یافت نشد.');
    }
    final doc = await _backup.validateFile(file);
    await _backup.restore(doc, mode: BackupRestoreMode.replace);
  }

  Future<void> _prune() async {
    final files = await listSnapshots();
    if (files.length <= BackupConstants.maxLocalSnapshots) {
      return;
    }
    for (final file in files.skip(BackupConstants.maxLocalSnapshots)) {
      try {
        await file.delete();
      } catch (_) {
        // ignore prune errors
      }
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/backup_service.dart';
import '../data/local_snapshot_store.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(appDatabaseProvider));
});

final localSnapshotStoreProvider = Provider<LocalSnapshotStore>((ref) {
  return LocalSnapshotStore(ref.watch(backupServiceProvider));
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/repositories/assistant_api_client.dart';
import '../domain/repositories/assistant_chat_repository.dart';
import 'repositories/assistant_chat_repository_impl.dart';
import 'services/http_assistant_api_client.dart';
import 'services/install_id_store.dart';

final installIdStoreProvider = Provider<InstallIdStore>((ref) {
  return InstallIdStore();
});

final assistantApiClientProvider = Provider<AssistantApiClient>((ref) {
  return HttpAssistantApiClient();
});

final assistantChatRepositoryProvider = Provider<AssistantChatRepository>((ref) {
  return AssistantChatRepositoryImpl(ref.watch(appDatabaseProvider));
});

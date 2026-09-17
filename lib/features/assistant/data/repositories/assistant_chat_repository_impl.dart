import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/assistant_models.dart';
import '../../domain/repositories/assistant_chat_repository.dart';

class AssistantChatRepositoryImpl implements AssistantChatRepository {
  AssistantChatRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<AssistantChatMessage>> listForRepair(String repairOrderId) async {
    final rows = await (_db.select(_db.assistantMessages)
          ..where((t) => t.repairOrderId.equals(repairOrderId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> appendUserMessage({
    required String id,
    required String repairOrderId,
    required String content,
    required DateTime createdAt,
  }) {
    return _db.into(_db.assistantMessages).insert(
          AssistantMessagesCompanion.insert(
            id: id,
            repairOrderId: repairOrderId,
            role: 'user',
            content: content,
            createdAt: createdAt,
          ),
        );
  }

  @override
  Future<void> appendAssistantMessage({
    required String id,
    required String repairOrderId,
    required AssistantReply reply,
    required DateTime createdAt,
  }) {
    return _db.into(_db.assistantMessages).insert(
          AssistantMessagesCompanion.insert(
            id: id,
            repairOrderId: repairOrderId,
            role: 'assistant',
            content: jsonEncode(reply.toJson()),
            createdAt: createdAt,
          ),
        );
  }

  AssistantChatMessage _toDomain(AssistantMessageRow row) {
    AssistantReply? reply;
    if (row.role == 'assistant') {
      try {
        final map = jsonDecode(row.content);
        if (map is Map<String, dynamic>) {
          reply = AssistantReply.fromJson(map);
        } else if (map is Map) {
          reply = AssistantReply.fromJson(Map<String, dynamic>.from(map));
        }
      } catch (_) {
        reply = null;
      }
    }
    return AssistantChatMessage(
      id: row.id,
      repairOrderId: row.repairOrderId,
      role: row.role,
      content: row.content,
      createdAt: row.createdAt,
      reply: reply,
    );
  }
}

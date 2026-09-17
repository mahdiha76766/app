import '../entities/assistant_models.dart';

abstract class AssistantChatRepository {
  Future<List<AssistantChatMessage>> listForRepair(String repairOrderId);

  Future<void> appendUserMessage({
    required String id,
    required String repairOrderId,
    required String content,
    required DateTime createdAt,
  });

  Future<void> appendAssistantMessage({
    required String id,
    required String repairOrderId,
    required AssistantReply reply,
    required DateTime createdAt,
  });
}

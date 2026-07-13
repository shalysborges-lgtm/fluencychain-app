enum ChatRole { user, assistant }

class ChatMessage {
  const ChatMessage({required this.role, required this.text});
  final ChatRole role;
  final String text;
}

enum SimulationType { interview, meeting, presentation }

class SimulationOption {
  const SimulationOption({required this.type, required this.titlePt, required this.scenarioCode});
  final SimulationType type;
  final String titlePt;
  final String scenarioCode;
}

/// Espelha `POST /ai-tutor/chat` e as rotas `/ai-simulation/*` (Etapa 16).
abstract class AiTutorRepository {
  Future<ChatMessage> sendChatMessage(List<ChatMessage> history, String newMessage);
  List<SimulationOption> getAvailableSimulations();
}

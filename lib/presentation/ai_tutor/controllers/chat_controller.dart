import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/ai_tutor.dart';

class ChatState {
  const ChatState({this.messages = const [], this.isSending = false, this.errorMessage});
  final List<ChatMessage> messages;
  final bool isSending;
  final String? errorMessage;

  ChatState copyWith({List<ChatMessage>? messages, bool? isSending, String? errorMessage}) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}

/// Chat livre / tira-dúvidas (RF06.7, RF06.8). Cota de uso é aplicada no
/// backend (AiQuotaGuard — Etapa 15); aqui só exibimos o erro 429 de
/// forma amigável quando ele chegar.
class ChatController extends StateNotifier<ChatState> {
  ChatController(this._repository) : super(const ChatState());

  final AiTutorRepository _repository;

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(role: ChatRole.user, text: text);
    state = state.copyWith(messages: [...state.messages, userMessage], isSending: true, errorMessage: null);

    try {
      final reply = await _repository.sendChatMessage(state.messages, text);
      state = state.copyWith(messages: [...state.messages, reply], isSending: false);
    } catch (e) {
      final message = e.toString().contains('429')
          ? 'Você atingiu sua cota diária de mensagens com o Tutor. Volta amanhã!'
          : 'Não conseguimos enviar sua mensagem agora.';
      state = state.copyWith(isSending: false, errorMessage: message);
    }
  }
}

final aiTutorRepositoryProvider = Provider<AiTutorRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real em main.dart');
});

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController(ref.watch(aiTutorRepositoryProvider));
});

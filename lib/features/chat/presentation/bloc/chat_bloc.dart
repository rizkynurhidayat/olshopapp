import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message.dart';

// Events
abstract class ChatEvent {}
class SendMessage extends ChatEvent {
  final String text;
  SendMessage(this.text);
}
class ReceiveMessage extends ChatEvent {
  final String text;
  ReceiveMessage(this.text);
}

// State
class ChatState {
  final List<Message> messages;
  ChatState({required this.messages});
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState(messages: [
    Message(
      id: '1', 
      text: 'Halo! Ada yang bisa kami bantu hari ini?', 
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)), 
      isMe: false
    ),
  ])) {
    on<SendMessage>((event, emit) {
      final newMessage = Message(
        id: DateTime.now().toString(),
        text: event.text,
        timestamp: DateTime.now(),
        isMe: true,
      );
      final updatedMessages = List<Message>.from(state.messages)..add(newMessage);
      emit(ChatState(messages: updatedMessages));

      // Mock auto-reply from seller after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        add(ReceiveMessage('Terima kasih telah menghubungi kami. Tim kami akan segera membalas pesan Anda.'));
      });
    });

    on<ReceiveMessage>((event, emit) {
      final replyMessage = Message(
        id: DateTime.now().toString(),
        text: event.text,
        timestamp: DateTime.now(),
        isMe: false,
      );
      final updatedMessages = List<Message>.from(state.messages)..add(replyMessage);
      emit(ChatState(messages: updatedMessages));
    });
  }
}

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'chatbot_student_event.dart';
import 'chatbot_student_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatbotState> {
  ChatBloc() : super(ChatbotInitial()) {
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  final String _apiUrl = 'http://10.0.2.2:5005/webhooks/rest/webhook';
  final List<types.Message> _messages = [];

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoading());
    try {
      final userMessage = types.TextMessage(
        author: const types.User(id: 'user'),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: event.message,
      );
      _messages.insert(0, userMessage);
      emit(ChatbotLoaded(List.from(_messages)));

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender': 'user',
          'message': event.message,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        for (var item in responseData) {
          if (item['text'] != null) {
            add(ReceiveMessage(item['text']));
          }
        }
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatbotState> emit) {
    final botMessage = types.TextMessage(
      author: const types.User(id: 'bot'),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.message,
    );
    _messages.insert(0, botMessage);
    emit(ChatbotLoaded(List.from(_messages)));
  }
}

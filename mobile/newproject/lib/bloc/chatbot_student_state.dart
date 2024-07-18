import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<types.Message> messages;

  const ChatbotLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatbotError extends ChatbotState {
  final String error;

  const ChatbotError(this.error);

  @override
  List<Object> get props => [error];
}

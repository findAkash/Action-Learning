import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chatbot_student_bloc.dart';
import '../bloc/chatbot_student_event.dart';
import '../bloc/chatbot_student_state.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      _chatBloc.add(SendMessage(_textController.text));
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Student Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatbotState>(
              builder: (context, state) {
                if (state is ChatbotInitial) {
                  return const Center(child: Text('Start a conversation!'));
                } else if (state is ChatbotLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatbotLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isUserMessage = message.author.id == 'user';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: isUserMessage
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (message as types.TextMessage).text,
                              style: TextStyle(
                                  color: isUserMessage
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatbotError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

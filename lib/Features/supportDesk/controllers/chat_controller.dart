import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatController {
  List<ChatMessage> messages = [];

  void addUserMessage(String message) {
    messages.add(ChatMessage(text: message, isUser: true));
  }

  void addChatbotMessage(String message) {
    messages.add(ChatMessage(text: message, isUser: false));
  }
}

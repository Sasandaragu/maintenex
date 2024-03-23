import 'package:flutter/material.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = ChatController();
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<String> questions = [
    "How to add a maintenance record ?",
    "How to view mileage ?",
    "How to set reminders ?",
    "How to view how much fuel added ?",
    "How to add a new profile ?",
    "How to delete a profile ?",
    "How to update my profile ?",
    "View new features",
    "Contact an Support officer"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help Desk",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: _chatController.messages.length + questions.length,
              itemBuilder: (context, index) {
                if (index < questions.length) {
                  // Render question button
                  return _buildQuestionButton(questions[index]);
                } else {
                  // Render chat message
                  return _buildMessageBubble(
                    _chatController.messages[index - questions.length],
                  );
                }
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildQuestionButton(String question) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: ElevatedButton(
          onPressed: () {
            _handleUserInput(question);
          },
          child: Text(
            question,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      margin: EdgeInsets.only(right: 16.0, bottom: 36.0, left: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleUserInput,
                  decoration: const InputDecoration(
                    hintText: "Bingo !!! How can I help you ?",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 147, 147, 147),
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0, // Adjust the font size as needed
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  String message = _textController.text.trim();
                  if (message.isNotEmpty) {
                    _handleUserInput(message);
                    _textController.clear();
                  }
                },
              ),
              Positioned(
                bottom: 100.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: _scrollToBottom,
                  mini: true,
                  backgroundColor: Color(0xFFE0E0E0),
                  foregroundColor: Color.fromARGB(255, 0, 0, 0),
                  splashColor: Color(0xFFE0E0E0),
                  elevation: 0.0,
                  child: Icon(Icons.arrow_downward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    Color bubbleColor =
        message.isUser ? Color.fromARGB(255, 0, 0, 0) : Colors.blue;
    Color textColor = message.isUser ? Colors.white : Colors.white;
    String label = message.isUser ? "User:" : "Help Desk:";

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUserInput(String message) {
    setState(() {
      _chatController.addUserMessage(message);
    });
    _simulateChatbotResponse(message);
    _textController.clear();
  }

  void _simulateChatbotResponse(String userMessage) {
    // Simulate a delay of 3 seconds (adjust as needed)
    Future.delayed(Duration(seconds: 3), () {
      String answer = "";

      if (userMessage
          .toLowerCase()
          .contains("how to add a maintenance record")) {
        answer = "Home page > Add maintenance record";
      } else if (userMessage.toLowerCase().contains("how to view mileage")) {
        answer = "Home Menu > Mileage";
      } else if (userMessage.toLowerCase().contains("how to set reminders")) {
        answer = "Quick Actions > Set reminder > Add new Reminder";
      } else if (userMessage
          .toLowerCase()
          .contains("how to view how much fuel added")) {
        answer = "Home Menu > Click on fuel Data";
      } else if (userMessage
          .toLowerCase()
          .contains("how to add a new profile")) {
        answer = "Vehicle > Select (+) icon at the end of the dropdown menu";
      } else if (userMessage
          .toLowerCase()
          .contains("how to delete a profile")) {
        answer = "Home Menu > Account > Manage Profiles > Delete Profile";
      } else if (userMessage
          .toLowerCase()
          .contains("how to update my profile")) {
        answer = "Home Menu > Account > Manage Profiles > Change Password";
      } else if (userMessage.toLowerCase().contains("view new features")) {
        answer = "Home Menu > Mileage";
      } else if (userMessage
          .toLowerCase()
          .contains("contact an support officer")) {
        answer = "Contact us on sample@gmail.com";
      } else {
        answer =
            "Oops !! I'm not an AI Model. Please go on with Pre-defined Questions.";
      }

      setState(() {
        _scrollToBottom();
        _chatController.addChatbotMessage(answer);
        _scrollToBottom();
      });
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}

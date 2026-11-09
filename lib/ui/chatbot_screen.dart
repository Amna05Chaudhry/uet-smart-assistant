import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreen createState() => _ChatbotScreen();
}

class _ChatbotScreen extends State<ChatbotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot Screen'),
      ),
      body: Center(
        child: Text(
          'This is chatbot',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


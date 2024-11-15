import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Chatroom extends StatefulWidget {
  const Chatroom({super.key});

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  List<ChatMessage> _messages = <ChatMessage>[];
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'User', lastName: 'User');
  final ChatUser gptuser =
      ChatUser(id: '2', firstName: 'chat', lastName: 'gpt');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: DashChat(
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
              currentUserContainerColor: Colors.black,
              containerColor: Colors.blue,
              textColor: Colors.white),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    // Add the user's message to the chat
    setState(() {
      _messages.insert(0, m);
    });

    // Send the message to your backend
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3000/api/gpt'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': m.text}), // Send the user's message
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botReply = responseData['reply'];

        // Create the bot's message
        ChatMessage botMessage = ChatMessage(
          text: botReply,
          user: gptuser,
          createdAt: DateTime.now(),
        );

        // Add the bot's message to the chat
        setState(() {
          _messages.insert(0, botMessage);
        });
      } else {
        final responseData = json.decode(response.body);

        // Handle error response
        ChatMessage errorMessage = ChatMessage(
          text: 'Error: ${response.statusCode} ${responseData['Error']}',
          user: gptuser,
          createdAt: DateTime.now(),
        );

        setState(() {
          _messages.insert(0, errorMessage);
        });
      }
    } catch (error) {
      // Handle network error
      ChatMessage errorMessage = ChatMessage(
        text: 'Error: Unable to connect to the server.',
        user: gptuser,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.insert(0, errorMessage);
      });
    }
  }
}

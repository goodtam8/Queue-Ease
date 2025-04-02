import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notilist extends StatefulWidget {
  const Notilist({super.key});

  @override
  State<Notilist> createState() => _NotilistState();
}

class _NotilistState extends State<Notilist> {
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList('messages') ?? [];
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1578E6),
      ),
      backgroundColor: Colors.white,
      body: _messages.isEmpty
          ? Center(child: Text('No messages found.'))
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = jsonDecode(_messages[index]);
                return ListTile(
                  title: Text(message['title'] ?? 'No Title'),
                  subtitle: Text(message['body'] ?? 'No Body'),
                );
              },
            ),
    );
  }
}

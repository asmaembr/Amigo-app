import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: "1", firstName: "YOU");
  ChatUser bot = ChatUser(id: "2", firstName: "Amigo");
  List<ChatMessage> messages = [];
  List<ChatUser> typing = [];

  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyC6Me5NCA6Q44YZV884YNN0YBbqcsLdc4E';
  final header = {'Content-Type': 'application/json'};

  getData(ChatMessage m) async {
    typing.add(bot);
    messages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        ChatMessage m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        messages.insert(0, m1);
      } else {
        print("Error Occurred");
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigo'),
        backgroundColor: Color.fromARGB(255, 27, 28, 38),
      ),
      backgroundColor: Color.fromARGB(255, 27, 28, 38),
      body: DashChat(
        messageOptions: const MessageOptions(
          showTime: false,
          textColor: Colors.white,
          containerColor: Color(0xFF35374B),
        ),
        typingUsers: typing,
        currentUser: myself,
        onSend: (ChatMessage m) {
          getData(m);
        },
        messages: messages,
      ),
    );
  }
}

import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  late String apiUrl;

  final header = {'Content-Type': 'application/json'};

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final apiKey = await rootBundle.loadString('lib/config/api_key.txt');
      final trimmedKey = apiKey.trim();

      if (trimmedKey.isEmpty) {
        throw 'API key file is empty';
      }

      setState(() {
        apiUrl =
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$trimmedKey';
      });
      print('API key loaded from asset file');
    } catch (e) {
      print('Error loading API key: $e');
      _showErrorDialog('API Configuration Error',
          'Failed to load API key from lib/config/api_key.txt. Please check the file exists and contains a valid API key.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: header,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        ChatMessage m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        messages.insert(0, m1);
      } else {
        print("Error ${response.statusCode}: ${response.body}");
        messages.insert(
          0,
          ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
            text: "Sorry, I couldn't get a response. Please try again.",
          ),
        );
      }
    } catch (e) {
      print("Exception: $e");
      messages.insert(
        0,
        ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: "A network error occurred. Please check your connection.",
        ),
      );
    }

    typing.remove(bot);
    setState(() {});
  }

  Widget _buildMessageText(
      ChatMessage msg, ChatMessage? previous, ChatMessage? next) {
    final isBot = msg.user.id == bot.id;

    if (isBot) {
      return MarkdownBody(
        data: msg.text,
        shrinkWrap: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
          strong: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          em: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 15),
          code: const TextStyle(
            color: Colors.greenAccent,
            backgroundColor: Color(0xFF2A2C3E),
            fontFamily: 'monospace',
            fontSize: 13,
          ),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF2A2C3E),
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: const TextStyle(color: Colors.white70, fontSize: 15),
          listBullet: const TextStyle(color: Colors.white, fontSize: 15),
          h1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          h2: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          h3: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      );
    }

    return Text(
      msg.text,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigo'),
        backgroundColor: const Color.fromARGB(255, 27, 28, 38),
      ),
      backgroundColor: const Color.fromARGB(255, 27, 28, 38),
      body: DashChat(
        messageOptions: MessageOptions(
          showTime: false,
          containerColor: const Color(0xFF35374B),
          currentUserContainerColor: const Color(0xFF4A4E6A),
          textColor: Colors.white,
          currentUserTextColor: Colors.white,
          messageTextBuilder: _buildMessageText,
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
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gemini extends StatefulWidget {
  const Gemini({super.key});

  @override
  State<Gemini> createState() => _GeminiState();
}
// AIzaSyBi8FqU87zs0Afkdt_oL_GyIDVEywJdW1o

class _GeminiState extends State<Gemini> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Siddhesh');
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');
  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  String Prompt = '''The list of skills required for the job position are: [Frontend Development: HTML, CSS, JavaScript Development, React.js Development, UI/UX Design (optional)
  Backend Development: Django, Flask, Node.js, Python Programming, Java Development (optional), PHP Development (optional), Full Stack Web Development, SQL Database Management, NoSQL Database Management, API Development, GraphQL
  DevOps Practices: Git Version Control, Docker, Kubernetes (optional)].
  The candidate's resume skills are: [C Programming Language, C++ Programming Language, Git, Java Programming Language, Leadership, Structured Query Language, Version Control].
  Please calculate the percentage match between the required skills and the candidate's skills. Provide me only single number answer as the final score as a two-digit integer (rounded down). 
  important: wrap that 2 digit number in double quotes like "42"''';
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBi8FqU87zs0Afkdt_oL_GyIDVEywJdW1o';
  // https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY
  final header = {
    'Content-Type': 'application/json',
  };
  getData(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": Prompt}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now());
        allMessages.insert(0, m1);
      } else {
        print("error occured");
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
          typingUsers: typing,
          currentUser: myself,

          onSend: (ChatMessage m) {
            getData(m);
            setState(() {});
          },
          messages: allMessages),
    );
  }
}
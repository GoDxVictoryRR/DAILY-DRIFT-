import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'WeeklyChart.dart';
import 'Dailyring.dart';
import 'task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDay = 'Monday';
  final TextEditingController _chatController = TextEditingController();
  List<String> _chatMessages = [];
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasksFromFirestore();
  }

  Future<void> _fetchTasksFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();

    final fetchedTasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        title: data['title'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        day: data['day'] ?? '',
        deadline: data['deadline']?.toDate(), // if you store deadline as Timestamp
      );
    }).toList();

    setState(() => tasks = fetchedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildDayNavigationBar(),
            _buildChatAssistant(),
            _buildProgressCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
    child: Center(
      child: Text(
        "Home",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildDayNavigationBar() => Container(
    height: 45,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: _days.map((day) {
        return GestureDetector(
          onTap: () => setState(() => selectedDay = day),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: selectedDay == day ? Colors.limeAccent : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: selectedDay == day ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );

  Widget _buildChatAssistant() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.smart_toy, color: Colors.limeAccent),
              SizedBox(width: 8),
              Text("AI Assistant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _chatMessages.map((msg) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text("• $msg", style: TextStyle(color: Colors.white70)),
                )).toList(),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ask something...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.limeAccent),
                onPressed: _handleSend,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildProgressCharts() => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          WeeklyChart(tasks: tasks),
          SizedBox(height: 22),
          DailyProgressRing(tasks: tasks, selectedDay: selectedDay),
        ],
      ),
    ),
  );

  void _handleSend() async {
    String input = _chatController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _chatMessages.add("🧑‍💻 You: $input");
      _chatController.clear();
    });

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    const String openAIApiKey = "sk-proj-XXX..."; // 🔐 Hide this in production

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $openAIApiKey",
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful productivity assistant."},
        {"role": "user", "content": input},
      ],
      "temperature": 0.7,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final reply = jsonDecode(response.body)['choices'][0]['message']['content'];
        setState(() {
          _chatMessages.add("🤖 Assistant: $reply");
        });
      } else {
        setState(() {
          _chatMessages.add("❌ Assistant: Failed (Status: ${response.statusCode})");
        });
      }
    } catch (e) {
      setState(() {
        _chatMessages.add("⚠️ Assistant: Error - $e");
      });
    }
  }

  List<String> get _days => [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}

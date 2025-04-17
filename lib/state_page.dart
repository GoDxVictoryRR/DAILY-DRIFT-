import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedDay = 'Monday';
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();

    final loadedTasks = snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        id: doc.id,
        title: data['title'] ?? '',
        isCompleted: data['isCompleted'] ?? false,
        day: data['day'] ?? '',
        deadline: data['deadline']?.toDate(),
      );
    }).toList();

    setState(() => tasks = loadedTasks);
  }

  Future<void> _toggleTaskCompletion(Task task, bool? isDone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || task.id == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id!)
        .update({'isCompleted': isDone});

    _fetchTasks();
  }

  Future<void> _deleteTask(Task task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || task.id == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id!)
        .delete();

    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) => task.day == selectedDay).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 🔤 Page Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 📅 Day filter bar
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: _days.map((day) => GestureDetector(
                  onTap: () => setState(() => selectedDay = day),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedDay == day ? Colors.greenAccent : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        day.substring(0, 3),
                        style: TextStyle(
                          color: selectedDay == day ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),

            // ✅ Task list
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                child: Text(
                  "No tasks for $selectedDay",
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, i) {
                  final task = filteredTasks[i];
                  return Dismissible(
                    key: ValueKey(task.title + task.deadline.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _deleteTask(task),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (val) => _toggleTaskCompletion(task, val),
                        activeColor: Colors.greenAccent,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        "Deadline: ${_formatTime(task.deadline)}",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? deadline) {
    if (deadline == null) return "No deadline";
    final time = TimeOfDay.fromDateTime(deadline);
    return time.format(context);
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

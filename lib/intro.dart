import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'notifications_page.dart';
import 'state_page.dart';
import 'profile_page.dart';
import 'task.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex = 0;
  List<String> _notifications = [];

  bool isDarkMode = true;

  void onThemeToggle(bool value) {
    setState(() => isDarkMode = value);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void scheduleTaskReminders(Task task) {
    if (task.deadline == null) return;

    final now = DateTime.now();
    final deadline = task.deadline!;
    final int minutesUntilDeadline = deadline.difference(now).inMinutes;

    if (minutesUntilDeadline <= 0) return;

    final int halfTime = (minutesUntilDeadline / 2).floor();

    Timer(Duration(minutes: halfTime), () {
      print("⏰ Reminder Timer Fired for: ${task.title}");
      final formattedTime = TimeOfDay.fromDateTime(deadline).format(context);
      _notifications.add("Reminder: '${task.title}' is due at $formattedTime");
      setState(() {});
    });

    Timer(Duration(minutes: minutesUntilDeadline), () {
      print("❗ Failure Timer Fired for: ${task.title}");
      if (!task.isCompleted) {
        _notifications.add("❌ Failed to complete '${task.title}' before deadline");
        setState(() {});
      }
    });

    final formattedDeadline = TimeOfDay.fromDateTime(deadline).format(context);
    print("⏳ Task '${task.title}' scheduled with $halfTime min to reminder, $minutesUntilDeadline min to deadline ($formattedDeadline).");
  }

  void _showAddTaskSheet(BuildContext context) {
    final TextEditingController _taskController = TextEditingController();
    TimeOfDay? selectedTime;
    String selectedDay = 'Monday';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Add New Task", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  TextField(
                    controller: _taskController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    dropdownColor: Colors.grey[800],
                    value: selectedDay,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    isExpanded: true,
                    underline: Container(height: 1, color: Colors.white24),
                    items: [
                      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
                    ].map((day) {
                      return DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => selectedDay = value);
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: Text("Pick Deadline Time"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String taskName = _taskController.text.trim();
                      if (taskName.isNotEmpty && selectedTime != null) {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final now = DateTime.now();
                        final deadlineDateTime = DateTime(
                          now.year, now.month, now.day,
                          selectedTime!.hour, selectedTime!.minute,
                        );

                        final newTask = Task(
                          id: Uuid().v4(),
                          title: taskName,
                          isCompleted: false,
                          day: selectedDay,
                          deadline: deadlineDateTime,
                        );

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('tasks')
                            .doc(newTask.id!)
                            .set({
                          'title': newTask.title,
                          'isCompleted': newTask.isCompleted,
                          'day': newTask.day,
                          'deadline': Timestamp.fromDate(newTask.deadline!),
                        });

                        scheduleTaskReminders(newTask);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Add Task"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.limeAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(), // Now fetches from Firestore internally
      ActivityPage(), // Same
      NotificationsPage(
        notifications: _notifications,
        onNotificationsUpdated: (updatedList) {
          setState(() {
            _notifications = updatedList;
          });
        },
      ),
      ProfilePage(isDarkMode: isDarkMode, onThemeToggle: onThemeToggle),
    ];

    final List<IconData> _icons = [
      Icons.home_outlined,
      Icons.bar_chart,
      Icons.notifications_none,
      Icons.person_outline,
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(child: _pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.limeAccent.shade400,
        onPressed: () => _showAddTaskSheet(context),
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.grey.shade900,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(_icons[0], color: _selectedIndex == 0 ? Colors.greenAccent : Colors.white70),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(_icons[1], color: _selectedIndex == 1 ? Colors.greenAccent : Colors.white70),
              onPressed: () => _onItemTapped(1),
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(_icons[2], color: _selectedIndex == 2 ? Colors.greenAccent : Colors.white70),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(_icons[3], color: _selectedIndex == 3 ? Colors.greenAccent : Colors.white70),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}

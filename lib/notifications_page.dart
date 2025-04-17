/*import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final List<String> notifications;

  const NotificationsPage({required this.notifications});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "Notifications",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ...widget.notifications.map((note) => ListTile(
              title: Text(note, style: TextStyle(color: Colors.white)),
            )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  NotificationsPage({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      notifications[index],
                      style: TextStyle(color: Colors.white),
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
}
*/
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final List<String> notifications;
  final void Function(List<String>) onNotificationsUpdated;

  NotificationsPage({
    required this.notifications,
    required this.onNotificationsUpdated,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<String> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(widget.notifications);
  }

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
      widget.onNotificationsUpdated(_notifications); // Update parent state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: ValueKey(notification + index.toString()), // Unique key
                  direction: DismissDirection.startToEnd, // Swipe right to delete
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _removeNotification(index),
                  child: ListTile(
                    title: Text(
                      notification,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

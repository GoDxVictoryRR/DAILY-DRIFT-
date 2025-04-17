import 'package:flutter/material.dart';
import 'task.dart';
class WeeklyChart extends StatelessWidget {
  final List<Task> tasks;

  WeeklyChart({required this.tasks});

  double _completionFor(String day) {
    final dailyTasks = tasks.where((t) => t.day == day);
    if (dailyTasks.isEmpty) return 0;
    final completed = dailyTasks.where((t) => t.isCompleted).length;
    return completed / dailyTasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Weekly Progress", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((shortDay) {
              final percent = _completionFor(_fullDay(shortDay));
              return Column(
                children: [
                  Container(
                    height: 60,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.limeAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: percent,
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(shortDay, style: TextStyle(color: Colors.white)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _fullDay(String shortDay) {
    switch (shortDay) {
      case 'Mon':
        return 'Monday';
      case 'Tue':
        return 'Tuesday';
      case 'Wed':
        return 'Wednesday';
      case 'Thu':
        return 'Thursday';
      case 'Fri':
        return 'Friday';
      case 'Sat':
        return 'Saturday';
      case 'Sun':
        return 'Sunday';
      default:
        return '';
    }
  }
}

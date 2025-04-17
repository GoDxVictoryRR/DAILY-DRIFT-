import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'task.dart';

class DailyProgressRing extends StatelessWidget {
  final List<Task> tasks;
  final String selectedDay;

  DailyProgressRing({required this.tasks, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final dailyTasks = tasks.where((t) => t.day == selectedDay).toList();
    final total = dailyTasks.length;
    final done = dailyTasks.where((t) => t.isCompleted).length;

    final percent = total == 0 ? 0.0 : done / total;

    return Center(
      child: CircularPercentIndicator(
        radius: 100.0,
        lineWidth: 15.0,
        animation: true,
        percent: percent,
        center: Text(
          "${(percent * 100).toStringAsFixed(0)}%\ncompleted",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.greenAccent,
        backgroundColor: Colors.grey[700]!,
      ),
    );
  }
}

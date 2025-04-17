import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String title;
  final DateTime? deadline;
  final String day;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.deadline,
    required this.day,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'day': day,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      deadline: (map['deadline'] as Timestamp?)?.toDate(),
      day: map['day'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

/*
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String name;
  final DateTime? deadline; // changed from TimeOfDay
  final String day;
  bool isDone;

  Task({
    required this.id,
    required this.name,
    this.deadline,
    required this.day,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'deadline': deadline, // Firestore will store as Timestamp
      'day': day,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      name: map['name'],
      deadline: map['deadline']?.toDate(),
      day: map['day'],
      isDone: map['isDone'] ?? false,
    );
  }
}
*/
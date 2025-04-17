import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void saveTask(String title, String description, DateTime deadline) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("tasks")
        .add({
      "title": title,
      "description": description,
      "deadline": deadline.toIso8601String(),
      "completed": false,
      "createdAt": Timestamp.now(),
    });
  }
}

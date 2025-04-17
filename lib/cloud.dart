import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class TaskService {
  final _firestore = FirebaseFirestore.instance;
  final String userId; // Unique user ID (from FirebaseAuth)

  TaskService(this.userId);

  Future<void> saveTask(Task task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  Future<List<Task>> fetchTasks() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    return snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id)) // ✅ fixed here
        .toList();
  }

  Future<void> updateTask(Task task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(id)
        .delete();
  }
}

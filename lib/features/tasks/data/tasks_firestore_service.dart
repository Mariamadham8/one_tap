import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_tap/core/models/task_model.dart';

class TasksFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _tasksCollection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }

    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  Future<List<TaskModel>> fetchTasks() async {
    final snapshot = await _tasksCollection().get();

    return snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Future<TaskModel> addTask(TaskModel task) async {
    final docRef = await _tasksCollection().add(task.toMap());
    return task.copyWith(id: docRef.id);
  }

  Future<void> updateTask(TaskModel task) async {
    final taskId = task.id;
    if (taskId == null || taskId.isEmpty) return;

    await _tasksCollection().doc(taskId).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) return;
    await _tasksCollection().doc(taskId).delete();
  }
}
